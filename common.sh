# Color codes
NC='\033[0m' # No Color

# Regular Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'

# Bold/Light Colors
LBLACK='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LPURPLE='\033[1;35m'
LCYAN='\033[1;36m'
LWHITE='\033[1;37m'

# Background
BG_BLACK='\033[40m'
BG_RED='\033[41m'
BG_GREEN='\033[42m'
BG_YELLOW='\033[43m'
BG_BLUE='\033[44m'
BG_PURPLE='\033[45m'
BG_CYAN='\033[46m'
BG_WHITE='\033[47m'


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
  echo -e "${CYAN}Note:${NC} To add a custom logo file run ${YELLOW}'nano /etc/update-motd.d/logo-custom.txt'${NC} and paste your logo."
  echo -e "${CYAN}Note:${NC} Try logging in to a new terminal session or run ${YELLOW}'run-parts /etc/update-motd.d'${NC} to test."
}

draw_line(){
  echo -e "${LCYAN}------------------------------------------------${NC}"
}

test_colors() {
    printf "\n normal colors: \n";
    printf "${BLACK}BLACK      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${RED}RED        : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${GREEN}GREEN      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${YELLOW}YELLOW     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BLUE}BLUE       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${PURPLE}PURPLE     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${CYAN}CYAN       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${WHITE}WHITE      : The quick brown fox jumps over the lazy dog${NC}\n"

    printf "\n light colors: \n";
    printf "${LBLACK}LBLACK     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LRED}LRED       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LGREEN}LGREEN     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LYELLOW}LYELLOW    : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LBLUE}LBLUE      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LPURPLE}LPURPLE    : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LCYAN}LCYAN      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LWHITE}LWHITE     : The quick brown fox jumps over the lazy dog${NC}\n"

    printf "\n Backgrounds: \n";
    printf "${BG_BLACK}BG_BLACK     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_RED}BG_RED       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_GREEN}BG_GREEN     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_YELLOW}BG_YELLOW    : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_BLUE}BG_BLUE      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_PURPLE}BG_PURPLE    : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_CYAN}BG_CYAN      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BG_WHITE}BG_WHITE     : The quick brown fox jumps over the lazy dog${NC}\n"

}