#!/bin/bash

file_path="servers.txt"

username="tony"
command_to_run='systemctl status rsyslog | grep -E "Loaded|Active"'
command_to_run2='systemctl status ufw | grep -E "Loaded|Active"'
command_to_run3='systemctl status snapd | grep -E "Loaded|Active"'



# Read the file into an array
IFS=$'\n' read -d '' -r -a servers < "$file_path"

# Iterate through the list of servers
for server in "${servers[@]}"; do
    echo "Server: $server"
    
    # Perform an NSlookup
    nslookup_output=$(nslookup "$server" 2>&1)
    if [[ $nslookup_output == *"name ="* ]]; then
        server_name=$(echo "$nslookup_output" | grep -oP 'name = \K[^\.]+')
        echo "Server Name: $server_name"
    else
        echo "Server Name: Not found"
    fi
    
    # Run the SSH commands and capture the output
    ssh -o ConnectTimeout=10 "$username@$server" "$command_to_run;$command_to_run2;$command_to_run3"
    
    echo "----------------------------------------------------------------------------"
done
