require 'msgpack'
require 'socket'
require 'logger'
require 'redis'
require 'time'
require 'oj'

require '../battle'
require '../battle_member'

class DirectBattleServer # rubocop:disable Metrics/ClassLength
  attr_accessor :server, :slots, :fps

  HOST = '0.0.0.0'
  PORT = 9003
  SLOTS = 60
  TIMEOUT = 60
  REDIS = Redis.new(host: 'redis', port: 6379)
  REDIS_KEY = 'mo_battles'
  REDIS_SESSIONS_KEY = 'mo_sessions'

  def initialize
    REDIS.del(REDIS_KEY)
    @server = TCPServer.new HOST, PORT
    @slots = []
    @fps = 0
    run
  end

  private

  def run
    $stdout.sync = true
    logger = Logger.new($stdout)
    logger.info("

    -===≡≡≡ (ง)ว
    -===≡≡≡ (ง)ว
    -===≡≡≡ (ง)ว  - - BATTLE SERVER IS LISTENING ON #{HOST}:#{PORT} - -
    -===≡≡≡ (ง)ว
    -===≡≡≡ (ง)ว
    ")
    Thread.start do
      process_timouts
    end
    loop do
      Thread.start(@server.accept) do |client|
        listen_commands(client)
      end
    end
  end

  def process_timouts
    loop do
      sleep 1
      puts "[stats] Server fps: #{fps} #{"[#{@slots.length}/#{SLOTS}]"}" unless @slots.empty?
      battles.each do |battle|
        next unless (Time.now - battle.time) > TIMEOUT

        puts "[timeout] Battle time out: #{battle.id}"
        battle.attackers.each do |attacker|
          slots.delete(attacker.id)
        end
        battle.defenders.each do |defender|
          slots.delete(defender.id)
        end
        delete_battle(battle.id)
      end
    end
  end

  def listen_commands(client)
    loop do
      cmd = client&.gets&.chomp

      return if cmd.nil? || cmd == ''

      p "cmd: #{cmd}"

      request = begin
        MessagePack.unpack(cmd)
      rescue
        {}
      end

      p "request: #{request}"

      case request['action']
      when 'create'
        create(client, request)
      when 'join'
        join(client, request)
      when 'ping'
        ping(client, request)
      when 'hit'
        hit(client, request)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def create(client, request)
    session_id = request['Params']['sessionId']
    player_id = get_session(session_id)&.player_id
    unless player_id
      response = { action: 'create', status: 'unauthorized' }.to_msgpack
      client.puts response
      client.close
      puts "[create] Session not found: #{session_id}"
      return
    end
    if slot_reserved?(player_id)
      battle = create_battle(request)
      response = { action: 'create', status: 'success', data: { battle_id: battle.id } }.to_msgpack
      client.puts response
      puts "[create] Battle created: #{battle.id}"
    else
      response = { action: 'create', status: 'noslots' }.to_msgpack
      client.puts response
      puts "[create] No available slots for player: #{player_id}"
    end
  end

  def join(client, request) # rubocop:disable Metrics/MethodLength
    session_id = request['Params']['sessionId']
    battle_id = request['Params']['battleId']
    player_id = get_session(session_id)&.player_id
    unless player_id
      response = { action: 'join', status: 'unauthorized' }.to_msgpack
      client.puts response
      client.close
      puts "[join] Session not found: #{session_id}"
      return
    end
    if slot_reserved?(player_id)
      battle = get_battle(battle_id)
      if battle
        battle = join_battle(battle, request)
        response = { action: 'join', status: 'success', data: { battle_id: battle.id } }.to_msgpack
        client.puts response
        puts "[join] Battle joined: #{battle_id}"
      else
        slots.delete(session_id)
        response = { action: 'join', status: 'notfound' }.to_msgpack
        client.puts response
        puts "[join] Battle not found: #{battle_id}"
      end
    else
      response = { action: 'join', status: 'noslots' }.to_msgpack
      client.puts response
      puts "[join] No available slots for player: #{player_id}"
    end
  end

  def ping(client, request) # rubocop:disable Metrics/MethodLength
    session_id = request['Params']['sessionId']
    battle_id = request['Params']['battleId']
    player_id = get_session(session_id)&.player_id
    unless player_id
      response = { action: 'ping', status: 'unauthorized' }.to_msgpack
      client.puts response
      client.close
      puts "[ping] Session not found: #{session_id}"
      return
    end
    if slot_present?(player_id)
      battle = get_battle(battle_id)
      if battle
        battle = ping_battle(battle)
        response = { action: 'ping', status: 'success', data: battle }.to_msgpack
        client.puts response
        puts "[ping] Battle ping success: #{battle_id}"
      else
        response = { action: 'ping', status: 'notfound' }.to_msgpack
        client.puts response
        puts "[ping] Battle not found: #{battle_id}"
      end
    else
      response = { action: 'ping', status: 'noslots' }.to_msgpack
      client.puts response
      puts "[ping] Slot not reserved for player: #{player_id}"
    end
  end

  def hit(client, request) # rubocop:disable Metrics/MethodLength
    session_id = request['Params']['sessionId']
    battle_id = request['Params']['battleId']
    attacker_id = get_session(session_id)&.player_id
    defender_id = request['Params']['defenderId']
    unless attacker_id
      response = { action: 'hit', status: 'unauthorized' }.to_msgpack
      client.puts response
      client.close
      puts "[hit] Session not found: #{session_id}"
      return
    end
    if slot_present?(attacker_id)
      battle = get_battle(battle_id)
      if battle
        battle = hit_battle(battle, attacker_id, defender_id)
        response = { action: 'hit', status: 'success', data: battle }.to_msgpack
        client.puts response
        puts "[hit] Battle hit success: #{battle_id}"
        battle.next_move
      else
        response = { action: 'hit', status: 'notfound' }.to_msgpack
        client.puts response
        puts "[hit] Battle not found: #{battle_id}"
      end
    else
      response = { action: 'hit', status: 'noslots' }.to_msgpack
      client.puts response
      puts "[hit] Slot not reserved for attacker: #{attacker_id}"
    end
  end

  def battles
    data = REDIS.get(REDIS_KEY) || '[]'
    Oj.load(data)
  end

  def create_battle(request)
    warrior_params = request['Params']['warrior']
    enemies_params = request['Params']['enemies']
    warrior = BattleMember.new(warrior_params, team: :blue, index: 0)
    enemies = enemies_params.map_with_index { |e, i| BattleMember.new(e, team: :red, index: i) }
    battle = Battle.new(blue_team: [warrior], red_team: enemies)
    data = battles << battle
    REDIS.set(REDIS_KEY, Oj.dump(data))
    battle
  end

  def join_battle(battle, request)
    warrior_params = request['Params']['warrior']
    warrior = BattleMember.new(warrior_params, team: :blue, index: battle.blue_team.length + 1)
    battle.blue_team << warrior
    data = battles.reject { |b| b.id == battle.id }.push(battle)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    battle
  end

  def ping_battle(battle)
    battle.touch
    data = battles.reject { |b| b.id == battle.id }.push(battle)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    battle
  end

  def hit_battle(battle, attacker_id, defender_id)
    battle = battle.hit(attacker_id, defender_id)
    data = battles.reject { |b| b.id == battle.id }.push(battle)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    battle
  end

  def get_battle(battle_id)
    battles.find { |b| b.id == battle_id }
  end

  def delete_battle(battle_id)
    data = battles.reject { |b| b.id == battle_id }
    REDIS.set(REDIS_KEY, Oj.dump(data))
  end

  def slot_reserved?(session_id)
    slot = slots.find { |s| s == session_id }

    return false if slot

    if slots.length < SLOTS
      slots.push(session_id)
      true
    else
      false
    end
  end

  def slot_present?(session_id)
    slot = slots.find { |s| s == session_id }

    return true if slot

    false
  end

  def sessions
    data = REDIS.get(REDIS_SESSIONS_KEY) || '[]'
    Oj.load(data)
  end

  def get_session(session_id)
    sessions.find { |s| s.id == session_id }
  end
end

DirectBattleServer.new
