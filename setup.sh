#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"
SOURCE_DIR="./motd-files"
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

echo -e "${BLUE}Starting Installation${NC}"
echo -e "${BLUE}------------------------------------------------${NC}\n"

# --- Interactive Configuration ---
# Load and run configuration
echo -e "${LBLUE}Loading Configure script${NC}"
if [ -f "./configure.sh" ]; then
    source ./configure.sh
    configure_motd "$SOURCE_DIR" "$MOTD_DIR"
else
    echo -e "${RED}Warning: configure.sh not found. Skipping configuration.${NC}"
fi


echo -e "${LBLUE}Backup:${NC}"
# 1. Create Backup of existing files
if [ -d "$MOTD_DIR" ]; then
    # Check if backup already exists to prevent overwriting the original backup with our own files on re-runs
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${LGREEN}Backing up original files to:${NC} $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$MOTD_DIR/"* "$BACKUP_DIR/" 2>/dev/null || :
    else
        echo -e "${LCYAN}Backup directory $BACKUP_DIR already exists. Skipping backup to preserve original files.${NC}"
    fi
else
    mkdir -p "$MOTD_DIR"
fi

# 2. Clean target directory
echo -e "${LGREEN}Cleaning target directory $MOTD_DIR...${NC}"
rm -rf "${MOTD_DIR:?}/"*

# 3. Copy new files
if [ -d "$SOURCE_DIR" ]; then
    echo -e "${LGREEN}Copying new MOTD files...${NC}"
    cp -r "$SOURCE_DIR/"* "$MOTD_DIR/"
else
    echo -e "${RED}Error: Source directory $SOURCE_DIR not found!${NC}"
    exit 1
fi

# 4. Set permissions
echo -e "${LGREEN}Setting permissions...${NC}"
chmod +x "$MOTD_DIR"/*
# Remove execute permission from non-script files if they exist
[ -f "$MOTD_DIR/logo-default.txt" ] && chmod -x "$MOTD_DIR/logo-default.txt"
[ -f "$MOTD_DIR/logo-custom.txt" ] && chmod -x "$MOTD_DIR/logo-custom.txt"
[ -f "$MOTD_DIR/helper.sh" ] && chmod +x "$MOTD_DIR/helper.sh" # Helper might be sourced or executed

echo -e "${BLUE}------------------------------------------------${NC}"
echo -e "Installation complete!"
echo -e "${LCYAN}Note:${NC} To add a custom logo file run 'nano /etc/update-motd.d/logo-custom.txt' and paste your logo."
echo -e "${LCYAN}Note:${NC} Try logging in to a new terminal session or run 'run-parts /etc/update-motd.d' to test.\n"
