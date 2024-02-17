#!/bin/bash

# Check if the correct number of arguments is provided
if [[ $# != 1 ]]; then
    echo "Usage $0 <domain>"
    echo "e.g www.megacorpone.com"
    exit 1
fi

# Download the homepage and extract unique subdomains
var=$(echo $1|cut -d '.' -f2)
wget -qO- $1 | grep -oE 'https?://[^"/]+' | cut -d'/' -f3 |grep $var | sort -u > sub_domains

# Function to resolve IP address for a subdomain
resolve_ip() {
    sub=$1
    ip=$(host "$sub" | awk '/has address/ {print $NF; exit}')
    if [[ -n $ip ]]; then
        echo "$sub  ++++++++ "
        echo "$sub" >> valid_sub.txt
        echo "$ip" >> ips.txt
    else
        echo "$sub -------- "
    fi
}

# Loop through each subdomain and resolve its IP address
while read -r sub; do
    resolve_ip "$sub"
done < sub_domains

echo "DONE ..."
