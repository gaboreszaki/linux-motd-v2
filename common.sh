# Load text colors
if [ -f "$TEXT_COLORS" ]; then
    # shellcheck source=./text-colors.sh
    . "$TEXT_COLORS"
fi

# --- Interactive Configuration ---
# Load and run configuration
get_config_script(){
  if [ -f "./configure.sh" ]; then
      source ./configure.sh
      configure_motd "$SOURCE_DIR" "$MOTD_DIR"
  else
      echo -e "${RED}Warning: configure.sh not found. Skipping configuration.${NC}"
  fi
}



validate_root_privileges(){
  # Check for root privileges
  if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Please run as root (sudo ./update.sh)${NC}"
    exit 1
  fi
}

display_notes(){
  echo -e "${CYAN}Note:${NC} To add a custom logo file run ${LBLACK}'nano /etc/update-motd.d/logo-custom.txt'${NC} and paste your logo."
  echo -e "${CYAN}Note:${NC} Try logging in to a new terminal session or run ${LBLACK}'run-parts /etc/update-motd.d'${NC} to test.\n"
}

draw_line(){
  echo -e "${LCYAN}------------------------------------------------${NC}"
}