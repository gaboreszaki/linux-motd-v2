#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (sudo ./uninstall.sh)"
  exit 1
fi

echo "Uninstalling Linux MOTD..."

# 1. Remove current files
echo "Removing installed files from $MOTD_DIR..."
rm -rf "$MOTD_DIR"/*

# 2. Restore backup
if [ -d "$BACKUP_DIR" ]; then
    echo "Restoring original files from $BACKUP_DIR..."
    if [ "$(ls -A $BACKUP_DIR)" ]; then
        cp -r "$BACKUP_DIR/"* "$MOTD_DIR/"
        chmod +x "$MOTD_DIR"/*
        echo "Backup restored successfully."
    else
        echo "Warning: Backup directory exists but is empty."
    fi
    
    # Optional: Remove backup directory after restore?
    # rm -rf "$BACKUP_DIR"
    echo "Note: Backup folder $BACKUP_DIR was kept."
else
    echo "Warning: No backup directory found at $BACKUP_DIR. Directory $MOTD_DIR is now empty."
fi

echo "------------------------------------------------"
echo "Uninstallation complete."
