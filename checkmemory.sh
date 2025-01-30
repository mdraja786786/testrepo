#!/bin/bash

# Get the total memory in bytes
total_mem=$(free -b | awk '/^Mem:/{print $2}')

# Convert bytes to GB
total_mem_gb=$(echo "scale=2; $total_mem/1024/1024/1024" |bc)

# Output the result
echo "Total memory: $total_mem_gb GB"

