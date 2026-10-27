#!/bin/bash

## Assignment 6 — Conditions: Even or Odd

# Stop if no number was given
if [ $# -eq 0 ]; then
    echo "Usage: sh 06-even-odd.sh <number>"
    exit 1
fi

#1. Accepts a number as a command line argument
number=$1
result=""

#2. Checks if the number is even or odd using the modulo operator
if [ $((number % 2)) -eq 0 ]; then
    result="even"
else
    result="odd"
fi

#3. Prints the result
echo "$number is $result"