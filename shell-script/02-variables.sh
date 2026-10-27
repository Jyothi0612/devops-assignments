#!/bin/bash

## Assignment 2 — Variables & DRY Principle

# 1. Store your name, age, and city in variables
name="Jyothi"        # was "SivaJyothi"
age="35"
city="Hyderabad"

# 2. Print a sentence using all three variables
echo "My name is $name, I am $age years old and I live in $city"

#3. Calculate and print how many years until you turn 60
remaining_years=$((60 - age))
echo "Years until 60: $remaining_years"

#4. Change the name variable to a different name and verify only **one line** needs to change
#   Changed name="SivaJyothi" to name="Jyothi" on line 6. The output updated.