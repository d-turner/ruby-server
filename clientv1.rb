require 'socket'
require 'thread'

x = 0
while true
  soc = TCPSocket.new 'localhost', 3000
  soc.sendmsg("Here #{x}\n")
  x = x + 1
end

