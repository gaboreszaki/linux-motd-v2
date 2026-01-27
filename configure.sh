#!/bin/bash

configure_motd() {
    local SOURCE_DIR="$1"
    local MOTD_DIR="$2"
    local MOTD_CONF="$SOURCE_DIR/motd.conf"

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

    local DO_CONFIGURE=true
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
}