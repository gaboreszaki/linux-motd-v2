#!/bin/bash

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"
SOURCE_DIR="./motd-files"

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (sudo ./setup.sh)"
  exit 1
fi

# --- Interactive Configuration ---
# Load configuration function
if [ -f "./configure.sh" ]; then
    source ./configure.sh
else
    echo "Error: configure.sh not found."
    exit 1
fi

configure_motd "$SOURCE_DIR" "$MOTD_DIR"

echo "Starting installation..."

# 1. Create Backup of existing files
if [ -d "$MOTD_DIR" ]; then
    # Check if backup already exists to prevent overwriting the original backup with our own files on re-runs
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "Backing up original files to $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        cp -r "$MOTD_DIR/"* "$BACKUP_DIR/" 2>/dev/null || :
    else
        echo "Backup directory $BACKUP_DIR already exists. Skipping backup to preserve original files."
    fi
else
    mkdir -p "$MOTD_DIR"
fi

# 2. Clean target directory
echo "Cleaning target directory $MOTD_DIR..."
rm -rf "$MOTD_DIR"/*

# 3. Copy new files
if [ -d "$SOURCE_DIR" ]; then
    echo "Copying new MOTD files..."
    cp -r "$SOURCE_DIR/"* "$MOTD_DIR/"
else
    echo "Error: Source directory $SOURCE_DIR not found!"
    exit 1
fi

# 4. Set permissions
echo "Setting permissions..."
chmod +x "$MOTD_DIR"/*
# Remove execute permission from non-script files if they exist
[ -f "$MOTD_DIR/logo.txt" ] && chmod -x "$MOTD_DIR/logo.txt"
[ -f "$MOTD_DIR/helper.sh" ] && chmod +x "$MOTD_DIR/helper.sh" # Helper might be sourced or executed

echo "------------------------------------------------"
echo "Installation complete!"
echo "Try logging in to a new terminal session or run 'run-parts /etc/update-motd.d' to test."
