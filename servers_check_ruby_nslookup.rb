#!/usr/bin/env ruby

file_path = "servers.txt"

username = "tony"
command_to_run = 'systemctl status rsyslog | grep -E "Loaded|Active"'
command_to_run2 = 'systemctl status ufw | grep -E "Loaded|Active"'
command_to_run3='systemctl status snapd | grep -E "Loaded|Active"'



# Read the file into an array
servers = File.readlines(file_path).map(&:chomp)

# Iterate through the list of servers
servers.each do |server|
  puts "Server: #{server}"

  # Perform an NSlookup
  nslookup_output = `nslookup #{server} 2>&1`
  if nslookup_output.include?("name =")
    server_name = nslookup_output.match(/name =\s*([^\.]+)/)[1]
    puts "Server Name: #{server_name}"
  else
    puts "Server Name: Not found"
  end

  # Run the SSH commands and capture the output
  ssh_command = "ssh -o ConnectTimeout=10 #{username}@#{server} '#{command_to_run};#{command_to_run2};#{command_to_run3}'"
  ssh_output = `#{ssh_command}`
  puts ssh_output

  puts "----------------------------------------------------------------------------"
end

