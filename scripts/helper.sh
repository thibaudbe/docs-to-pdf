#!/bin/bash

# Check if a folder exists
is_folder_exists() {
  local folder="./$1"
  [ -d "$folder" ]
}

# Check if a folder exists in "./projects"
is_project_folder_exists() {
  is_folder_exists "./projects/$1"
}

# Check if a dependency exists in package.json
is_dependency_exists() {
  local dependency_name="$1"
  local package_json="./package.json"
  local dependencies=$(jq -r '.devDependencies | keys_unsorted | .[]' "$package_json")
  
  for dependency in $dependencies; do
    if [ "$dependency" = "$dependency_name" ]; then
      return 0  # Dependency exists
    fi
  done
  
  return 1  # Dependency does not exist
}

# Function to extract dependencies from package.json
get_dependencies() {
  local package_json="./package.json"  # Update with the path to your package.json
  local dependencies=$(jq -r '.devDependencies | keys_unsorted | .[]' "$package_json")
  echo "$dependencies"
}

# Get list of folder names in a directory
get_folders() {
  local directory="./projects"  # Update with the path to your directory
  local folders=$(find "$directory" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
  echo "$folders"
}

get_folders_array() {
  local directory="./projects"
  local folders=()
  while IFS= read -r -d '' folder; do
    folders+=("$(basename "$folder")")
  done < <(find "$directory" -mindepth 1 -maxdepth 1 -type d -print0)
  echo "${folders[@]}"
}

# Get package version from package name
get_package_version() {
  local package_name="$1"

  if ! version=$(npm view "$package_name" version 2>/dev/null); then
    log_error "Failed to get version for package '$package_name'."
    exit 1
  fi
  
  echo "$version"
}