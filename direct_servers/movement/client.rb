require 'socket'

class DirectMovementClient
  def initialize
    @server = TCPSocket.new('0.0.0.0', 9002)
    @request = nil
    @response = nil
    listen
    send
    @request.join
    @response.join
  end

  def listen
    @response = Thread.new do
      loop do
        msg = @server.gets&.chomp
        puts msg
      end
    end
  end

  def send
    @request = Thread.new do
      loop do
        msg = $stdin.gets&.chomp
        @server.puts(msg)
      end
    end
  end
end

DirectMovementClient.new
