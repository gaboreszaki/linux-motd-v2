#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
SOURCE_DIR="./motd-files"

# Load Common Scripts
source ./common.sh
draw_line
echo -e "${LCYAN}Updating Linux MOTD...${NC}"
draw_line

validate_root_privileges


# 1. Pull latest changes from git
echo -e "${LGREEN}Resetting local changes.${NC}(custom logo and settings are not affected)"
git reset --hard HEAD
echo -e "${LGREEN}Pulling latest changes from repository...${NC}"
git pull


echo -e "${LGREEN}Enable execute permissions${NC}"
#1b. Add execute permission to the script files:
chmod +x setup.sh
chmod +x update.sh
chmod +x remove.sh
chmod +x configure.sh

# Load and run configuration
get_config_script

# 2. Update files
echo -e "${CYAN}Update MOTD files${NC}"
if [ -d "$SOURCE_DIR" ]; then
    echo -e "${LGREEN}Updating installed files in $MOTD_DIR...${NC}"
    # We use cp -r to overwrite existing files
    cp -r "$SOURCE_DIR/"* "$MOTD_DIR/"
else
    echo -e "${RED}Error: Source directory $SOURCE_DIR not found!${NC}"
    exit 1
fi

# 3. Re-apply permissions
echo -e "${CYAN}Set permissions for the updated files${NC}"
chmod +x "$MOTD_DIR"/*
echo -e "${LGREEN}Remove execute permission from non-script files${NC}"
# Remove execute permission from non-script files if they exist
[ -f "$MOTD_DIR/logo-default.txt" ] && chmod -x "$MOTD_DIR/logo-default.txt"
[ -f "$MOTD_DIR/logo-custom.txt" ] && chmod -x "$MOTD_DIR/logo-custom.txt"

draw_line
display_notes
draw_line
echo -e "${LGREEN}Update complete!${NC} \n"

