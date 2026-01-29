#!/bin/sh

LOGO_FILE="/etc/update-motd.d/logo-default.txt"
CUSTOM_LOGO_FILE="/etc/update-motd.d/logo-custom.txt"
CONFIG_FILE="/etc/update-motd.d/motd.conf"

# Check for custom logo
if [ -f "$CUSTOM_LOGO_FILE" ]; then
    LOGO_FILE="$CUSTOM_LOGO_FILE"
fi


# Load Configuration if exists
if [ -f "$CONFIG_FILE" ]; then
    . "$CONFIG_FILE"
fi

# Color codes
NC='\033[0m' # No Color

# Regular Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold/Light Colors
LBLACK='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
LWHITE='\033[1;37m'

# Underline
UBLACK='\033[4;30m'
URED='\033[4;31m'
UGREEN='\033[4;32m'
UYELLOW='\033[4;33m'
UBLUE='\033[4;34m'
UPURPLE='\033[4;35m'
UCYAN='\033[4;36m'
UWHITE='\033[4;37m'

# Background
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'

print_rainbow_logo() {

  if [ -f "$LOGO_FILE" ]; then
    # Assigning colors to an array-like sequence for the lines
    # Line 1: Red, Line 2: Yellow, Line 3: Green, Line 4: Blue/Cyan
    sed -n '1p' "$LOGO_FILE" | printf "${LRED}%s${NC}\n" "$(cat)"
    sed -n '2p' "$LOGO_FILE" | printf "${LYELLOW}%s${NC}\n" "$(cat)"
    sed -n '3p' "$LOGO_FILE" | printf "${LGREEN}%s${NC}\n" "$(cat)"
    sed -n '4p' "$LOGO_FILE" | printf "${LCYAN}%s${NC}\n" "$(cat)"
  fi
}

print_colored_logo() {
  # This line allows you to pass the name (LBLUE) or the variable ($LBLUE)
  color_name=$1
  color_code=$(eval echo \$"$color_name")

  if [ -f "$LOGO_FILE" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
      printf "${color_code:-$color_name}%s${NC}\n" "$line"
    done < "$LOGO_FILE"
  fi

}

print_empty_line(){
  printf "\n"
}