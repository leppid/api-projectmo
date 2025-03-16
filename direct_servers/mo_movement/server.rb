require 'socket'
require 'logger'
require 'redis'
require 'time'
require 'oj'

require '../movement'
require '../session'

class MoMovementServer
  HOST = '0.0.0.0'
  PORT = 3002
  REDIS = Redis.new(host: 'redis', port: 6379)
  REDIS_KEY = 'mo_movements'
  REDIS_SESSIONS_KEY = 'mo_sessions'
  TIMEOUT = 60

  def movements
    data = REDIS.get(REDIS_KEY) || '[]'
    Oj.load(data)
  end

  def get(id)
    movements.find { |p| p.id == id }
  end

  def create_or_update_by(params)
    movement = movements.find { |p| p.id == params[:id] }
    movement ? movement.update(params) : movement = Movement.new(params)
    data = movements.reject { |p| p.id == params[:id] }.push(movement)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    movement
  end

  def delete(id)
    data = movements.reject { |p| p.id == id }
    REDIS.set(REDIS_KEY, Oj.dump(data))
  end

  def initialize
    REDIS.del(REDIS_KEY)
    @server = TCPServer.new HOST, PORT
    run
  end

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
      movements.each do |movement|
        next unless (Time.now - movement.time) > TIMEOUT

        puts "Movement timed out: #{movement.log} #{movement.id}"
        delete(movement.id)
      end
    end
  end

  def listen_commands(client)
    loop do
      cmd = client&.gets&.chomp

      return if cmd.nil? || cmd == ''

      if cmd.start_with?('sync@')
        sync(client, cmd)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def sync(client, data)
    t = Time.now
    values = data.split('@')
    sid = values[1]
    unless authorized?(sid)
      client.puts 'sync@failed'
      puts 'Unauthorized'
      client.close
      return
    end
    hash = {
      id: values[2],
      log: values[3],
      loc: values[4],
      pos: values[5],
      vel: values[6],
      rot: values[7],
      models: values[8] || ''
    }
    synced_movement = create_or_update_by(hash)
    local_movements = movements.select { |p| p.loc == synced_movement.loc && p.id != synced_movement.id }
    client.puts "sync@#{local_movements.map { |m| "#{m.id}@#{m.log}@#{m.loc}@#{m.pos}@#{m.vel}@#{m.rot}@#{m.models}" }.join('&')}"
    p Time.now - t
    # puts "Movment synced: @ #{synced_movement.id} @ #{synced_movement.log} @ #{synced_movement.loc} @ #{synced_movement.pos} @ #{synced_movement.vel} @ #{synced_movement.rot} @ #{synced_movement.models}"
  end

  def sessions
    data = REDIS.get(REDIS_SESSIONS_KEY) || '[]'
    Oj.load(data)
  end

  def authorized?(sid)
    return true if sessions.find { |s| s.id == sid }

    false
  end
end

MoMovementServer.new
