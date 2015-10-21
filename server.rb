require 'thread'
require 'socket'

class SocketServer

  def initialize(port)
    @server = TCPServer.new port
    @max_threads = 4
    @max = 50
    @que = Queue.new
  end

  def run
    x = Thread.new {
      while true do
        if @que.length > @max
          @server.accept
        else
          @que.push(@server.accept)
          puts "add now"
        end
      end
    }
    workers = (0...@max_threads).map {|i|
      Thread.new do
        begin
          while true
            sleeps = 4
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
    while true
      puts "Que length : #{@que.length}"
      sleep 3
    end
    workers.map(&:join)
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
