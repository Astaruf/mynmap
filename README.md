# README
This bash script is designed to automate the configuration and execution of port scans on a specified domain or IP address. The code is written to be run on Linux systems and requires the Nmap package to function correctly.

# Features
The script performs the following tasks:

1. Checks if the target is reachable via ping
2. Adds the target and domain to the /etc/hosts file
3. Performs a quick scan of open ports using Nmap
4. Generates a list of open ports and creates cheat sheets for each one
5. Performs a deep scan of open ports using Nmap

# Requirements
This script requires the Nmap package to function correctly. Make sure to have it installed before using the script.

# Usage
Mandatory arguments:

  ```-t, --target <TARGET_IP>```     The IP address of the target to scan.
  
  ```-d, --domain <DOMAIN_NAME>```   The domain name of the target to scan.

Optional arguments:

  ```-nc, --no-colors```             Disable console coloring.

Examples:

  ```./port-scan.sh -t 192.168.1.1 -d example.com```
  
  ```./port-scan.sh -t 10.0.0.2 -d mydomain.com --no-colors```
