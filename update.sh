#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
SOURCE_DIR="./motd-files"
BRANCH="main"
TEXT_COLORS="./text-colors.sh"

if [ -f "$TEXT_COLORS" ]; then
    # shellcheck source=./text-colors.sh
    . "$TEXT_COLORS"
fi

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root (sudo ./update.sh)${NC}"
  exit 1
fi



echo -e "${BLUE}Updating Linux MOTD...${NC}"
echo -e "${BLUE}------------------------------------------------${NC}\n"
# 1. Pull latest changes from git
echo -e "${LGREEN}Resetting local changes.${NC}(custom logo and settings are not affected)"
git reset --hard HEAD
echo -e "${LGREEN}Pulling latest changes from repository...${NC}"
git pull
echo -e "${LGREEN}Change branch to: ${BRANCH}${NC}"
git checkout ${BRANCH}

echo -e "${LGREEN}Enable execute permissions${NC}"
#1b. Add execute permission to the script files:
chmod +x setup.sh
chmod +x update.sh
chmod +x remove.sh
chmod +x configure.sh

# Load and run configuration
echo -e "${LBLUE}Loading Configure script${NC}"
if [ -f "./configure.sh" ]; then
    source ./configure.sh
    configure_motd "$SOURCE_DIR" "$MOTD_DIR"
else
    echo -e "${RED}Warning: configure.sh not found. Skipping configuration.${NC}"
fi

# 2. Update files
echo -e "${LBLUE}Update MOTD files${NC}"
if [ -d "$SOURCE_DIR" ]; then
    echo -e "${LGREEN}Updating installed files in $MOTD_DIR...${NC}"
    # We use cp -r to overwrite existing files
    cp -r "$SOURCE_DIR/"* "$MOTD_DIR/"
else
    echo -e "${RED}Error: Source directory $SOURCE_DIR not found!${NC}"
    exit 1
fi

# 3. Re-apply permissions
echo -e "${LBLUE}Set permissions for the updated files${NC}"
chmod +x "$MOTD_DIR"/*
echo -e "${LGREEN}Remove execute permission from non-script files${NC}"
# Remove execute permission from non-script files if they exist
[ -f "$MOTD_DIR/logo-default.txt" ] && chmod -x "$MOTD_DIR/logo-default.txt"
[ -f "$MOTD_DIR/logo-custom.txt" ] && chmod -x "$MOTD_DIR/logo-custom.txt"

echo -e "${BLUE}------------------------------------------------${NC}"
echo -e "${GREEN}Update complete!${NC}"
printf "\n"
echo "${LCYAN}Note:${NC} To add or modify a custom logo file run ${LGREEN}'nano /etc/update-motd.d/logo-custom.txt'${NC} and paste your logo."
