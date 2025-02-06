require 'socket'
require 'logger'

class Player
  attr_accessor :ip, :log, :loc, :pos, :vel, :rot, :models

  def initialize(ip = nil, log = nil, loc = nil, pos = nil, vel = nil, rot = nil, models = []) # rubocop:disable Metrics/ParameterLists
    @ip = ip
    @log = log
    @loc = loc
    @pos = pos
    @vel = vel
    @rot = rot
    @models = models
  end
end

class DirectServer
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
    loop do
      Thread.start(@server.accept) do |client|
        listen_commands(client)
      end
    end
  end

  def listen_commands(client)
    loop do
      cmd = client&.gets&.chomp

      return unless cmd

      if cmd.start_with?('login ')
        login(client, cmd)
      elsif cmd.start_with?('sync ')
        sync(client, cmd)
      elsif cmd.start_with?('logout')
        logout(client)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def login(client, data)
    token = data.split(' ').last
    puts "Got token: #{token}"
    client.puts 'Logged in'
  end

  def sync(client, data)
    ip = client.peeraddr[3].to_s
    loc = data.split('@')[1]
    log = data.split('@')[2]
    pos = data.split('@')[3]
    vel = data.split('@')[4]
    rot = data.split('@')[5]
    models = data.split('@')[6] || ''

    @players = @players.reject { |p| p.log == log }.push(Player.new(ip, log, loc, pos, vel, rot, models.split(',')))

    local_players = @players.select { |p| p.loc == loc && p.log != log }

    # puts "Synced player: @ #{log} @ #{ip} @ #{loc} @ #{pos} @ #{vel} @ #{rot} @ #{models}"

    client.puts "sync@#{local_players.map { |p| "#{p.loc}@#{p.log}@#{p.pos}@#{p.vel}@#{p.rot}@#{p.models.join(',')}" }.join('&')}"
  end

  def logout(client)
    ip = client.peeraddr[3]
    cleanup_locations(ip)
    client.close
    puts "Logged out: #{ip}"
  end

  def cleanup_locations(ip)
    @players.each do |player|
      next unless player.ip == ip

      @players.delete(player)
    end
  end
end

DirectServer.new
