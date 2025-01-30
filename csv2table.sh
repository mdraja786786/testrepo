#!/bin/bash

# Read the CSV file into an array
readarray -t lines < "data.csv"

# Define a function to format a row as a table
format_row() {
  printf "| %-10s | %-5s | %-10s | %-10s |\n" $1 $2 $3 $4
}

# Print the table header
printf "+------------+-------+------------+------------+\n"
printf "| Name       | Roll  | Class      | City       |\n"
printf "+------------+-------+------------+------------+\n"

# Print the table rows
for line in "${lines[@]:1}"; do
  name=$(echo "$line" | awk -F "," '{print $1}')
  roll=$(echo "$line" | awk -F "," '{print $2}')
  class=$(echo "$line" | awk -F "," '{print $3}')
  city=$(echo "$line" | awk -F "," '{print $4}')
  format_row "$name" "$roll" "$class" "$city"
done

# Print the table footer
printf "+------------+-------+------------+------------+\n"

