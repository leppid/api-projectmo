require 'securerandom'
require 'msgpack'
require 'socket'
require 'logger'
require 'redis'
require 'time'
require 'jwt'
require 'oj'

require '../session'

class DirectSessionServer # rubocop:disable Metrics/ClassLength
  HOST = '0.0.0.0'
  PORT = 9001
  REDIS = Redis.new(host: 'redis', port: 6379)
  REDIS_KEY = 'mo_sessions'
  TIMEOUT = 300

  def initialize
    REDIS.del(REDIS_KEY)
    @server = TCPServer.new HOST, PORT
    run
  end

  private

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

        puts "[timeout] Session time out: #{session.player_id}"
        delete(session.id)
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
      when 'login'
        login(client, request)
      when 'ping'
        ping(client, request)
      when 'logout'
        logout(client, request)
      else
        client.puts 'Invalid command'
      end
    end
  end

  def login(client, request)
    player_token = request['Params']['apiToken']
    session_id = request['Params']['sessionId']
    player_id = decode_token(player_token)['player_id']
    if player_token.nil? || session_id.nil? || (collision?(player_id) && !authorized?(session_id, player_id))
      response = { command: 'login', status: 'unauthorized' }.to_msgpack
      client.puts response
      puts "[login] Session not found or unavailable: #{player_id || 'nil'}"
      return
    end
    new_session = create_or_update_by({ player_id: player_id })
    response = { command: 'login', status: 'success', data: new_session.id }.to_msgpack
    client.puts response
    puts "[login] Authorization success: #{player_id}"
  end

  def ping(client, request)
    player_token = request['Params']['apiToken']
    session_id = request['Params']['sessionId']
    player_id = decode_token(player_token)['player_id']
    if player_token.nil? || session_id.nil? || !authorized?(session_id, player_id)
      response = { command: 'ping', status: 'unauthorized' }.to_msgpack
      client.puts response
      puts "[ping] Session not found or unavailable: #{player_id || 'nil'}"
      return
    end
    create_or_update_by({ id: session_id, player_id: player_id })
    response = { command: 'ping', status: 'success' }.to_msgpack
    client.puts response
    puts "[ping] Authorization ping success: #{player_id}"
  end

  def logout(client, request)
    player_token = request['Params']['apiToken']
    session_id = request['Params']['sessionId']
    player_id = decode_token(player_token)['player_id']
    if player_token.nil? || session_id.nil? || !authorized?(session_id, player_id)
      response = { command: 'logout', status: 'unauthorized' }.to_msgpack
      client.puts response
      puts "[logout] Session not found or unavailable: #{player_id || 'nil'}"
      return
    end
    delete(session_id)
    response = { command: 'logout', status: 'success' }.to_msgpack
    client.puts response
    puts "[logout] Unauthorization success: #{player_id}"
  end

  def sessions
    data = REDIS.get(REDIS_KEY) || '[]'
    Oj.load(data)
  end

  def get(session_id = nil, player_id = nil)
    if session_id
      sessions.find { |s| s.id == session_id }
    elsif player_id
      sessions.find { |s| s.player_id == player_id }
    end
  end

  def create_or_update_by(params)
    session = sessions.find { |s| s.player_id == params[:player_id] }
    session&.touch || session = Session.new(params)
    data = sessions.reject { |s| s.player_id == params[:player_id] }.push(session)
    REDIS.set(REDIS_KEY, Oj.dump(data))
    session
  end

  def delete(session_id)
    data = sessions.reject { |s| s.id == session_id }
    REDIS.set(REDIS_KEY, Oj.dump(data))
  end

  def collision?(player_id)
    return true if sessions.find { |s| s.player_id == player_id }

    false
  end

  def authorized?(session_id, player_id)
    return true if sessions.find { |s| s.id == session_id && s.player_id == player_id }

    false
  end

  def decode_token(token)
    Oj.load(JWT.decode(token, ENV['JWT_SECRET'])[0])
  end
end

DirectSessionServer.new
