#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"
SOURCE_DIR="./motd-files"


# Load Common Scripts
. common.sh
draw_line
echo -e "${LCYAN}Starting Installation${NC}"
draw_line

valvalidate_root_privileges
get_config_script


echo -e "${CYAN}Backup:${NC}"
# 1. Create Backup of existing files
if [ -d "$MOTD_DIR" ]; then
    # Check if backup already exists to prevent overwriting the original backup with our own files on re-runs
    if [ ! -d "$BACKUP_DIR" ]; then
        echo -e "${LGREEN}Backing up original files to:${NC} $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$MOTD_DIR/"* "$BACKUP_DIR/" 2>/dev/null || :
    else
        echo -e "${CYAN}Backup directory $BACKUP_DIR already exists. Skipping backup to preserve original files.${NC}"
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

draw_line
display_notes
draw_line

echo -e "${LGREEN}Installation complete!${NC} \n"

