#!/bin/bash
set -euo pipefail

# Load Common Scripts
# shellcheck source=./common.sh
source ./common.sh

draw_line
log_info "Updating Linux MOTD..."
draw_line

validate_root_privileges

# 1. Pull latest changes from git
if [[ -d .git ]]; then
    check_dependencies "git"
    log_info "Resetting local changes. (custom logo and settings are not affected)"
    git reset --hard HEAD
    log_info "Pulling latest changes from repository..."
    git pull
else
    log_warn "Not a git repository. Skipping git update."
fi

log_info "Ensuring script files are executable"
chmod +x setup.sh update.sh remove.sh configure.sh

# Run setup to apply changes
./setup.sh

