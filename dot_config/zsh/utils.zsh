function log() {
  local log_level=$1
  local msg=$2
  local color
  case $log_level in
    "info") color=32 ;;
    "warn") color=33 ;;
    "error") color=31 ;;
    *) color=0 ;;
  esac
  echo -e "\033[${color}m${log_level}:\033[0m ${msg}"
}

function log_info() {
  log "info" "$1"
}

function log_warn() {
  log "warn" "$1"
}

function log_error() {
  log "error" "$1"
}

