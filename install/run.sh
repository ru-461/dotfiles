#!/usr/bin/env bash

set -euo pipefail

# Resolve repository paths from this script location to avoid depending on PWD.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "${SCRIPT_DIR}/.." && pwd)}"
FUNCTIONS_DIR="${DOTFILES_DIR}/functions"
INSTALL_DIR="${DOTFILES_DIR}/install"

TARGET="auto"
MODE="apply"
ONLY_STEPS=""

usage() {
  cat <<'EOF'
Usage:
  bash install/run.sh [--target auto|mac|linux|wsl|termux] [--mode apply|check] [--only steps]

Options:
  --target   Runtime target. "auto" detects target from current environment.
  --mode     "apply" runs installer, "check" only validates and prints detection.
  --only     Run only selected helper steps (comma-separated): zsh,brew,bundle
  -h, --help Show this help.

Examples:
  bash install/run.sh --mode check
  bash install/run.sh --target auto
  bash install/run.sh --target linux --only zsh,brew
EOF
}

fatal() {
  printf '[ERROR] %s\n' "$1" >&2
  exit 1
}

validate_value() {
  local key="$1"
  local value="$2"

  case "${key}:${value}" in
    target:auto|target:mac|target:linux|target:wsl|target:termux) return 0 ;;
    mode:apply|mode:check) return 0 ;;
    *) return 1 ;;
  esac
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --target)
        [[ $# -ge 2 ]] || fatal "--target requires a value."
        TARGET="$2"
        shift 2
        ;;
      --mode)
        [[ $# -ge 2 ]] || fatal "--mode requires a value."
        MODE="$2"
        shift 2
        ;;
      --only)
        [[ $# -ge 2 ]] || fatal "--only requires a value."
        ONLY_STEPS="$2"
        shift 2
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fatal "Unknown argument: $1"
        ;;
    esac
  done

  validate_value "target" "${TARGET}" || fatal "Invalid target: ${TARGET}"
  validate_value "mode" "${MODE}" || fatal "Invalid mode: ${MODE}"
}

is_docker() {
  [[ -f "/.dockerenv" ]] && return 0
  grep -Eq '(docker|containerd|kubepods)' /proc/1/cgroup 2> /dev/null
}

detect_target() {
  if [[ "${TARGET}" != "auto" ]]; then
    printf '%s\n' "${TARGET}"
    return 0
  fi

  if [[ "${OSTYPE:-}" == "linux-android"* ]] || [[ -n "${TERMUX_VERSION:-}" ]] || [[ -d "/data/data/com.termux/files/usr" ]]; then
    printf '%s\n' "termux"
    return 0
  fi

  if [[ "$(uname -s)" == "Darwin" ]]; then
    printf '%s\n' "mac"
    return 0
  fi

  if [[ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ]] || grep -qi microsoft /proc/version 2> /dev/null; then
    printf '%s\n' "wsl"
    return 0
  fi

  if [[ "$(uname -s)" == "Linux" ]]; then
    printf '%s\n' "linux"
    return 0
  fi

  printf '%s\n' "unknown"
}

load_helpers() {
  local helper
  local helpers=(
    "_common.sh"
    "_zsh.sh"
    "_brew.sh"
    "_bundle_brew.sh"
  )

  for helper in "${helpers[@]}"; do
    [[ -f "${FUNCTIONS_DIR}/${helper}" ]] || fatal "Missing helper: ${FUNCTIONS_DIR}/${helper}"
    # shellcheck source=/dev/null
    source "${FUNCTIONS_DIR}/${helper}"
  done
}

run_selected_steps() {
  local step
  local normalized

  IFS=',' read -r -a steps <<< "${ONLY_STEPS}"
  for step in "${steps[@]}"; do
    normalized="${step//[[:space:]]/}"
    case "${normalized}" in
      zsh) _zsh ;;
      brew) _brew ;;
      bundle) _bundle_brew ;;
      "") ;;
      *)
        error "Unknown step in --only: ${normalized}"
        ;;
    esac
  done
}

run_target_script() {
  local resolved_target="$1"
  local target_script="${INSTALL_DIR}/${resolved_target}.sh"

  [[ -f "${target_script}" ]] || error "Target script not found: ${target_script}"
  # shellcheck source=/dev/null
  source "${target_script}"
}

main() {
  local resolved_target
  local docker_state="no"

  parse_args "$@"
  resolved_target="$(detect_target)"
  [[ "${resolved_target}" != "unknown" ]] || fatal "Could not detect a supported target environment."

  load_helpers
  if is_docker; then
    docker_state="yes"
  fi

  headline "Installer Runner"
  info "DOTFILES_DIR: ${DOTFILES_DIR}"
  info "Target: ${resolved_target} (requested: ${TARGET})"
  info "Running in Docker: ${docker_state}"

  if [[ "${MODE}" == "check" ]]; then
    local target_script="${INSTALL_DIR}/${resolved_target}.sh"
    if [[ -f "${target_script}" ]]; then
      success "Check OK: ${target_script}"
    else
      error "Check failed: ${target_script} was not found."
    fi

    if [[ -n "${ONLY_STEPS}" ]]; then
      info "Check mode: --only '${ONLY_STEPS}'"
    fi
    return 0
  fi

  if [[ -n "${ONLY_STEPS}" ]]; then
    headline "Run Selected Steps"
    run_selected_steps
    success "Selected steps completed."
    return 0
  fi

  headline "Run ${resolved_target} Installer"
  run_target_script "${resolved_target}"
  success "Installer completed."
}

main "$@"
