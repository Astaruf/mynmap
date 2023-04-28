#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[33m'
BOLD='\033[1m'
NC='\033[0m' # No Colors

# Function to display the tool's help
show_help() {
    echo "Usage: $0 -t <TARGET_IP> -d <DOMAIN_NAME> [-nc | --no-colors]"
}

# Read parameters from input
while [ "$#" -gt 0 ]; do
    case "$1" in
        -t)
            target="$2"
            shift 2
            ;;
        -d)
            domain="$2"
            shift 2
            ;;
        -nc|--no-colors)
            RED=""
            GREEN=""
            BLUE=""
            YELLOW=""
            BOLD=""
            NC=""
            shift
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

# Check whether the target and domain have been provided
if [ -z "$target" ] || [ -z "$domain" ]; then
    show_help
    exit 1
fi

echo -e "${YELLOW}Task 1 ${NC}[${BLUE}>${NC}] Starting setup...${NC}"

# Ping to target
ping -c 1 "$target" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}       ${NC}[${RED}x${NC}] ${RED}${NC}The target $target is not reachable.${NC}"
    exit 1
fi
echo -e "${YELLOW}       ${NC}[${BOLD}i${NC}] The host $target is up."

# Remove matching rows from /etc/hosts
sudo grep -v -e "^\s*${target}\s" -e "^\s*\S*\s*${domain}\b" /etc/hosts > /tmp/hosts
sudo mv /tmp/hosts /etc/hosts

# Add line to /etc/hosts file
echo -e "${target}\t${domain}" >> /etc/hosts
echo -e "${YELLOW}       ${NC}[${BOLD}i${NC}] $target ($domain) added to /etc/hosts."

# Ping to domain
ping -c 1 "$domain" >/dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}       ${NC}[${RED}x${NC}] ${RED}The domain $domain is not reachable.${NC}"
    # Remove the added line
    sudo grep -v -e "^\s*${target}\s*${domain}\b" /etc/hosts > /tmp/hosts
    sudo mv /tmp/hosts /etc/hosts
    exit 1
fi
echo -e "${YELLOW}       ${NC}[${BOLD}i${NC}] The host $domain is up."

# Check and create the domain folder
root_folder="./$domain"
if [ ! -d "$root_folder" ]; then
    mkdir "$root_folder"
fi

echo -e "${YELLOW}       ${NC}[${GREEN}✓${NC}] Setup completed.${NC}"

# Run the first nmap scan
echo -e "${YELLOW}Task 2 ${NC}[${BLUE}>${NC}] Starting quick scan of $domain...${NC}"
sudo nmap -sS -T3 -Pn -p- -v -oN "${root_folder}/1-quick.nmap" "$domain"
echo -e "${YELLOW}       ${NC}[${GREEN}✓${NC}] Quick scan completed. File:${GREEN} ${root_folder}/1-quick.nmap ${NC}"

# Extract open doors from the first scan
open_ports=$(grep -E '^ *[0-9]+/.*open' "${root_folder}/1-quick.nmap" | cut -d/ -f1 | tr '\n' ',' | sed 's/,$//')
echo -e "${YELLOW}       ${NC}[${BOLD}i${NC}] Discovered open ports: $open_ports.${NC}"

# TODO: Create cheatsheets based on open doors
#echo -e "${YELLOW}Task 3 ${NC}[${BLUE}>${NC}] Generating cheatsheet file...${NC}"
#for port in ${open_ports//,/ }; do
#[ -f /usr/bin/app/$port.csv ] && echo $(cat /usr/bin/app/$port.csv) && echo "$port.csv found" || echo "$port.csv not found"
#done
#echo -e "${YELLOW}       ${NC}[${GREEN}✓${NC}] Cheatsheet file generation completed. File:${GREEN} ${root_folder}/cheatsheet.txt ${NC}"

# Run the second nmap scan
echo -e "${YELLOW}Task 4 ${NC}[${BLUE}>${NC}] Starting deep scan of $domain...${NC}"
sudo nmap -sV -sC -Pn -p"$open_ports" "$domain" -oN "${root_folder}/2-deep.nmap" > /dev/null
echo -e "${YELLOW}       ${NC}[${GREEN}✓${NC}] Deep scan completed. File:${GREEN} ${root_folder}/2-deep.nmap ${NC}"
