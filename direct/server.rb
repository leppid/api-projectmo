require 'socket'
require 'logger'
# require './player'

class Location
  attr_accessor :name, :players

  def initialize(name = nil, players = [])
    @name = name
    @players = players
  end
end

class Player
  attr_accessor :ip, :log, :pos, :vel, :rot, :models

  def initialize(ip = nil, log = nil, pos = nil, vel = nil, rot = nil, models = []) # rubocop:disable Metrics/ParameterLists
    @ip = ip
    @log = log
    @pos = pos
    @vel = vel
    @rot = rot
    @models = models
  end
end

class DirectServer
  TIMEOUT = 5

  def initialize
    @server = TCPServer.new '0.0.0.0', 3001
    @timers = {}
    @locations = {}
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
      cmd = client.gets&.chomp

      return unless cmd

      if cmd.start_with?('login ')
        login(cmd, client)
      elsif cmd.start_with?('sync ')
        sync(cmd, client)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def login(data, client)
    token = data.split(' ').last
    puts "Got token: #{token}"
    client.puts 'Successful'
  end

  def sync(data, client)
    ip = client.peeraddr[3]
    loc = data.split('@')[1]
    log = data.split('@')[2]
    pos = data.split('@')[3]
    vel = data.split('@')[4]
    rot = data.split('@')[5]
    models = data.split('@')[6] || ''

    if @locations[loc]
      @locations[loc].players = @locations[loc].players.filter { |p| p.log != log } << Player.new(ip, log, pos, vel, rot, models.split(','))
    else
      @locations[loc] = Location.new(loc, [Player.new(ip, log, pos, vel, rot, models.split(','))])
    end

    players = @locations[loc].players

    puts players

    puts "Synced player: @ #{loc} @ #{log} @ #{ip} @ #{pos} @ #{vel} @ #{rot} @ #{models}"
    client.puts "sync@#{players.map { |p| "#{loc}@#{p.log}@#{p.pos}@#{p.vel}@#{p.rot}@#{p.models.join(',')}" }.join('&')}"

    cleanup_locations(ip, loc)
  end

  def cleanup_locations(ip, loc)
    @locations.each_key do |key|
      players = @locations[key].players
      players.each do |player|
        next if key == loc
        next unless player.ip == ip

        players.delete(player)
      end
    end
  end
end

DirectServer.new
