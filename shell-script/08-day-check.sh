#!/bin/bash

## Assignment 8 — Conditions: Day Check

#1. Gets today's day automatically
echo "Please enter the day"
read day

#2. If it is **Saturday or Sunday**, print `Weekend! Enjoy your holiday.`
#3. If it is **Monday**, print `Start of the week. Let's go!`
#4. For any other day, print `Weekday. Go to school/work.`

if [ "$day" = "Saturday" ] || [ "$day" = "Sunday" ]; then
    echo "Weekend! Enjoy your holiday."
elif [ "$day" = "Monday" ]; then
    echo "Start of the week. Let's go!"
else
    echo "Weekday. Go to school/work."
fi
