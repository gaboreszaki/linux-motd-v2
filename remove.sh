#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"
TEXT_COLORS="./text-colors.sh"

if [ -f "$TEXT_COLORS" ]; then
    # shellcheck source=./text-colors.sh
    . "$TEXT_COLORS"
fi

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Error: Please run as root (sudo ./remove.sh)${NC}"
  exit 1
fi

echo -e "${BLUE}Uninstalling Linux MOTD...${NC}"

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
    echo -e "${LCYAN}Note:${NC} Backup folder $BACKUP_DIR was kept."
else
    echo -e "${RED}Warning: No backup directory found at $BACKUP_DIR. Directory $MOTD_DIR is now empty.${NC}"
fi

echo -e "${BLUE}------------------------------------------------${NC}"
echo -e "${GREEN}Uninstallation complete.${NC}"
