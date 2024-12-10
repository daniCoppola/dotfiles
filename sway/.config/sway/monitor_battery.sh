#!/bin/bash
# This program uses upower to check the battery percentage every 5 seconds
# Dependencies: upower, libnotify, alsa-utils * mako?? *
# Havent tested without mako, but it should work without it...  

# Defaults
THRESHOLD=60  # threshold percentage to send a notification
NOTIFICATION_SENT=0

while  true;  do
# Calculate the current percentage and round to whole number
    CURRENT_PERCENTAGE=$(upower -i $(upower -e | grep 'BAT')  | awk '/percentage/ {print $2}'  | tr -d '%')
    STATUS=$(upower -i $(upower -e | grep 'BAT')  | grep -oP 'state:\s+\K\w+')
# Convert the status to an integer for easier comparison later
    case  "$STATUS"  in
        "charging") STATUS=1 ;;
        "discharging") STATUS=0 ;;
        *) STATUS=-1 ;;
    esac

# Send a notification if
# 1. The battery is discharging
# 2. The current percentage is less than the threshold
# 3. A notification hasn't been sent yet
    if  [  "$CURRENT_PERCENTAGE"  -lt  "$THRESHOLD"  ]  &&  [  "$STATUS"  -eq  0  ]  &&  [  "$NOTIFICATION_SENT"  -eq  0  ];  then
    # Send the notification and play a sound
 z       notify-send -u  low  -a  "Battery Manager"  -t  5000  "Low battery. Please plug in."
    #This is for playing a sound, you can comment it out if you don't want it or change it to something else
        aplay yourSound.wav  >  /dev/null  2>&1
    # IMPORTANT: Set the notification sent flag to 1 so we don't send 
    # another notification until the battery is charged
        NOTIFICATION_SENT=1
    fi

# Reset the notification sent flag if the battery is charging
    if  [  $STATUS -eq  1  ];  then
        NOTIFICATION_SENT=0
    fi

    sleep 5
done
