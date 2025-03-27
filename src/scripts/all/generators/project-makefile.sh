#!/bin/bash

# ===================================================================
# 🧩 Script: generate-project-makefile.sh
# ===================================================================
#
# Prompts the user for a package name and destination directory,
# validates input, and generates a Makefile using a shared template.
# Designed for use within Sange-based monorepos.
#
# USAGE (via Make or CLI):
#   bash generate-project-makefile.sh
#
# This script:
#   - Prevents overwriting existing Makefiles
#   - Dynamically detects Sange root
#   - Uses sed to inject the package name into the template
#
# ===================================================================
#

# -------------------------------------------------------------------
# 📘 Help: Show usage info when --help is passed
# -------------------------------------------------------------------
if [[ "$1" == "--help" ]]; then
  echo "🧩 generate-project-makefile.sh"
  echo "Prompts the user to enter a package name and destination directory"
  echo "Then generates a project-level Makefile using the sange template."
  echo ""
  echo "USAGE:"
  echo "  bash generate-project-makefile.sh"
  exit 0
fi

# -------------------------------------------------------------------
# 🧩 Function: generate_project_makefile
# -------------------------------------------------------------------
generate_project_makefile() {
  echo "📦 Enter the package name (e.g. api, frontend, users): "
  read package_name
  if [[ -z "$package_name" ]]; then
    echo "❌ Package name is required."
    return 1
  fi

  echo "📂 Enter the destination directory path (e.g. ./packages/api): "
  read dest_dir
  if [[ -z "$dest_dir" ]]; then
    echo "❌ Destination directory path is required."
    return 1
  fi

    local output_file="$dest_dir/Makefile"
    if [[ -f "$output_file" ]]; then
      echo "⚠️  A Makefile already exists at '$output_file'."
      read -p "Do you want to overwrite it? (y/N): " confirm
      confirm="${confirm:-n}"

      if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "🚫 No changes made. Existing Makefile preserved."
        return 0
      else
        echo "✅ Overwriting existing Makefile..."
      fi
    fi

  # 📁 Resolve Sange root path
  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  local sange_root="$script_dir/../../../.."
  local template_path="$sange_root/templates/makefile.template"

  if [[ ! -f "$template_path" ]]; then
    echo "❌ Template not found at: $template_path"
    return 1
  fi

  mkdir -p "$dest_dir"
  sed "s/{{PACKAGE_NAME}}/$package_name/g" "$template_path" > "$dest_dir/Makefile"
  echo "✅ Makefile created in $dest_dir for package '$package_name'"
}

# -------------------------------------------------------------------
# 🚀 Run the generator if the script is executed directly
# -------------------------------------------------------------------
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  generate_project_makefile
fi
