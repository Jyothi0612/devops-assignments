#!/bin/bash

## Assignment 1 — Hello World & Shebang

# 1. Prints `Hello, World!`
echo "Hello, World!"

# 2. Prints the current date and time
date=$(date "+%a %b %d %H:%M:%S %Z %Y")
echo "Today is: $date"

#3. Prints the name of the user running the script
echo "Running as: $USER"

#4. Prints the directory the script is running from
echo "Current directory: $PWD"
