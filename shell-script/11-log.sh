#!/bin/bash

## Assignment 11 — Redirections & Logging

#1. Creates a log file at `/tmp/script.log`
log_file="/tmp/script.log"
error_log_file="/tmp/script-errors.log"
touch $log_file

#2. Redirects all **success output** to the log file
#3. Redirects all **error output** to `/tmp/script-errors.log`
#4. Runs three commands: `ls /tmp`, `ls /fakedir`, `date`
ls /tmp      >> $log_file 2>> $error_log_file
ls /fakedir  >> $log_file 2>> $error_log_file
date         >> $log_file 2>> $error_log_file

#5. At the end, prints the contents of both log files
echo "======= Success log ========"
cat /tmp/script.log
echo "======= Failure log ========"
cat /tmp/script-errors.log