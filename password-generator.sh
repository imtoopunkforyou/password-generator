#!/usr/bin/env bash
set -Eeuo pipefail

readonly MIN_LENGTH=4
readonly MAX_LENGTH=64
readonly DEFAULT_CHARSET='a-zA-Z0-9!@#$%^&*()_+-=[]{}|;:,.<>?~'

cleanup() {
  :
}

die() {
  local msg="$1"
  local code="${2:-1}"
  [[ -t 2 ]] && echo -e "\033[1;31m${msg}\033[0m" || echo "$msg"
  cleanup
  exit "$code"
}

validate_input() {
  local length="$1"
  [[ "$length" -ge "$MIN_LENGTH" ]] && [[ "$length" -le "$MAX_LENGTH" ]] ||
    die "Invalid length: ${length}. Allowed range: ${MIN_LENGTH}-${MAX_LENGTH}" 2
}

generate_password() {
  local length="$1"
  local charset="${2:-$DEFAULT_CHARSET}"
  local password

  if ! command -v openssl &>/dev/null; then
    password=$(LC_ALL=C tr -dc "$charset" < /dev/urandom | dd bs=1 count="$length" 2>/dev/null)
  else
    password=$(openssl rand -base64 48 | tr -dc "$charset" | head -c "$length")
  fi
  
  [[ "${#password}" -eq "$length" ]] || die "Password generation failed" 3
  echo "$password"
}

main() {
  local PASSWORD_LENGTH
  local CHARSET=""

  while (($# > 0)); do
    case "$1" in
      -l|--length)
        shift
        PASSWORD_LENGTH="$1"
        ;;
      -c|--charset)
        shift
        CHARSET="$1"
        ;;
      -h|--help)
        echo "Usage: $0 --length <num> [--charset <pattern>]"
        exit 0
        ;;
      *) die "Unknown option: $1" 4 ;;
    esac
    shift
  done

  : "${PASSWORD_LENGTH:=12}"

  validate_input "$PASSWORD_LENGTH"
  generate_password "$PASSWORD_LENGTH" "$CHARSET"
}

trap 'cleanup' EXIT
main "$@"