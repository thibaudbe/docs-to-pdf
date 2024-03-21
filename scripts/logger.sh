#!/bin/bash

# Log message with INFO level
log_info() {
  if [ "$VERBOSE" = true ]; then
    echo "[INFO] $1"
  fi
}

# Log message with WARNING level
log_warning() {
  echo "[WARNING] $1"
}

# Log message with ERROR level
log_error() {
  echo "[ERROR] $1" >&2
}
