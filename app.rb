#!/usr/bin/env ruby

require 'socket'

parent_socket, child_socket = UNIXSocket.pair

fork do
  parent_socket.close
  loop do
    puts "Child pid = #{$$}"
    while true
      from_parent = child_socket.recv 100
      exit if from_parent == 'Bye'
      child_socket.send("Parent said <#{from_parent}>", 0)
    end
  end
end

child_socket.close

parent_socket.send('Yo!', 0)
sleep 1
puts parent_socket.recv 100
parent_socket.send('Bye', 0)
sleep 2
puts 'End'

