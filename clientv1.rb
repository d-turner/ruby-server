require 'socket'
require 'thread'

x = 0
for i in 0..10
  soc = TCPSocket.new 'localhost', 3000
  if i == 2
    soc.sendmsg("HELO anythin\n")
    data = soc.recv( 1024 )
    puts data
  elsif i == 5
    soc.sendmsg("KILL_SERVICE\n")
  else
    soc.sendmsg("Here #{x}\n")
  end
  x = x + 1
end

