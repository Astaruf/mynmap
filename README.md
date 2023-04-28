# README
This bash script is designed to automate the configuration and execution of port scans on a specified domain or IP address. The code is written to be run on Linux systems and requires the Nmap package to function correctly.

# Usage
To use the script, you need to specify the domain or IP address to scan using the -d and -t options, respectively. For example:
```./mynmap.sh -t 192.168.1.1 -d example.com```

You can use the ```-nc``` or ```--no-colors``` option to disable console coloring if necessary.

# Features
The script performs the following tasks:

1. Checks if the target is reachable via ping
2. Adds the target and domain to the /etc/hosts file
3. Performs a quick scan of open ports using Nmap
4. Generates a list of open ports and creates cheat sheets for each one
5. Performs a deep scan of open ports using Nmap

# Requirements
This script requires the Nmap package to function correctly. Make sure to have it installed before using the script.
