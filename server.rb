require 'thread'
require 'socket'

class SocketServer

  def initialize(port)
    @port = port
    @server = TCPServer.new @port
    @max_threads = 4
    @max = 1_000
    @que = Queue.new
    addr_infos = Socket.ip_address_list
    @ip = addr_infos[1].ip_address.to_s
  end

  def run
    x = Thread.new {
      while true do
        if @que.length > @max
          @server.accept
        else
          @que.push(@server.accept)
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
              reply = readLine.concat("IP: #{@ip}\nPort: #{@port}\nStudentID: 33d4fcfd69df0c9bbbd0bd54ce854663db8238836b6faec70a00cf9e835a6bd1\n") 
              client.write(reply)
              client.flush
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
