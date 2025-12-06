#!/bin/bash

# ===============================
#  Automated IP Resolver Tool
#  By Abdullah 
# ===============================

INPUT_FILE="$1"
OUTPUT_FILE="resolved_ips.txt"
CLEANED_DOMAINS="clean_domains.txt"

if [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 subdomains.txt"
    exit 1
fi

echo "[+] Cleaning domain list..."
sed 's#https\?://##' "$INPUT_FILE" | cut -d'/' -f1 | sort -u > "$CLEANED_DOMAINS"

echo "[+] Resolving IP addresses..."
> "$OUTPUT_FILE"  # empty the file

while read -r domain; do
    if [ -z "$domain" ]; then
        continue
    fi

    echo "[+] Resolving: $domain"

    # Get IP addresses using dig
    ips=$(dig +short "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')

    if [ -n "$ips" ]; then
        echo "$ips" >> "$OUTPUT_FILE"
    else
        echo "[-] No IP found for: $domain"
    fi

done < "$CLEANED_DOMAINS"

echo "[+] Removing duplicate IPs..."
sort -u "$OUTPUT_FILE" -o "$OUTPUT_FILE"

echo
echo "======================================="
echo " IP Resolver Completed!"
echo " Input File:   $INPUT_FILE"
echo " Cleaned Subs: $CLEANED_DOMAINS"
echo " Output IPs:   $OUTPUT_FILE"
echo "======================================="
