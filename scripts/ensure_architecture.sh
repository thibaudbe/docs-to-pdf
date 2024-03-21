#!/bin/bash

source scripts/logger.sh
source scripts/helper.sh

# Ensure output folder exists or create it
mkdir -p "pdfs" || { log_error "Failed to create output folder 'pdfs'."; exit 1; }

# Function to check if the "projects" folder exists
check_projects_folder() { 
  local projects_folder="./projects"

  # Ensure output folder exists or create it
  mkdir -p "projects" || { log_error "Failed to create output folder 'projects'."; exit 1; }

  if [ -n "$(find "$projects_folder" -mindepth 1 -maxdepth 1)" ]; then
    log_info "Projects detected in 'projects' folder."
  else
    log_error "The 'projects' folder is empty."
    exit 1
  fi
}

# Check if the "projects" folder exists
check_projects_folder

# Compare dependencies with folder names
compare_dependencies_with_folders() {
  local dependencies=$(get_dependencies)
  local folders=$(get_folders)

  # Loop through each dependency
  for dep in $dependencies; do
    # Check if a folder with the dependency name exists
    if is_project_folder_exists "$dep"; then
      log_info "Folder name '$dep' matches a dependency name in package.json file."
    else
      log_error "Folder name '$folder' does not have a corresponding dependency."
      exit 1
    fi
  done

  # Loop through each project folders
  for folder in $folders; do
    # Check if a folder with the dependency name exists
    if is_dependency_exists "$folder"; then
      log_info "Dependency name '$folder' exists in './projects' folder."
    else
      log_error "Dependency name '$folder' not found in folders."
      exit 1
    fi
  done
}

compare_dependencies_with_folders
