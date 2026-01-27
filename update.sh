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
git reset --hard HEAD
git pull

#1b. Add execute permission to the script files:
chmod +x setup.sh
chmod +x update.sh
chmod +x remove.sh
chmod +x configure.sh

# Load and run configuration
if [ -f "./configure.sh" ]; then
    source ./configure.sh
    configure_motd "$SOURCE_DIR" "$MOTD_DIR"
else
    echo "Warning: configure.sh not found. Skipping configuration."
fi

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
# Remove execute permission from non-script files if they exist
[ -f "$MOTD_DIR/logo-default.txt" ] && chmod -x "$MOTD_DIR/logo-default.txt"
[ -f "$MOTD_DIR/logo-custom.txt" ] && chmod -x "$MOTD_DIR/logo-custom.txt"

echo "------------------------------------------------"
echo "Update complete!"
printf "\n"
echo "To add or modify a custom logo file run 'nano /etc/update-motd.d/logo-custom.txt' and paste your logo."
