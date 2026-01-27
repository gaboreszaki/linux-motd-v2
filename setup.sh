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
MOTD_CONF="$SOURCE_DIR/motd.conf"

ask_yes_no() {
    local prompt="$1"
    local config_var="$2"
    local default="$3"

    while true; do
        read -p "$prompt (y/n) [$default]: " yn
        case $yn in
            [Yy]* ) echo "$config_var=\"y\"" >> "$MOTD_CONF"; break;;
            [Nn]* ) echo "$config_var=\"n\"" >> "$MOTD_CONF"; break;;
            "" ) echo "$config_var=\"$default\"" >> "$MOTD_CONF"; break;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

echo "------------------------------------------------"
echo "Interactive Configuration"
echo "------------------------------------------------"

# Try to import config from current installation if local is missing
if [ ! -f "$MOTD_CONF" ] && [ -f "$MOTD_DIR/motd.conf" ]; then
    cp "$MOTD_DIR/motd.conf" "$MOTD_CONF"
    echo "Imported existing configuration from $MOTD_DIR."
fi

DO_CONFIGURE=true
if [ -f "$MOTD_CONF" ]; then
    read -p "Configuration file found. Reconfigure? (y/n) [n]: " yn
    case $yn in
        [Yy]* ) DO_CONFIGURE=true ;;
        * ) DO_CONFIGURE=false ;;
    esac
fi

if [ "$DO_CONFIGURE" = true ]; then
    # Initialize config file
    mkdir -p "$SOURCE_DIR"
    echo "# Linux MOTD Config" > "$MOTD_CONF"

    ask_yes_no "Enable Header (Logo)?" "ENABLE_HEADER" "y"
    ask_yes_no "Enable System Info?" "ENABLE_SYSINFO" "y"
    ask_yes_no "Enable Disk Usage?" "ENABLE_DISK_USAGE" "y"
    ask_yes_no "Enable Host & Web Services?" "ENABLE_HOST_SERVICES" "y"
    ask_yes_no "Enable User Info?" "ENABLE_USERS" "y"
    ask_yes_no "Enable Fail2Ban Protection?" "ENABLE_FAIL2BAN" "y"
    ask_yes_no "Enable Updates & Maintenance?" "ENABLE_UPDATES" "y"

    echo "Configuration saved."
else
    echo "Skipping configuration steps. Using existing motd.conf."
fi
echo "------------------------------------------------"

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
