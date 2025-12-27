#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
SOURCE_DIR="./motd-files"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (sudo ./update.sh)"
  exit 1
fi

echo "Updating Linux MOTD..."

# 1. Pull latest changes from git
echo "Pulling latest changes from repository..."
git pull

# 2. Update files
if [ -d "$SOURCE_DIR" ]; then
    echo "Updating installed files in $MOTD_DIR..."
    # We use cp -r to overwrite existing files
    cp -r "$SOURCE_DIR/"* "$MOTD_DIR/"
else
    echo "Error: Source directory $SOURCE_DIR not found!"
    exit 1
fi

# 3. Re-apply permissions
echo "Setting permissions..."
chmod +x "$MOTD_DIR"/*
[ -f "$MOTD_DIR/logo.txt" ] && chmod -x "$MOTD_DIR/logo.txt"

echo "------------------------------------------------"
echo "Update complete!"
