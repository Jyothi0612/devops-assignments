#!/bin/bash

## Assignment 7 — Conditions: Prime Number or Not

#1. Accepts a number as a command line argument
number=$1

#2. Validates that the argument is provided — exit with an error if missing
if [ $# -eq 0 ]; then
    echo "Usage: sh 07-prime.sh <number>"
    exit 1
fi

#3. Checks whether the number is a **prime number** or not
if [ $number -lt 2 ]; then
    echo "$number is not prime"
    exit 0
else
    for ((i=2; i<number; i++))
    do
        if [ $((number % i)) -eq 0 ]; then
            echo "$number is not prime"
            exit 0
        fi
    done
fi

#4. Prints the result
echo "$number is prime"