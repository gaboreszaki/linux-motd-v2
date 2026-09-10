#!/bin/bash
set -euo pipefail

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"
SOURCE_DIR="./motd-files"

# Load Common Scripts
# shellcheck source=./common.sh
source ./common.sh

draw_line
log_info "Starting Installation"
draw_line

validate_root_privileges

# Verify dependencies
check_dependencies "mkdir" "cp" "rm" "chmod"

get_config_script

log_info "Backup:"
# 1. Create Backup of existing files
if [[ -d "$MOTD_DIR" ]]; then
    # Check if backup already exists to prevent overwriting the original backup with our own files on re-runs
    if [[ ! -d "$BACKUP_DIR" ]]; then
        log_success "Backing up original files to: $BACKUP_DIR..."
        mkdir -p "$BACKUP_DIR"
        # Use find to copy files to avoid globbing issues if directory is empty
        find "$MOTD_DIR" -maxdepth 1 -type f -exec cp -t "$BACKUP_DIR" {} + 2>/dev/null || :
    else
        log_info "Backup directory $BACKUP_DIR already exists. Skipping backup to preserve original files."
    fi
else
    mkdir -p "$MOTD_DIR"
fi

# 2. Clean target directory
log_info "Cleaning target directory $MOTD_DIR..."
# Safety check to avoid rm -rf /
if [[ "$MOTD_DIR" == "/etc/update-motd.d" ]]; then
    rm -rf "${MOTD_DIR:?}"/*
fi

# 3. Copy new files
if [[ -d "$SOURCE_DIR" ]]; then
    log_info "Copying new MOTD files..."
    cp -r "$SOURCE_DIR/"* "$MOTD_DIR/"
else
    log_error "Source directory $SOURCE_DIR not found!"
    exit 1
fi

# 4. Set permissions
log_info "Setting permissions..."
chmod +x "$MOTD_DIR"/*

# Remove execute permission from non-script files if they exist
for file in "logo-default.txt" "logo-custom.txt" "motd.conf"; do
    [[ -f "$MOTD_DIR/$file" ]] && chmod -x "$MOTD_DIR/$file"
done

# Helper might be sourced or executed, ensure it is executable
[[ -f "$MOTD_DIR/helper.sh" ]] && chmod +x "$MOTD_DIR/helper.sh"

draw_line
display_notes
draw_line

log_success "Installation complete!"

