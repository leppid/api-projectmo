require 'msgpack'
require 'socket'
require 'logger'
require 'redis'
require 'time'
require 'oj'

require '../movement'
require '../session'

class DirectMovementServer # rubocop:disable Metrics/ClassLength
  attr_accessor :server, :slots, :fps

  HOST = '0.0.0.0'
  PORT = 9002
  SLOTS = 60
  TIMEOUT = 60
  REDIS = Redis.new(host: 'redis', port: 6379)
  REDIS_KEY = 'mo_movements'
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

    -===≡≡≡ (ง ˙o˙)ว
    -===≡≡≡ (ง ˙o˙)ว
    -===≡≡≡ (ง ˙o˙)ว  - - MOVEMENT SERVER IS LISTENING ON #{HOST}:#{PORT} - -
    -===≡≡≡ (ง ˙o˙)ว
    -===≡≡≡ (ง ˙o˙)ว
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
      movements.each do |movement|
        next unless (Time.now - movement.time) > TIMEOUT

        puts "[timeout] Movement time out: #{movement.id}"
        delete(movement.id)
        slots.delete(movement.id)
      end
    end
  end

  def listen_commands(client)
    loop do
      cmd = client&.gets&.chomp

      return if cmd.nil? || cmd == ''

      request = begin
        MessagePack.unpack(cmd)
      rescue
        {}
      end

      case request['command']
      when 'check'
        check(client, request)
      when 'sync'
        sync(client, request)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def check(client, request)
    session_id = request['Params']['sessionId']
    player_id = request['Params']['playerId']
    unless authorized?(session_id)
      response = { command: 'check', status: 'unauthorized' }.to_msgpack
      client.puts response
      client.close
      puts "[sync] Session not found: #{player_id}"
      return
    end
    if slotable?(player_id)
      response = { command: 'check', status: 'success' }.to_msgpack
      client.puts response
      puts "[check] Slot reserved: #{player_id}"
    else
      response = { command: 'check', status: 'noslots' }.to_msgpack
      client.puts response
      puts "[check] No available slots: #{player_id}"
    end
  end

  def sync(client, request) # rubocop:disable Metrics/MethodLength
    t = Time.now
    session_id = request['Params']['sessionId']
    player_id = request['Params']['playerId']
    unless authorized?(session_id)
      response = { command: 'sync', status: 'unauthorized' }.to_msgpack
      client.puts response
      puts "[sync] Session not found: #{player_id}"
      client.close
      return
    end
    unless slotable?(player_id)
      response = { command: 'sync', status: 'noslots' }.to_msgpack
      client.puts response
      puts "[sync] No available slots: #{player_id}"
      return
    end
    movement_params = request['Params']['movement']
    hash = {
      id: player_id,
      log: movement_params['log'],
      loc: movement_params['loc'],
      pos: movement_params['pos'],
      vel: movement_params['vel'],
      rot: movement_params['rot'],
      speed: movement_params['speed'],
      models: movement_params['models']
    }
    updated_movement = create_or_update_by(hash)
    local_movements = movements.select { |p| p.loc == updated_movement.loc && p.id != updated_movement.id }
    response = { command: 'sync', status: 'success', data: local_movements.map { |m| { id: m.id, log: m.log, loc: m.loc, pos: m.pos, vel: m.vel, rot: m.rot, speed: m.speed, models: m.models } } }.to_msgpack
    client.puts response
    @fps = (1 / (Time.now - t)).to_i
  end

  def movements
    data = REDIS.get(REDIS_KEY) || '[]'
    Oj.load(data)
  end

  def get(movement_id)
    movements.find { |m| m.id == movement_id }
  end

  def create_or_update_by(params)
    movement = movements.find { |m| m.id == params[:id] }
    movement ? movement.update(params) : movement = Movement.new(params)
    data = movements.reject { |m| m.id == params[:id] }.push(movement)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    movement
  end

  def delete(movement_id)
    data = movements.reject { |m| m.id == movement_id }
    REDIS.set(REDIS_KEY, Oj.dump(data))
  end

  def slotable?(player_id)
    slot = slots.find { |s| s == player_id }

    return true if slot

    if slots.length < SLOTS
      slots.push(player_id)
      true
    else
      false
    end
  end

  def sessions
    data = REDIS.get(REDIS_SESSIONS_KEY) || '[]'
    Oj.load(data)
  end

  def authorized?(session_id)
    return true if sessions.find { |s| s.id == session_id }

    false
  end
end

DirectMovementServer.new
