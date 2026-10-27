#!/bin/bash

#1. `print_header` — prints a separator line and a heading passed as argument
print_header() {
    echo "======================"
    echo "$1"
    echo "======================"
}

print_header "Installing packages"

#2. `check_status` — accepts an exit code and a message; prints `SUCCESS: <message>` or `FAILURE: <message>`

check_status() {
    if [ $1 -ne 0 ]; then
        echo "FAILURE: ${2} installation failed"
        exit 1
    else
        echo "SUCCESS: ${2} installed"
    fi 
}

ls /tmp &>/dev/null
check_status $? "Listing /tmp"

#3. `install_package` — accepts a package name; checks if installed, installs if not, uses `check_status` to report

install_package() {
    package_name=$1
    dnf list installed $package_name &>/dev/null
    if [ $? -ne 0 ]; then
        dnf install -y $package_name  &>/dev/null
        check_status $? "$package_name"
    else
        echo "$package_name is already installed"
    fi
}

install_package git
install_package wget
install_package curl