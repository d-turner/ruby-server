require 'thread'
require 'socket'

class SocketServer

  def initialize(port)
    @server = TCPServer.new port
    @max_threads = 4
    @que = Queue.new
    @max = 2
  end

  def run
    x = Thread.new {
      @server.listen(@max)
      while true
        if @que.length < @max
          @que.push(@server.accept)
        end
      end
    }
    workers = (0...@max_threads).map {|i|
      Thread.new do
        begin
          while true
            sleeps = 3
            client = @que.pop(false)
            msg = 'Thread ' << i.to_s
            msg << ': ' << client.readline

            puts msg
            sleep sleeps
            client.close
          end
        rescue ThreadError
        end
      end
    }
    workers.map(&:join)
    x.join
      # @workers.each {|thr|
      #   if thr.status == 'sleep'
      #     thr.start(@que.pop(false)) { |newClient|
      #       #for each new client do something here
      #       msg = Thread.current
      #       msg = msg.to_s
      #       msg = msg << ': ' << newClient.readline
      #       puts msg
      #       Thread.sleep
      #     }
      #   end
      # }
  end

  def connection

  end
end

port = 3000
if ARGV[0] == nil
  puts "No Port Specified using default 3001"
else
  port = ARGV[0]
end

puts "Using Port Number #{port}"
server = SocketServer.new(port)
server.run
