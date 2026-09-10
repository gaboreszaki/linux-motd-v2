# Load colors from helper
if [[ -f "./motd-files/helper.sh" ]]; then
    # shellcheck source=./motd-files/helper.sh
    source ./motd-files/helper.sh
elif [[ -f "/etc/update-motd.d/helper.sh" ]]; then
    # shellcheck source=/etc/update-motd.d/helper.sh
    source /etc/update-motd.d/helper.sh
fi

# Logging helpers
log_info()    { printf "${LGREEN}[INFO]${NC} %b\n" "$*" >&2; }
log_warn()    { printf "${LYELLOW}[WARN]${NC} %b\n" "$*" >&2; }
log_error()   { printf "${RED}[ERROR]${NC} %b\n" "$*" >&2; }
log_success() { printf "${GREEN}[SUCCESS]${NC} %b\n" "$*" >&2; }

draw_line() {
    printf "${LCYAN}------------------------------------------------${NC}\n"
}

validate_root_privileges() {
    if [[ "$EUID" -ne 0 ]]; then
        log_error "Please run as root (use sudo)"
        exit 1
    fi
}

check_dependencies() {
    local deps=("$@")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            log_error "Required dependency '$dep' is not installed."
            exit 1
        fi
    done
}

get_config_script() {
    if [[ -f "./configure.sh" ]]; then
        # shellcheck source=./configure.sh
        source ./configure.sh
        configure_motd "$SOURCE_DIR" "$MOTD_DIR"
    else
        log_warn "configure.sh not found. Skipping configuration."
    fi
}

display_notes() {
    log_info "To add a custom logo: ${LYELLOW}nano /etc/update-motd.d/logo-custom.txt${NC}"
    log_info "To test, log in again or run: ${LYELLOW}run-parts /etc/update-motd.d${NC}"
}