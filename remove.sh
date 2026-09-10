#!/bin/bash
set -euo pipefail

# Configuration
MOTD_DIR="/etc/update-motd.d"
BACKUP_DIR="/etc/update-motd.d.bak"

# Load Common Scripts
# shellcheck source=./common.sh
source ./common.sh

draw_line
log_info "Uninstalling Linux MOTD..."
draw_line

validate_root_privileges

# 1. Remove current files
log_info "Removing installed files from $MOTD_DIR..."
if [[ "$MOTD_DIR" == "/etc/update-motd.d" ]]; then
    rm -rf "${MOTD_DIR:?}"/*
fi

# 2. Restore backup
if [[ -d "$BACKUP_DIR" ]]; then
    log_info "Restoring original files from $BACKUP_DIR..."
    # Check if backup directory is not empty
    if [[ -n "$(ls -A "$BACKUP_DIR")" ]]; then
        cp -r "$BACKUP_DIR/"* "$MOTD_DIR/"
        chmod +x "$MOTD_DIR"/*
        log_success "Backup restored successfully."
    else
        log_warn "Backup directory exists but is empty."
    fi
    
    log_info "Backup folder $BACKUP_DIR was kept for safety."
else
    log_warn "No backup directory found at $BACKUP_DIR. Directory $MOTD_DIR is now empty."
fi

draw_line
log_success "Uninstallation complete."
