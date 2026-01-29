#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"

# Load Common Scripts
source ./common.sh

draw_line
echo -e "${LCYAN}Uninstalling Linux MOTD...${NC}"
draw_line

valvalidate_root_privileges
get_config_script

# 1. Remove current files
echo -e "${LGREEN}Removing installed files from $MOTD_DIR...${NC}"
rm -rf "${MOTD_DIR:?}/"*

# 2. Restore backup
if [ -d "$BACKUP_DIR" ]; then
    echo -e "${LGREEN}Restoring original files from $BACKUP_DIR...${NC}"
    if [ "$(ls -A $BACKUP_DIR)" ]; then
        cp -r "$BACKUP_DIR/"* "$MOTD_DIR/"
        chmod +x "$MOTD_DIR"/*
        echo -e "${GREEN}Backup restored successfully.${NC}"
    else
        echo -e "${RED}Warning: Backup directory exists but is empty.${NC}"
    fi
    
    # Optional: Remove backup directory after restore?
    # rm -rf "$BACKUP_DIR"
    echo -e "${CYAN}Note:${NC} Backup folder $BACKUP_DIR was kept."
else
    echo -e "${RED}Warning: No backup directory found at $BACKUP_DIR. Directory $MOTD_DIR is now empty.${NC}"
fi

draw_line
echo -e "${GREEN}Uninstallation complete.${NC}\n"
