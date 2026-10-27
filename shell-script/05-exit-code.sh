#!/bin/bash

## Assignment 5 — Exit Codes
failed=0

#1. Runs `ls /tmp` and checks if it succeeded — print `SUCCESS` or `FAILURE`
ls /tmp
if [ $? -eq 0 ]; then
    echo "SUCCESS"
else 
    echo "FAILURE"
    failed=1
fi

#2. Runs `ls /fakedir` and checks — print `SUCCESS` or `FAILURE`
ls /fakedir
if [ $? -eq 0 ]; then
    echo "SUCCESS"
else 
    echo "FAILURE"
    failed=1
fi

#3. Runs `ping -c1 google.com` and checks — print `Host reachable` or `Host not reachable`
ping -c1 google.com
if [ $? -eq 0 ]; then
    echo "Host reachable"
else 
    echo "Host not reachable"
    failed=1
fi

#4. At the end, exit the script with code `0` if all commands succeeded, or `1` if any failed
exit $failed