#!/bin/bash
RED='\033[0;31m' # Red color
YELLOW='\033[1;33m'  # Yellow color
NC='\033[0m' # No Color


# Function to display help
function help {
  echo "Usage:" >&2
  echo "--nsfw_lvl: Set NSFW level (sfw, pg13, nsfw, all, auto). Default: sfw" >&2
  echo "--timezone: Set timezone. Default: America/New_York" >&2
  echo "--timer: Set timer (pattern Xmin, e.g., 15min). Default: 10min" >&2
  echo "--allow-root: Allow the script to run as root (confirmation required)" >&2
  echo "--help: Display this help message" >&2
}

# Function to check if a timezone is valid
function is_valid_timezone() {
    local timezone=$1
    if [ -f "/usr/share/zoneinfo/$timezone" ] || [ -f "/usr/share/lib/zoneinfo/$timezone" ] || [ -f "/usr/share/zoneinfo/posix/$timezone" ]; then
        return 0 # valid
    else
        return 1 # invalid
    fi
}

# Function to confirm running as root
function confirm_root_execution() {
    echo -e "${RED}Warning: You have chosen to run the script as root.${NC}"
    echo -e  "${YELLOW}This option should only be used if you are specifically intending to apply the changes for the root user account as it will not affect the settings of normal user accounts.${NC}"
    echo -e  "${YELLOW}It should be used with caution and only if you understand the implications of executing scripts with root privileges.${NC}"
    echo -ne "${RED}Are you sure you want to proceed? (yes/no): ${NC}"
    read confirmation
    if [[ "$confirmation" != "yes" ]]; then
        echo "Execution as root user aborted."
        exit 1
    fi
}

# Default values
NSFW_LVL="sfw"
TIMEZONE="America/New_York"
TIMER="10min"
ALLOW_ROOT=0

# Use getopt to parse the options
TEMP=$(getopt -o : --long nsfw_lvl:,timezone:,timer:,allow-root,help -n 'parse-options.sh' -- "$@")
if [ $? != 0 ]; then
  help
  exit 1
fi

# Evaluate the parsed options
eval set -- "$TEMP"

# Extract options and their arguments into variables
while true; do
    case "$1" in
        --nsfw_lvl)
          NSFW_LVL="$2"
          shift 2
          ;;
        --timezone)
          TIMEZONE="$2"
          shift 2
          ;;
        --timer)
          TIMER="$2"
          shift 2
          ;;
        --allow-root)
          ALLOW_ROOT=1
          shift
          ;;
        --help)
          help
          exit 0
          ;;
        --) shift ; break ;;
        *) echo "Internal error! $1" ; exit 1 ;;
    esac
done

# Check if the script is running as root and if --allow-root was passed
if [ "$(id -u)" == "0" ] && [ "$ALLOW_ROOT" -eq 1 ]; then
    confirm_root_execution
elif [ "$(id -u)" == "0" ]; then
    echo "This script should not be run as root or with sudo."
    echo "Please run as a regular user or use the --allow-root option if you really meant to do this."
    exit 1
fi

# Validate nsfw_lvl
if ! [[ "$NSFW_LVL" =~ ^(sfw|pg13|nsfw|all|auto)$ ]]; then
  echo "Invalid nsfw_lvl option: $NSFW_LVL"
  exit 1
fi

# Validate timer
if ! [[ "$TIMER" =~ ^[1-9][0-9]*min$ ]]; then
  echo "Invalid timer format: $TIMER. It should match the Xmin pattern, where X is a non-zero number."
  exit 1
fi

# Validate timezone
if ! is_valid_timezone "$TIMEZONE"; then
  echo "Invalid timezone: $TIMEZONE"
  exit 1
fi

#install service with specified options
sed -i -e 's/USERVAR/'$USER'/g' animebg.service
sed -i -e 's/TIMERVAR/'$TIMER'/g' animebg.timer
sed -i -e 's/NSFWVAR/'$NSFW_LVL'/g' animebg.py

if [ "$NSFW_LVL" = "auto" ]; then
    sed -i -e 's@TZVAR@?timezone='$TIMEZONE'@g' animebg.py
else
    sed -i -e 's/TZVAR//g' animebg.py
fi

sudo cp animebg.py /usr/bin/animebg.py
sudo cp animebg.service /etc/systemd/system/animebg.service
sudo cp animebg.timer /etc/systemd/system/animebg.timer
sudo systemctl daemon-reload

sudo systemctl start animebg.timer && systemctl enable animebg.timer