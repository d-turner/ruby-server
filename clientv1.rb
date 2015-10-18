require 'socket'


s1 = TCPSocket.new 'localhost', 3000
s2 = TCPSocket.new 'localhost', 3000
s3 = TCPSocket.new 'localhost', 3000
s4 = TCPSocket.new 'localhost', 3000
s5 = TCPSocket.new 'localhost', 3000
s6 = TCPSocket.new 'localhost', 3000
s7 = TCPSocket.new 'localhost', 3000
s8 = TCPSocket.new 'localhost', 3000

s1.sendmsg("here1\n")
s2.sendmsg("here2\n")
s3.sendmsg("here3\n")
s4.sendmsg("here4\n")
s5.sendmsg("here5\n")
s6.sendmsg("here6\n")
s7.sendmsg("here7\n")
s8.sendmsg("here8\n")

