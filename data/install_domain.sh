#!/bin/bash
#Script Variables
PORT_TCP='1194'
PORT_UDP='2200'

clear
echo "Setup Domain."
mkdir /etc/domain
touch /etc/domain/d-domain
touch /etc/domain/f-domain
# Domain configuration
echo "1. Use Our NF Domain Random"
echo "2. Choose Your Own Domain"
read -rp "Input 1 or 2: " dns
if [ "$dns" -eq 1 ]; then
    # Download cf script and convert line endings
    wget https://raw.githubusercontent.com/buttacuore2/vpn/refs/heads/main/data/cf.sh
    dos2unix cf.sh
    bash cf.sh
elif [ "$dns" -eq 2 ]; then
    read -rp "Enter Your Domain: " dom
    echo "$dom" > /etc/domain/d-domain
    echo "$dom" > /etc/domain/f-domain
else
    echo "Not Found Argument"
    exit 1
fi
wget https://raw.githubusercontent.com/buttacuore2/vpn/main/data/cf.sh
dos2unix cf.sh
bash cf.sh
rm cf.sh
clear
