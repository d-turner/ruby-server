require 'thread'
require 'socket'

class SocketServer

def initialize(port)
  @server = TCPServer.new port
  @que = Queue.new
  @max = 20
end

def run
  while true
    if @que.length == @max
      @server.reject
    else
      @que.push(@server.accept)
    end
    Thread.start (@que.pop(false)) do |newClient|
      #for each new client do something here
      msg = Thread.current
      msg = msg.to_s
      msg = msg << ": " << newClient.readline
      puts msg
    end
  end
end

end

port = 3001
if ARGV[0] == nil
  puts "No Port Specified using default 3001"
else
  puts "here"
  port = ARGV[0]
end

puts "Using Port Number #{port}"
server = SocketServer.new(port)
server.run
