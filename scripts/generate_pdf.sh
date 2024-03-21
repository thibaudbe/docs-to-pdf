#!/bin/bash

source scripts/logger.sh
source scripts/helper.sh

source scripts/ensure_architecture.sh
source scripts/ensure_dependencies.sh

##############################
# Settings
##############################

folders_array=($(get_folders_array))

##############################
# Helper functions
##############################

# Upgrade packages
upgrade_package() {
  local package_name="$1"
  local old_version=$(get_package_version "$package_name")

  # Check if the package is outdated without performing an update
  if npm outdated "$package_name" --silent | grep -qF "$package_name"; then
    log_info "Package '$package_name' is outdated ($old_version). Updating..."
    if ! npm update "$package_name" --silent; then
      log_error "Failed to update package '$package_name'."
      exit 1
    fi
  else
    log_info "Package '$package_name' is already up to date ($old_version)."
  fi

  local new_version=$(get_package_version "$package_name")

  if [ "$old_version" != "$new_version" ]; then
    return 0  # Versions are different
  else
    return 1  # Versions are the same
  fi
}

# Update projects repository
update_projects() {
  local project_name="$1"
  
  if ! cd "./projects/$project_name" && git pull &>/dev/null; then
    log_warning "Failed to update project '$project_name'. Skipping."
    return
  fi

  cd ../../ || { log_error "Failed to change directory."; exit 1; }
}

# Convert Markdown to PDF
convert_to_pdf() {
  local input_files="$1"
  local output_filename="$2"
  
  # Convert Markdown to PDF
  if ! cat $input_files | npx md-to-pdf > "$output_filename"; then
    log_error "Failed to convert Markdown to PDF for file '$input_files'."
    exit 1
  fi
}

##############################
# Main script
##############################

for project in "${folders_array[@]}"; do
  log_info "Start processing $project..."

  # Check if project folder exists
  if is_project_folder_exists "$project"; then
    log_info "Project folder exists. Proceeding..."
  else
    log_error "Project folder does not exist for project '$project'. Skipping."
    continue
  fi

  # Upgrade package version
  upgrade_package "$project"
  upgrade_result=$?

  # Update project if version is different
  if [ $upgrade_result -eq 0 ]; then
    log_info "Updating project $project..."
    update_projects "$project"
  else
    log_info "No updates available for package $project."
  fi

  # Get all .md files in the path "projects/$project/docs/*"
  md_files=$(find "./projects/$project/docs" -maxdepth 2 -type f -name "*.md")

  # Define output filename
  package_version=$(get_package_version "$project")
  output_filename="pdfs/$project-$package_version.pdf"

  convert_to_pdf "$md_files" "$output_filename"

  log_info "$project processed."
  log_info ""
done

echo "Done."
