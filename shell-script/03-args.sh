#!/bin/bash

## Assignment 3 — Command Line Arguments

#Write a script `03-args.sh` that accepts two arguments: a **username** and a **country**.

#1. Print: `User <username> is from <country>`
username=$1
country=$2

echo "User $username is from $country"

#2. Print total number of arguments passed
echo "Number of arguments: $#"

#3. Print all arguments passed
echo "All arguments: $@"

#4. Print the script name
echo "Script name: $0"

