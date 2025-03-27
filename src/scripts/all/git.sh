#!/bin/bash

# ===================================================================
# 🧩 Script: git.sh
# ===================================================================
#
# Git helper functions used in Sange workflows.
# This script is meant to be sourced and exposes reusable Git logic.
#
# USAGE:
#   source git.sh
#   git_commit_prompt "<default-message>" "<git-repo>" [flags...]
#
#   OR if executed directly:
#   ./git.sh --help
#
# ===================================================================

# -------------------------------------------------------------------
# 📘 CLI Help
# -------------------------------------------------------------------
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo ""
  echo "🧩 git.sh — Git Automation Helpers"
  echo ""
  echo "Available Functions:"
  echo "  git_commit_prompt <default-msg> <git-repo> [flags...]"
  echo "    → Prompts for a commit message and commits staged changes"
  echo ""
  echo "USAGE EXAMPLE:"
  echo "  source git.sh"
  echo "  git_commit_prompt \"My default message\" ./packages/api"
  echo ""
  exit 0
fi

# -------------------------------------------------------------------
# 📝 Function: git_commit_prompt
# -------------------------------------------------------------------
# Prompt for commit message (typed or from a menu).
# Handles CI/CD mode and local dev differently:
# - Local: fail hard if no valid message
# - CI: auto-commit with default and continue
#
# Parameters:
#   $1 → Git repo path
#   $2 → Mode: "local" or "ci"
#   $@ → Additional flags passed to `git commit`
# -------------------------------------------------------------------
git_commit_prompt() {
  local git_repo="$1"
  local env_mode="$2"
  shift 2

  if [[ -z "$git_repo" || ! -d "$git_repo/.git" ]]; then
    echo "❌ [Error] Invalid Git repository: '$git_repo'"
    return 1
  fi

  if [[ -z "$(git -C "$git_repo" diff --cached --name-only)" ]]; then
    echo "🟡 [Info] No staged changes to commit."
    return 0
  fi

  local default_messages=(
    "🔧 chore: automated update"
    "📦 task: routine update"
    "🤖 bot: update via Sange"
    "⚙️ ci: auto-generated changes"
    "🛠️ refactor: scripted improvements"
    "🧠 system: auto-sync complete"
    "🚀 release: initial deployment"
    "🧨 release: initial (WIP)"
    "🗃️ meta: update project metadata"
    "📝 docs: auto-generated update"
    "🧼 style: formatting cleanup"
    "🔁 sync: align with main branch"
    "⬆️ build: upgrade dependencies"
    "⬇️ build: downgrade dependencies"
    "🗑️ chore: cleanup unused files"
    "🛎️ ops: scheduled maintenance update"
    "🚧 wip: in-progress automation"
  )

  echo "🌐 Running in mode: ${env_mode}"

  # ────────────────────────────────────────────────────────────────
  # CI/CD MODE (auto commit with default message)
  if [[ "$env_mode" == "ci" ]]; then
    echo "🤖 [CI] No prompt. Using fallback commit message: '${default_messages[0]}'"
    git -C "$git_repo" commit -m "${default_messages[0]}" "$@"
    return $?
  fi

  # ────────────────────────────────────────────────────────────────
  # LOCAL MODE (prompt or fail with context)
  echo ""
  echo "📝 Enter a custom commit message"
  echo "    (or press Enter to choose from a list of default options):"
  read -r user_msg
  user_msg="$(echo "$user_msg" | xargs)" # trim whitespace

  if [[ -z "$user_msg" ]]; then
    echo ""
    echo "📋 Choose a default commit message:"
    for i in "${!default_messages[@]}"; do
      printf "  %2d) %s\n" "$((i + 1))" "${default_messages[$i]}"
    done
    echo ""
    read -p "Select a number [1-${#default_messages[@]}]: " selection

    if [[ -z "$selection" || ! "$selection" =~ ^[0-9]+$ || "$selection" -lt 1 || "$selection" -gt ${#default_messages[@]} ]]; then
      echo "❌ [Error] Invalid or no selection made."
      echo "💡 Hint: Enter a number between 1 and ${#default_messages[@]} or type a custom message."
      echo "🚫 Commit aborted."
      return 1
    fi

    user_msg="${default_messages[$((selection - 1))]}"
  fi

  if [[ -z "$user_msg" ]]; then
    echo "❌ [Error] No valid commit message provided."
    echo "🚫 Commit aborted."
    return 1
  fi

  echo "✅ Committing with message: $user_msg"
  git -C "$git_repo" commit -m "$user_msg" "$@"
}

# -------------------------------------------------------------------
# 🔄 Function: git_sync
# -------------------------------------------------------------------
# Stages, commits (with prompt), and pushes changes.
# Handles local vs. CI gracefully. Final errors handled inside.
#
# Parameters:
#   $1 → Git repo path
#   $2 → Environment: local | ci
#   $3 → Git branch to push to
#   $@ → Additional git flags (optional)
# -------------------------------------------------------------------
git_sync() {
  local repo="$1"
  local env_mode="$2"
  local branch="$3"
  shift 3
  local flags=("$@")

  local mode_label
  mode_label=$(echo "$env_mode" | tr '[:lower:]' '[:upper:]')

  echo ""
  echo "🔄────────────────────────────────────────────"
  echo "🔃 Git Sync: add → commit → push"
  echo "🌐 Environment: $mode_label"
  echo "📁 Repository: $repo"
  echo "──────────────────────────────────────────────"

  # 1. Stage all changes
  echo "➕ [1/3] Staging all changes..."
  if ! git -C "$repo" add . "${flags[@]}"; then
    echo "❌ Failed to stage changes."
    [[ "$env_mode" == "local" ]] && {
      echo "🛑 Git sync failed. Check the logs above for details."
      return 1
    }
    return 0
  fi

  # 2. Commit
  echo "📝 [2/3] Running commit prompt..."
  if ! git_commit_prompt "$repo" "$env_mode" "${flags[@]}"; then
    echo "❌ Commit step failed."
    [[ "$env_mode" == "local" ]] && {
      echo "🛑 Git sync failed. Check the logs above for details."
      return 1
    }
    return 0
  fi

  # 3. Push
  echo "📤 [3/3] Pushing to origin/$branch..."
  if ! git -C "$repo" push origin "$branch" "${flags[@]}"; then
    echo "❌ Push failed. Check your branch or remote."
    [[ "$env_mode" == "local" ]] && {
      echo "🛑 Git sync failed. Check the logs above for details."
      return 1
    }
    return 0
  fi

  echo ""
  echo "✅ Git Sync Complete!"
  echo "──────────────────────────────────────────────"
}

# -------------------------------------------------------------------
# 📁 Function: git_init
# -------------------------------------------------------------------
# Initializes Git repo if needed.
# Prompts user to configure user.name and user.email.
# Prompts to add or update remote URL.
# Fully interactive and clean UX.
# -------------------------------------------------------------------
git_init() {
  echo ""
  echo "🧩 Git Initialization"
  echo "──────────────────────────────────────────────"

  if [ -d ".git" ]; then
    echo "✅ Git repository already initialized."
  else
    echo "❓ This directory is not a Git repository."
    read -p "Do you want to initialize it now? (y/N): " confirm
    confirm="${confirm:-n}"
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      if git init; then
        echo "✅ Git repository initialized."
      else
        echo "🛑 Git init failed. Check permissions or path."
        return 1
      fi
    else
      echo "🚫 Initialization cancelled by user."
      return 1
    fi
  fi

  echo ""
  echo "👤 Git User Configuration"
  echo "──────────────────────────────────────────────"

  local current_name current_email
  current_name=$(git config --global user.name 2>/dev/null || echo "Not set")
  current_email=$(git config --global user.email 2>/dev/null || echo "Not set")

  echo "🧾 Current global Git config:"
  echo "   • user.name  : $current_name"
  echo "   • user.email : $current_email"
  echo ""

  read -p "Would you like to update these values? (y/N): " update_user
  update_user="${update_user:-n}"

  if [[ "$update_user" =~ ^[Yy]$ ]]; then
    echo ""
    read -p "Enter user.name  [default: $current_name]: " new_name
    read -p "Enter user.email [default: $current_email]: " new_email

    new_name="${new_name:-$current_name}"
    new_email="${new_email:-$current_email}"

    echo ""
    read -p "Apply settings globally or locally? (global/local) [default: global]: " scope
    scope="${scope:-global}"

    if [[ "$scope" != "global" && "$scope" != "local" ]]; then
      echo "⚠️  Invalid scope. Defaulting to global."
      scope="global"
    fi

    git config --$scope user.name "$new_name"
    git config --$scope user.email "$new_email"

    echo ""
    echo "✅ Git user info updated ($scope):"
    echo "   • user.name  : $new_name"
    echo "   • user.email : $new_email"
  else
    echo "ℹ️  Keeping existing Git user configuration."
  fi

  echo ""
  echo "🌐 Git Remote Configuration"
  echo "──────────────────────────────────────────────"
  validate_or_set_git_remote

  echo ""
  echo "🎉 Git setup complete!"
  echo "──────────────────────────────────────────────"
}

# -------------------------------------------------------------------
# 🔍 Function: get_git_remote_url
# -------------------------------------------------------------------
# Prints the current Git origin remote URL (with message),
# and returns it via stdout for scripting use.
# -------------------------------------------------------------------
get_git_remote_url() {
  local url
  url=$(git remote get-url origin 2>/dev/null)

  if [[ -n "$url" ]]; then
    echo "🔗 Current Git Remote URL:"
    echo "$url"
  else
    echo "⚠️  No remote URL set for 'origin'."
    return 1
  fi
}

# -------------------------------------------------------------------
# 🔧 Function: set_git_remote_url
# -------------------------------------------------------------------
# Adds or updates the 'origin' remote URL with polished UX.
# Detects if origin exists, prompts accordingly, and provides
# clean, clear, emoji-rich messages.
# -------------------------------------------------------------------
set_git_remote_url() {
  local current_url="$1"

  echo ""
  echo "🌐 Remote Configuration"
  echo "──────────────────────────────────────────────"

  # 🚀 Remote exists: prompt to update
  if [[ -n "$current_url" ]]; then
    echo "🔗 Current origin remote:"
    echo "   $current_url"
    echo ""
    read -p "Would you like to update the origin remote? (y/N): " confirm_update
    confirm_update="${confirm_update:-n}"

    if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
      read -p "Enter new remote URL: " new_url
      if [[ -z "$new_url" ]]; then
        echo "❌ No URL provided. Update aborted."
        return 1
      fi

      if git remote get-url origin &>/dev/null; then
        git remote set-url origin "$new_url"
        echo "🔄 Successfully updated 'origin' to:"
      else
        git remote add origin "$new_url"
        echo "✅ 'origin' remote was missing, so it was added:"
      fi
      echo "   $new_url"
    else
      echo "✅ Keeping existing origin remote."
    fi

  # ❌ No remote set: prompt to add
  else
    echo "⚠️  No remote URL set for 'origin'."
    read -p "Would you like to add one now? (y/N): " confirm_add
    confirm_add="${confirm_add:-n}"

    if [[ "$confirm_add" =~ ^[Yy]$ ]]; then
      read -p "Enter remote URL to add: " new_url
      if [[ -z "$new_url" ]]; then
        echo "❌ No URL provided. Remote not added."
        return 1
      fi
      git remote add origin "$new_url"
      echo "✅ Added 'origin' remote:"
      echo "   $new_url"
    else
      echo "ℹ️  Skipping remote setup for now."
    fi
  fi

  # ✅ Confirm final remote
  echo ""
  local final_url
  final_url=$(git remote get-url origin 2>/dev/null || echo "Not set")
  echo "🔍 Final 'origin' remote:"
  echo "   $final_url"
  echo "──────────────────────────────────────────────"
}

# -------------------------------------------------------------------
# 🔗 Function: validate_or_set_git_remote
# -------------------------------------------------------------------
# Verifies current repo and configures Git remote.
# -------------------------------------------------------------------
validate_or_set_git_remote() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$git_root" ]]; then
    echo "❌ This is not a valid Git repository."
    return 1
  fi

  echo "📁 Git repository root: $git_root"

  local current_remote
  current_remote=$(get_git_remote_url)

  set_git_remote_url "$current_remote"
}

# -------------------------------------------------------------------
# 🧪 Function: validate_git_clean
# -------------------------------------------------------------------
# Validates that the working directory is clean (no uncommitted changes).
# Defaults to the current directory if no path is passed.
#
# Usage:
#   validate_git_clean                   # Uses current dir (Checks $(GIT_REPO))
#   validate_git_clean GIT_REPO="."      # Force current dir
#   validate_git_clean GIT_REPO="../api" # Check a sibling package
#   validate_git_clean /path/to/repo
# -------------------------------------------------------------------
validate_git_clean() {
  local repo_path="${1:-.}"

  if [[ -n "$(git -C "$repo_path" status --porcelain 2>/dev/null)" ]]; then
    echo "❌ Working directory not clean at: $repo_path"
    return 1
  else
    echo "✅ Working directory is clean at: $repo_path"
    return 0
  fi
}

