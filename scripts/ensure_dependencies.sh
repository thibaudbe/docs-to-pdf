#!/bin/bash

source scripts/logger.sh

# Check if Git is installed
if ! command -v git &> /dev/null; then
  log_error "Git is not installed. Please install Git to continue."
  exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
  log_error "npm is not installed. Please install npm to continue."
  exit 1
fi
