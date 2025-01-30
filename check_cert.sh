#!/bin/bash

# Set the URL to check
url="https://bhashalekhan.com"

# Get the certificate information using openssl and extract the expiry date
expiry_date=$(echo | openssl s_client -servername "$(echo $url | cut -d / -f 3)" -connect "$(echo $url | cut -d / -f 3):443" 2>/dev/null | openssl x509 -noout -dates | grep 'notAfter' | cut -d '=' -f 2)

# Convert the expiry date to seconds since epoch
expiry_secs=$(date '+%s' --date "$expiry_date")

# Get the current time in seconds since epoch
current_secs=$(date '+%s')

# Calculate the time difference in seconds
time_diff=$((expiry_secs - current_secs))

# Check if the certificate has already expired or will expire within 30 days
if [[ $time_diff -lt 0 ]]; then
    echo "Certificate for $url has already expired on $expiry_date"
elif [[ $time_diff -lt 2592000 ]]; then
    echo "Certificate for $url will expire on $expiry_date (less than 30 days)"
else
    echo "Certificate for $url is valid until $expiry_date"
fi

