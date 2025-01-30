#!/bin/bash
# list of websites. each website on a new line. leave an empty line at the end.
LISTFILE=/root/script/websites.lst
# Send mail in case of failure to. each email on a new line. leave an empty line at the end.
EMAILLISTFILE=/root/script/emails.lst

# `Quiet` is true when in crontab; show output when it's run manually from the shell.
# Set THIS_IS_CRON=1 in the beginning of your crontab -e.
# Otherwise, you will get the output to your email every time.

if [ -n "$THIS_IS_CRON" ]; then
  QUIET=true
else
  QUIET=false
fi

function test_website {
  response=$(curl --write-out %{http_code} --silent --output /dev/null -L "$1")
  filename=$(echo "$1" | awk -F/ '{print $3}')

  if [ "$QUIET" = false ]; then
    echo -n "$1 "
  fi

  if [ "$response" -eq 200 ]|| [ "$response" -eq 302 ]; then
    # Website is working
    if [ "$QUIET" = false ]; then
      echo -n "$response "
      echo -e "\e[32m[ok]\e[0m"
    fi
    # Remove .temp file if it exists.
    if [ -f "cache/$filename" ]; then
      rm -f "cache/$filename"
    fi
  else
    # Website is down
    if [ "$QUIET" = false ]; then
      echo -n "$response "
      echo -e "\e[31m[DOWN]\e[0m"
    fi
    if [ ! -f "cache/$filename" ]; then
      while IFS= read -r email; do
        # Send email notification
        echo "$1 WEBSITE DOWN" | mailx -s "$1 WEBSITE DOWN" "$email"
      done < "$EMAILLISTFILE"
      echo > "cache/$filename"
    fi
  fi
}

# Main loop
while IFS= read -r website; do
  test_website "$website"
done < "$LISTFILE"

