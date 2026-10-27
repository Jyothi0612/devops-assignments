#!/bin/bash

## Assignment 9 — Conditions: Package Installer

if [ $# -eq 0 ]; then
    echo "Usage: sudo sh 09-installer.sh <package>"
    exit 1
fi

#1. Checks if the script is run as **root** — if not, print an error and exit with code `1`
user_id=$(id -u)

if [ $user_id -ne 0 ]; then
    echo "Please run this script with sudo access"
    exit 1
fi

#2. Accepts a package name as argument (e.g., `nginx`)
package_name=$1

#3. Checks if the package is **already installed** — if yes, print `nginx is already installed` and exit
dnf list installed $package_name &>/dev/null
if [ $? -eq 0 ]; then
    echo "$package_name is already installed"
    exit 0
fi

#4. If not installed, installs it using `dnf install -y`
dnf install -y $package_name  &>/dev/null

#5. Checks the exit status after install — prints `nginx installed successfully` or `nginx installation failed`
if [ $? -eq 0 ]; then
    echo "$package_name installed successfully"
else
    echo "$package_name installation failed"
    exit 1
fi