require 'socket'
require 'logger'
require 'json'
require 'jwt'

class Player
  attr_accessor :ip, :id, :log, :loc, :pos, :vel, :rot, :models, :time

  def initialize(ip = nil, id = nil, log = nil, loc = nil, pos = nil, vel = nil, rot = nil, models = []) # rubocop:disable Metrics/ParameterLists
    @ip = ip
    @id = id
    @log = log
    @loc = loc
    @pos = pos
    @vel = vel
    @rot = rot
    @models = models
    @time = Time.now
  end
end

class DirectServer # rubocop:disable Metrics/ClassLength
  TIMEOUT = 60

  def initialize
    @server = TCPServer.new '0.0.0.0', 3001
    @players = []
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
      check_timouts
    end
    loop do
      Thread.start(@server.accept) do |client|
        listen_commands(client)
      end
    end
  end

  def check_timouts
    loop do
      sleep 1
      @players.each do |player|
        next unless (Time.now - player.time) > TIMEOUT

        puts "Player timed out: #{player.log} (#{player.id})"
        cleanup_players(player.id)
      end
    end
  end

  def listen_commands(client)
    loop do
      cmd = client&.gets&.chomp
      return if cmd.nil? || cmd == ''

      if cmd.start_with?('check ')
        check(client, cmd)
      elsif cmd.start_with?('login ')
        login(client, cmd)
      elsif cmd.start_with?('sync ')
        sync(client, cmd)
      elsif cmd.start_with?('logout ')
        logout(client, cmd)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def check(client, data)
    player_token = data.split('@')[1]
    if player_token.nil? || player_token == ''
      client.puts 'check@failed'
      puts 'Invalid null token'
      return
    end
    player_id = decode_token(player_token)['player_id']
    if player_id.nil?
      client.puts 'check@failed'
      puts "Invalid token: #{player_token}"
      return
    end
    if collision?(player_id)
      client.puts 'check@failed'
      puts "Session collision: #{player_id}"
      return
    end
    client.puts 'check@success'
    puts "Checked player: #{player_id}"
  end

  def login(client, data)
    player_token = data.split('@')[1]
    if player_token.nil? || player_token == ''
      client.puts 'login@failed'
      puts 'Invalid null token'
      return
    end
    player_id = decode_token(player_token)['player_id']
    if player_id.nil?
      client.puts 'login@failed'
      puts "Invalid token: #{player_token}"
      return
    end
    if collision?(player_id)
      client.puts 'login@failed'
      puts "Session collision: #{player_id}"
      return
    end
    @players.push(Player.new(client.peeraddr[3], player_id))
    client.puts 'login@success'
    puts "Authorize success: #{player_id}"
  end

  def sync(client, data)
    ip = client.peeraddr[3]
    values = data.delete_prefix('sync @').split('@')
    id = values[0]
    return client.close unless authorized?(ip, id)

    log = values[1]
    loc = values[2]
    pos = values[3]
    vel = values[4]
    rot = values[5]
    models = values[6] || ''
    @players = @players.reject { |p| p.id == id }.push(Player.new(ip, id, log, loc, pos, vel, rot, models.split(',')))
    local_players = @players.select { |p| p.loc == loc && p.id != id }
    client.puts "sync@#{local_players.map { |p| "#{p.id}@#{p.log}@#{p.loc}@#{p.pos}@#{p.vel}@#{p.rot}@#{p.models.join(',')}" }.join('&')}"
    # puts "Synced player: @ #{id} @ #{log} @ #{loc} @ #{pos} @ #{vel} @ #{rot} @ #{models}"
  end

  def logout(client, data)
    player_token = data.split('@')[1]
    if player_token.nil? || player_token == ''
      client.puts 'logout@failed'
      puts 'Invalid null token'
      return
    end
    player_id = decode_token(player_token)['player_id']
    if player_id.nil?
      client.puts 'logout@failed'
      puts "Invalid token: #{player_token}"
      return
    end
    cleanup_players(player_id)
    client.puts 'logout@success'
    puts "Unauthorize success: #{player_id}"
  end

  def collision?(id)
    return true if @players.find { |p| p.id == id }

    false
  end

  def authorized?(ip, id)
    return true if @players.find { |p| p.ip == ip && p.id == id }

    false
  end

  def cleanup_players(id)
    @players = @players.reject { |p| p.id == id }
  end

  def decode_token(token)
    JSON.parse(JWT.decode(token, ENV['JWT_SECRET'])[0])
  end
end

DirectServer.new
