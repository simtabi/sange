#!/bin/bash

# ===================================================================
# 🚀 Sange Master Script (sange.sh)
# ===================================================================
#
# Entrypoint for Sange CLI tooling and scripted workflows.
# Sources stack-specific scripts like `git.sh` and `project-makefile.sh`
# to expose reusable helper functions across the monorepo.
#
# USAGE:
#   ./sange.sh <command>
#
# Try:
#   ./sange.sh --help
#
# ===================================================================

# -------------------------------------------------------------------
# 🧩 Bootstrap: Resolve Paths and Load Subcommand Scripts
# -------------------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source stack-specific commands
source "$SCRIPT_DIR/all/git.sh"
source "$SCRIPT_DIR/all/generators/project-makefile.sh"

# -------------------------------------------------------------------
# 📘 Sange CLI Help
# -------------------------------------------------------------------
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo ""
  echo "🧩 Sange CLI — Usage"
  echo "Usage: ./sange.sh <command>"
  echo ""
  echo "Available Commands:"
  echo "  git_commit_prompt           Prompt for Git commit message"
  echo "  generate_project_makefile   Prompt and generate project Makefile"
  echo ""
  echo "Examples:"
  echo "  ./sange.sh git_commit_prompt"
  echo "  ./sange.sh generate_project_makefile"
  echo ""
  exit 0
fi

# -------------------------------------------------------------------
# 🧩 CLI Routing
# -------------------------------------------------------------------
case "$1" in
  git_commit_prompt)
    shift
    git_commit_prompt "$@"
    ;;
  generate_project_makefile)
    shift
    generate_project_makefile "$@"
    ;;
    git_sync)
      shift
      git_sync "$@"
      ;;
      git_init)
        shift
        git_init "$@"
        ;;
  *)
    echo "❌ Unknown command: $1"
    echo "Use '--help' to see available subcommands."
    exit 1
    ;;
esac
