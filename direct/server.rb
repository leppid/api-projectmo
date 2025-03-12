require 'securerandom'
require 'socket'
require 'logger'
require 'redis'
require 'time'
require 'jwt'
require 'oj'

class Player
  attr_accessor :sid, :id, :log, :loc, :pos, :vel, :rot, :models, :time

  def initialize(params = {})
    @sid = SecureRandom.uuid
    update(params)
  end

  def update(params)
    @id = params[:id]
    @log = params[:log]
    @loc = params[:loc]
    @pos = params[:pos]
    @vel = params[:vel]
    @rot = params[:rot]
    @models = params[:models]
    @time = Time.now
  end
end

class DirectServer # rubocop:disable Metrics/ClassLength
  REDIS = Redis.new(host: 'redis', port: 6379)
  TIMEOUT = 60

  def players
    dirrect_players = REDIS.get('direct_players') || '[]'
    Oj.load(dirrect_players)
  end

  def get_player(id)
    players.find { |p| p.id == id }
  end

  def update_player(params)
    player = players.find { |p| p.id == params[:id] } || Player.new(params)
    player.update(params)
    data = players.reject { |p| p.id == params[:id] }.push(player)
    REDIS.set('direct_players', Oj.dump(data))
    player
  end

  def delete_player(id)
    data = players.reject { |p| p.id == id }
    REDIS.set('direct_players', Oj.dump(data))
  end

  def initialize
    REDIS.del('direct_players')
    @server = TCPServer.new '0.0.0.0', 3001
    run
  end

  def run
    $stdout.sync = true
    logger = Logger.new($stdout)
    logger.info('
    _/﹋\_
    (҂`_´)
    <,︻╦╤─ ҉ - - DIRECT SERVER IS ACTIVE - - ҉ ─╤╦︻,>
    _/﹋\_
    ')
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
      players.each do |player|
        next unless (Time.now - player.time) > TIMEOUT

        puts "Player timed out: #{player.log} #{player.id}"
        delete_player(player.id)
      end
    end
  end

  def listen_commands(client)
    loop do
      cmd = client&.gets&.chomp

      return if cmd.nil? || cmd == ''

      if cmd.start_with?('login@')
        login(client, cmd)
      elsif cmd.start_with?('check@')
        check(client, cmd)
      elsif cmd.start_with?('sync@')
        sync(client, cmd)
      elsif cmd.start_with?('logout@')
        logout(client, cmd)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def login(client, data)
    token = data.split('@')[1]
    if token.nil? || token == ''
      client.puts 'login@failed'
      puts 'Invalid null token'
      return
    end
    id = decode_token(token)['player_id']
    if id.nil?
      client.puts 'login@failed'
      puts "Invalid token: #{token}"
      return
    end
    sid = data.split('@')[2]
    if collision?(id) && !authorized?(id, sid)
      client.puts 'login@failed'
      puts "Session collision: #{id}"
      return
    end
    new_player = update_player({ id: id })
    client.puts "login@success@#{new_player.sid}"
    puts "Authorization success: #{id}"
  end

  def check(client, data)
    token = data.split('@')[1]
    if token.nil? || token == ''
      client.puts 'check@failed'
      puts 'Invalid null token'
      return
    end
    id = decode_token(token)['player_id']
    if id.nil?
      client.puts 'check@failed'
      puts "Invalid token: #{token}"
      return
    end
    sid = data.split('@')[2]
    unless authorized?(id, sid)
      client.puts 'check@failed'
      puts "Authorization check failed: #{id}"
      return
    end
    client.puts 'check@success'
    puts "Authorization check success: #{id}"
  end

  def sync(client, data)
    values = data.split('@')
    hash = {
      id: values[1],
      log: values[2],
      loc: values[3],
      pos: values[4],
      vel: values[5],
      rot: values[6],
      models: values[7] || ''
    }
    new_player = update_player(hash)
    local_players = players.select { |p| p.loc == new_player.loc && p.id != new_player.id }
    client.puts "sync@#{local_players.map { |p| "#{p.id}@#{p.log}@#{p.loc}@#{p.pos}@#{p.vel}@#{p.rot}@#{p.models.join(',')}" }.join('&')}"
    # puts "Synced player: @ #{new_player.id} @ #{new_player.log} @ #{new_player.loc} @ #{new_player.pos} @ #{new_player.vel} @ #{new_player.rot} @ #{new_player.models}"
  end

  def logout(client, data)
    token = data.split('@')[1]
    if token.nil? || token == ''
      client.puts 'logout@failed'
      puts 'Invalid null token'
      return
    end
    id = decode_token(token)['player_id']
    if id.nil?
      client.puts 'logout@failed'
      puts "Invalid token: #{token}"
      return
    end
    sid = data.split('@')[2]
    unless authorized?(id, sid)
      client.puts 'logout@failed'
      puts "Invalid token: #{token}"
      return
    end
    delete_player(id)
    client.puts 'logout@success'
    puts "Unauthorize success: #{id}"
  end

  def collision?(id)
    return true if players.find { |p| p.id == id }

    false
  end

  def authorized?(id, sid)
    return true if players.find { |p| p.id == id && p.sid == sid }

    false
  end

  def decode_token(token)
    Oj.load(JWT.decode(token, ENV['JWT_SECRET'])[0])
  end
end

DirectServer.new
