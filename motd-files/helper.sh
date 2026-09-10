#!/bin/bash
# Safety: This script is intended to be sourced by other MOTD scripts.
# It uses Bash-specific features like [[ ]] and local variables.

LOGO_FILE="/etc/update-motd.d/logo-default.txt"
CUSTOM_LOGO_FILE="/etc/update-motd.d/logo-custom.txt"
CONFIG_FILE="/etc/update-motd.d/motd.conf"

# Check for custom logo
if [[ -f "$CUSTOM_LOGO_FILE" ]]; then
    LOGO_FILE="$CUSTOM_LOGO_FILE"
fi

# Load Configuration if it exists
# shellcheck source=/dev/null
[[ -f "$CONFIG_FILE" ]] && . "$CONFIG_FILE"

# Color codes
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
ORANGE='\033[0;33m'

LBLACK='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
LWHITE='\033[1;37m'

BG_BLUE='\033[44m'
BG_RED='\033[41m'

print_rainbow_logo() {
    if [[ -f "$LOGO_FILE" ]]; then
        local colors=("${RED}" "${YELLOW}" "${GREEN}" "${CYAN}")
        local i=0
        while IFS= read -r line || [[ -n "$line" ]]; do
            local color="${colors[i % 4]}"
            printf "${color}%s${NC}\n" "$line"
            ((i++))
        done < "$LOGO_FILE"
    fi
}

print_colored_logo() {
    local color_code="$1"
    # If a variable name was passed (e.g. "LBLUE"), try to resolve it
    if [[ "$color_code" =~ ^[A-Z_]+$ ]]; then
        color_code="${!color_code:-$color_code}"
    fi

    if [[ -f "$LOGO_FILE" ]]; then
        while IFS= read -r line || [[ -n "$line" ]]; do
            printf "${color_code}%s${NC}\n" "$line"
        done < "$LOGO_FILE"
    fi
}

print_empty_line(){
    printf "\n"
}

# --- Generic Output Helpers ---

# Print a section header
print_header() {
    printf "\n${LBLUE} %s ${NC}\n" "$1"
}

# Print a row in Normal View
# Usage: print_normal_row "Label:" "Value" ["Color"]
print_normal_row() {
    local label="$1"
    local value="$2"
    local color="${3:-$NC}"
    printf "  %-20s ${color}%b${NC}\n" "$label" "$value"
}

# Print a table header
# Usage: print_table_header "Col1" "Col2" ...
print_table_header() {
    local cols=("$@")
    printf " ${BG_BLUE}|"
    for col in "${cols[@]}"; do
        printf " %-15s |" "$col"
    done
    printf "${NC}\n"
}

# Print a table row
# Usage: print_table_row "Val1" "Val2" ...
# Note: Since colors might be embedded in values, we use %b and fixed widths carefully.
# This simple version assumes 15 width.
print_table_row() {
    local vals=("$@")
    printf " |"
    for val in "${vals[@]}"; do
        printf " %-15b |" "$val"
    done
    printf "\n"
}