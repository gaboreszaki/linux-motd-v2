#!/bin/bash

configure_motd() {
    local SOURCE_DIR="$1"
    local MOTD_DIR="$2"
    local MOTD_CONF="$SOURCE_DIR/motd.conf"

    ask_option() {
        local prompt="$1"
        local config_var="$2"
        local default="$3"

        # Prepare colored prompt
        local prompt_text
        prompt_text=$(echo -e "${LBLUE}$prompt${NC} ${LBLACK}(y/n/s/t)${NC} [${WHITE}$default${NC}]:")

        while true; do
            read -p "$prompt_text" choice
            case $choice in
                [Yy]* ) echo "$config_var=\"y\"" >> "$MOTD_CONF"; break;;
                [Nn]* ) echo "$config_var=\"n\"" >> "$MOTD_CONF"; break;;
                [Ss]* ) echo "$config_var=\"short\"" >> "$MOTD_CONF"; break;;
                [Tt]* ) echo "$config_var=\"table\"" >> "$MOTD_CONF"; break;;
                "" ) echo "$config_var=\"$default\"" >> "$MOTD_CONF"; break;;
                * ) echo -e "${RED}Please answer yes, no, short, or table.${NC}";;
            esac
        done
    }

    draw_line
    echo -e "${LCYAN}Configuration:${NC}"
    draw_line

    # Try to import config from current installation if local is missing
    if [ ! -f "$MOTD_CONF" ] && [ -f "$MOTD_DIR/motd.conf" ]; then
        cp "$MOTD_DIR/motd.conf" "$MOTD_CONF"
        echo -e "${LGREEN}Imported existing configuration from $MOTD_DIR.${NC}"
    fi

    local DO_CONFIGURE=true
    if [ -f "$MOTD_CONF" ]; then
        local reconf_prompt
        reconf_prompt=$(echo -e "${LYELLOW}Configuration file found. Reconfigure? (y/n) [n]: ${NC}")
        read -p "$reconf_prompt" yn
        case $yn in
            [Yy]* ) DO_CONFIGURE=true ;;
            * ) DO_CONFIGURE=false ;;
        esac
    fi

    if [ "$DO_CONFIGURE" = true ]; then
        # Initialize config file
        mkdir -p "$SOURCE_DIR"
        echo "# Linux MOTD Config" > "$MOTD_CONF"

        ask_option "Enable Header (Logo)?" "ENABLE_HEADER" "y"
        ask_option "Enable System Info?" "ENABLE_SYSINFO" "y"
        ask_option "Enable Disk Usage?" "ENABLE_DISK_USAGE" "y"
        ask_option "Enable Host & Web Services?" "ENABLE_HOST_SERVICES" "y"
        ask_option "Enable User Info?" "ENABLE_USERS" "y"
        ask_option "Enable Fail2Ban Protection?" "ENABLE_FAIL2BAN" "y"
        ask_option "Enable Updates & Maintenance?" "ENABLE_UPDATES" "y"

        echo -e "${GREEN}Configuration saved.${NC}"
    else
        echo -e "${CYAN}Skipping configuration steps. Using existing motd.conf.${NC}"
    fi
    echo -e "${LCYAN}------------------------------------------------${NC}"
}