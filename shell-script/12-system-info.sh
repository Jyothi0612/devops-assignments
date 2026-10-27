## Assignment 12 — Putting It All Together

#1. Accepts one argument: a **server name** (label only)
server_name=$1
log_file="/tmp/system-info.log"

#2. Validates that the argument is provided — exit with error if missing
if [ $# -eq 0 ]; then
    echo "Usage: sh 12-system-info.sh <server-name>"
    exit 1
fi

#3. Defines a function `section` that prints a heading separator
section() {
    echo "========================================" | tee -a $log_file
    echo "$1" | tee -a $log_file
    echo "========================================" | tee -a $log_file
}

#4. Collects the information
start_time=$(date "+%F %T")
os=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
disk_usage=$(df -h / | awk 'NR==2 {print $3 " used of " $2}')
memory_usage=$(free -h | awk '/^Mem/ {print $3 " used of " $2}')
up_time=$(uptime -p)

#5. Prints everything and logs it to /tmp/system-info.log
section "System Info Report — $server_name"
echo "Script PID    : $$"             | tee -a $log_file
echo "Started at    : $start_time"    | tee -a $log_file
echo "User          : $USER"          | tee -a $log_file
echo "Home          : $HOME"          | tee -a $log_file
echo "OS            : $os"            | tee -a $log_file
echo "Disk (/)      : $disk_usage"    | tee -a $log_file
echo "Memory        : $memory_usage"  | tee -a $log_file
echo "Uptime        : $up_time"       | tee -a $log_file
echo "========================================" | tee -a $log_file

#6. Prints total script execution time at the end
echo "Script completed in $SECONDS seconds" | tee -a $log_file