require 'thread'
require 'socket'

class SocketServer

  def initialize(port)
    @port = port
    @server = TCPServer.new @port
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
            sleeps = 1
            client = @que.pop(false)
            msg = "Thread #{i}"
            readLine = client.readline
            msg << ': ' << readLine
            puts msg
            if readLine == "KILL_SERVICE\n"
              puts "Killing"
              Thread.list.each do |thread|
                thread.exit
              end
            elsif readLine.start_with?("HELO")
              reply = readLine.concat("Port: #{@port}\nStudentID: 33d4fcfd69df0c9bbbd0bd54ce854663db8238836b6faec70a00cf9e835a6bd1\n") 
              client.write(reply)
              client.flush
            else 
              puts "Neither"
            end
            sleep sleeps
            client.close
          end
        rescue ThreadError
        end
      end
    }
    workers.map(&:join)
    puts "Quiting"
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
  puts "No Port Specified using default 3000"
else
  port = ARGV[0]
end

puts "Using Port Number #{port}"
server = SocketServer.new(port)
server.run
