require 'thread'
require 'socket'

ARGV.each do|a|
  puts "Argument: #{a}"
  if ARGV[0] == nil
  	puts "No Port Specified exiting"
  	return -1
  end
end

port = ARGV[0]
server = TCPServer.new port 
puts "Using Port Number #{port}"

clientNumber = 0
while true
	client = server.accept
	client.puts "Your are client #{clientNumber}"
	clientNumber += 1
	client.close
end
	
