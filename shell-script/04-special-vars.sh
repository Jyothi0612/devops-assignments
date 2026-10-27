#!/bin/bash

## Assignment 4 — Special Variables

#1. Print who is running the script
echo "Running as     : $USER"

#2. Print the current directory
echo "Directory      : $PWD"

#3. Print the home directory
echo "Home           : $HOME"

#4. Print the PID of the script
echo "Script PID     : $$"

#5. Run `sleep 10` in the **background** and print its PID
sleep 10 &
echo "Background PID : $!"
wait $!

#6. Print a random number between 1–100
echo "Random number  : $((RANDOM % 100 + 1))"

#7. At the end, print how many seconds the script took to run
echo "Script ran in $SECONDS seconds"