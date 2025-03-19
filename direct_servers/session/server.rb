require 'securerandom'
require 'socket'
require 'logger'
require 'redis'
require 'time'
require 'jwt'
require 'oj'

require '../session'

class MoSessionServer # rubocop:disable Metrics/ClassLength
  HOST = '0.0.0.0'
  PORT = 9001
  REDIS = Redis.new(host: 'redis', port: 6379)
  REDIS_KEY = 'mo_sessions'
  TIMEOUT = 300

  def sessions
    data = REDIS.get(REDIS_KEY) || '[]'
    Oj.load(data)
  end

  def get(id)
    sessions.find { |p| p.id == id }
  end

  def create_or_update_by(params)
    session = sessions.find { |p| p.id == params[:id] }
    session&.touch || session = Session.new(params)
    data = sessions.reject { |p| p.id == params[:id] }.push(session)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    session
  end

  def delete(id)
    data = sessions.reject { |p| p.id == id }
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

    -===≡≡≡ Ⓞ═╦╗
    -===≡≡≡ Ⓞ═╦╗
    -===≡≡≡ Ⓞ═╦╗  - - SESSION SERVER IS LISTENING ON #{HOST}:#{PORT} - -
    -===≡≡≡ Ⓞ═╦╗
    -===≡≡≡ Ⓞ═╦╗
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
      sessions.each do |session|
        next unless (Time.now - session.time) > TIMEOUT

        puts "Session time out: #{session.id} #{session.pid}"
        delete(session.id)
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
      elsif cmd.start_with?('logout@')
        logout(client, cmd)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def login(client, data)
    pid_token = data.split('@')[1]
    if pid_token.nil? || pid_token == ''
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    id = data.split('@')[2]
    if id.nil?
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    pid = decode_token(pid_token)['player_id']
    if collision?(pid) && !authorized?(id, pid)
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    new_session = create_or_update_by({ pid: pid })
    client.puts "login@success@#{new_session.id}"
    puts "Authorization success: #{pid}"
  end

  def check(client, data)
    pid_token = data.split('@')[1]
    if pid_token.nil? || pid_token == ''
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    id = data.split('@')[2]
    if id.nil?
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    pid = decode_token(pid_token)['player_id']
    unless authorized?(id, pid)
      client.puts 'check@failed'
      puts 'Invalid token'
      return
    end
    create_or_update_by({ id: id, pid: pid })
    client.puts 'check@success'
    puts "Authorization check success: #{pid}"
  end

  def logout(client, data)
    pid_token = data.split('@')[1]
    if pid_token.nil? || pid_token == ''
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    id = data.split('@')[2]
    if id.nil?
      client.puts 'login@failed'
      puts 'Invalid token'
      return
    end
    pid = decode_token(pid_token)['player_id']
    unless authorized?(id, pid)
      client.puts 'logout@failed'
      puts 'Invalid token'
      return
    end
    delete(id)
    client.puts 'logout@success'
    puts "Unauthorization success: #{pid}"
  end

  def collision?(pid)
    return true if sessions.find { |p| p.pid == pid }

    false
  end

  def authorized?(id, pid)
    return true if sessions.find { |p| p.id == id && p.pid == pid }

    false
  end

  def decode_token(token)
    Oj.load(JWT.decode(token, ENV['JWT_SECRET'])[0])
  end
end

MoSessionServer.new
