#!/bin/bash
set -euo pipefail

configure_motd() {
    local source_dir="${1:-"./motd-files"}"
    local motd_dir="${2:-"/etc/update-motd.d"}"
    local motd_conf="$source_dir/motd.conf"

    ask_option() {
        local prompt="$1"
        local config_var="$2"
        local default="$3"
        local choice

        # Prepare colored prompt
        local prompt_text
        prompt_text=$(printf "${LBLUE}%s${NC} ${LBLACK}(y/n/s/t)${NC} [${WHITE}%s${NC}]: " "$prompt" "$default")

        while true; do
            read -r -p "$prompt_text" choice
            case "${choice:-$default}" in
                [Yy]* ) printf "%s=\"y\"\n" "$config_var" >> "$motd_conf"; break;;
                [Nn]* ) printf "%s=\"n\"\n" "$config_var" >> "$motd_conf"; break;;
                [Ss]* ) printf "%s=\"short\"\n" "$config_var" >> "$motd_conf"; break;;
                [Tt]* ) printf "%s=\"table\"\n" "$config_var" >> "$motd_conf"; break;;
                * ) log_error "Please answer yes, no, short, or table.";;
            esac
        done
    }

    draw_line
    log_info "Configuration"
    draw_line

    # Try to import config from current installation if local is missing
    if [[ ! -f "$motd_conf" ]] && [[ -f "$motd_dir/motd.conf" ]]; then
        cp "$motd_dir/motd.conf" "$motd_conf"
        log_success "Imported existing configuration from $motd_dir."
    fi

    local do_configure=true
    if [[ -f "$motd_conf" ]]; then
        local yn
        printf "${LYELLOW}Configuration file found. Reconfigure? (y/n) [n]: ${NC}"
        read -r yn
        case "$yn" in
            [Yy]* ) do_configure=true ;;
            * ) do_configure=false ;;
        esac
    fi

    if [[ "$do_configure" = true ]]; then
        # Initialize config file
        mkdir -p "$source_dir"
        printf "# Linux MOTD Config\n" > "$motd_conf"

        ask_option "Enable Header (Logo)?" "ENABLE_HEADER" "y"
        ask_option "Enable System Info?" "ENABLE_SYSINFO" "y"
        ask_option "Enable Disk Usage?" "ENABLE_DISK_USAGE" "y"
        ask_option "Enable Host & Web Services?" "ENABLE_HOST_SERVICES" "y"
        ask_option "Enable User Info?" "ENABLE_USERS" "y"
        ask_option "Enable Fail2Ban Protection?" "ENABLE_FAIL2BAN" "y"
        ask_option "Enable Updates & Maintenance?" "ENABLE_UPDATES" "y"

        log_success "Configuration saved."
    else
        log_info "Skipping configuration steps. Using existing motd.conf."
    fi
    draw_line
}