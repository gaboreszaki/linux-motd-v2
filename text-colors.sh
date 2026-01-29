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


test_colors() {
    printf "${BLACK}BLACK      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${RED}RED        : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${GREEN}GREEN      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${YELLOW}YELLOW     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${BLUE}BLUE       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${PURPLE}PURPLE     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${CYAN}CYAN       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${WHITE}WHITE      : The quick brown fox jumps over the lazy dog${NC}\n"

    printf "${LBLACK}LBLACK     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LRED}LRED       : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LGREEN}LGREEN     : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LYELLOW}LYELLOW    : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LBLUE}LBLUE      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LPURPLE}LPURPLE    : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LCYAN}LCYAN      : The quick brown fox jumps over the lazy dog${NC}\n"
    printf "${LWHITE}LWHITE     : The quick brown fox jumps over the lazy dog${NC}\n"
}

