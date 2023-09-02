
#!/usr/bin/env python3
import subprocess
import re

file_path = "servers.txt"
username = "tony"
command_to_run = 'systemctl status rsyslog | grep -E "Loaded|Active"'
command_to_run2 = 'systemctl status ufw | grep -E "Loaded|Active"'
command_to_run3='systemctl status snapd | grep -E "Loaded|Active"'

# Read the file into a list
with open(file_path, "r") as file:
    servers = file.read().splitlines()

# Iterate through the list of servers
for server in servers:
    print(f"Server: {server}")

    # Perform an NSlookup
    try:
        nslookup_command = f"nslookup {server}"
        nslookup_output = subprocess.check_output(nslookup_command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)

        # Extract the hostname from NSlookup output
        hostname_match = re.search(r'name\s*=\s*([^\.]+)\.', nslookup_output)
        if hostname_match:
            server_name = hostname_match.group(1)
            print(f"Server Name: {server_name}")
        else:
            print("Server Name: Not found")
    except subprocess.CalledProcessError as e:
        print(f"Error performing NSlookup on {server}: {e.output}")

    # Run the SSH commands and capture the output
    ssh_command = f"ssh -o ConnectTimeout=10 {username}@{server} '{command_to_run};{command_to_run2};{command_to_run3}'"
    try:
        output = subprocess.check_output(ssh_command, shell=True, stderr=subprocess.STDOUT, universal_newlines=True)
        print(output)
    except subprocess.CalledProcessError as e:
        print(f"Error executing SSH command on {server}: {e.output}")

    print("\n----------------------------------------------------------------------------\n")

