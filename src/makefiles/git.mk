# -------------------------------------------------------------------
# Git Operations
# -------------------------------------------------------------------
#
# This Makefile provides reusable Git commands for managing
# repositories across multiple projects. It ensures consistency
# across projects while allowing customization where needed.
#
# Project-specific Makefiles can override `GIT_REPO`, `GIT_BRANCH`, and
# `DEFAULT_COMMIT_MESSAGE` as needed.
#
# Supports passing extra CLI arguments to commands via `FLAGS`
#
# Example:
# - `make git_status -u` (Passes `-u` as an argument)
# - `make git_log --oneline --graph`
#
# -------------------------------------------------------------------

# -------------------------------------------------------------------
# 📘 Git Help Commands
# -------------------------------------------------------------------
git_help::  ## Show Git-related Make commands
	@$(call HR,$(HR_WIDTH))
	@echo "📘 Git Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "🔁 git_status          - Show current Git status"
	@echo "📝 git_commit          - Commit changes (interactive)"
	@echo "📤 git_push            - Push committed changes to origin"
	@echo "➕ git_add             - Stage all changes"
	@echo "🔍 git_diff            - Show working tree changes"
	@echo "📜 git_log             - Show commit history"
	@echo "📥 git_pull            - Pull changes from remote"
	@echo "📦 git_clone           - Clone repository (if not exists)"
	@echo "🧩 git_init             - Initialize Git repo (if needed)"
	@echo "🌐 git_remote_get       - Show current remote URL"
	@echo "🔧 git_remote_set       - Prompt to add or update remote origin"
	@echo "🧩 git_setup_remote     - Initialize Git and set remote origin"




# ===================================================================
# Git Safe Makefile (git_safe.mk)
# ===================================================================
#
# This Makefile contains only safe Git operations. These commands
# do not modify history or delete files and are ideal for staging,
# viewing logs, reviewing changes, and pushing commits.
#
# This file should be included in your main Makefile when you want
# safe Git operations that won't affect your working directory.
#
# ===================================================================

.PHONY += git_status git_log git_diff git_diff_cached git_fetch git_check_remote \
          git_validate_clean git_blame git_show git_tag git_br git_hist \
          git_add git_commit git_push git_stash git_stash_pop git_co \
          git_ci git_st git_sync \
          git_init git_remote_get git_remote_set git_setup_remote \
	      git_clone git_checkout git_merge git_rebase git_clean git_gc git_prune \
          git_reset_soft git_reset_hard git_cherry_pick

# Show the status of the working tree
git_status:
	@git -C "$(GIT_REPO)" status $(FLAGS)

# Show the commit history
git_log:
	@git -C "$(GIT_REPO)" log $(FLAGS)

# Show unstaged changes
git_diff:
	@git -C "$(GIT_REPO)" diff $(FLAGS)

# Show staged changes
git_diff_cached:
	@git -C "$(GIT_REPO)" diff --cached $(FLAGS)

# Fetch updates from all remotes
git_fetch:
	@git -C "$(GIT_REPO)" fetch --all $(FLAGS)

# Display configured remotes
git_check_remote:
	@git -C "$(GIT_REPO)" remote -v

# Check if the working tree is clean
git_validate_clean:
	@if [ -n "$$(git -C "$(GIT_REPO)" status --porcelain)" ]; then \\
		echo "Working tree is not clean!"; \\
		exit 1; \\
	else \\
		echo "Working tree is clean."; \\
	fi

# Show who last modified each line of a file
git_blame:
	@git -C "$(GIT_REPO)" blame $(FLAGS)

# Display detailed information about a specific commit
git_show:
	@git -C "$(GIT_REPO)" show $(FLAGS)

# List or create Git tags
git_tag:
	@git -C "$(GIT_REPO)" tag $(FLAGS)

# List all local branches
git_br:
	@git -C "$(GIT_REPO)" branch $(FLAGS)

# View the commit graph
git_hist:
	@git -C "$(GIT_REPO)" log --oneline --graph --decorate --all

# Stage all modified and new files
git_add:
	@git -C "$(GIT_REPO)" add . $(FLAGS)

# -------------------------------------------------------------------
# 📝 Commit with prompt and fallback to default message
# -------------------------------------------------------------------
git_commit: run_sange
	@echo "📦 Running Git commit..."
	@bash $(SANGE_ROOT)/scripts/sange.sh git_commit_prompt "$(GIT_REPO)" "$(DEVLOMATOR_ENV)" $(FLAGS)

# Push committed changes to the configured branch
git_push:
	@git -C "$(GIT_REPO)" push origin "$(GIT_BRANCH)" $(FLAGS)

# -------------------------------------------------------------------
# 🔄 Stage, Commit, and Push Changes (Clean UI + Error Safe)
# -------------------------------------------------------------------
git_sync: run_sange
	@bash $(SANGE_ROOT)/scripts/sange.sh git_sync "$(GIT_REPO)" "$(DEVLOMATOR_ENV)" "$(GIT_BRANCH)" $(FLAGS)

# Temporarily save changes without committing
git_stash:
	@git -C "$(GIT_REPO)" stash $(FLAGS)

# Reapply the last stashed changes
git_stash_pop:
	@git -C "$(GIT_REPO)" stash pop $(FLAGS)

# -------------------------------------------------------------------
# 🧩 Git Initialization
# -------------------------------------------------------------------
git_init: run_sange
	@bash $(SANGE_ROOT)/scripts/sange.sh git_init

# -------------------------------------------------------------------
# 🌐 Show Remote URL
# -------------------------------------------------------------------
git_remote_get:  ## Show current Git remote origin URL
	@bash -c "source $(SANGE_ROOT)/scripts/all/git.sh; get_git_remote_url"

# -------------------------------------------------------------------
# 🔧 Set or Update Remote URL
# -------------------------------------------------------------------
git_remote_set:  ## Prompt to set or update remote origin URL
	@bash -c 'source "$(SANGE_ROOT)/scripts/all/git.sh"; validate_or_set_git_remote'

# -------------------------------------------------------------------
# 🧩 Git Init & Remote Validation
# -------------------------------------------------------------------
git_setup_remote:  ## Ensure Git is initialized and remote is set
	@bash -c "source $(SANGE_ROOT)/scripts/all/git.sh && \
	          check_or_init_git_repo && validate_or_set_git_remote"

# -------------------------------------------------------------------
# 🧪 Validate clean working directory
# -------------------------------------------------------------------
validate_git_clean:  ## Ensure working directory is clean
	@bash -c "source $(SANGE_ROOT)/scripts/all/git.sh; validate_git_clean \"$(GIT_REPO)\""

# -------------------------------------------------------------------
# 👋 git_debug
# -------------------------------------------------------------------
# Simple diagnostic command to verify environment variables and
# inclusion of this support file.
#
# Outputs:
#   - Greeting
#   - Current GIT_REPO path
#   - Active GIT_BRANCH
#   - Supplied FLAGS
# -------------------------------------------------------------------

git_debug:
	@echo "👋 Hello from git.mk!"
	@echo "📁 GIT_REPO: $(GIT_REPO)"
	@echo "🌿 GIT_BRANCH: $(GIT_BRANCH)"
	@echo "🚩 FLAGS: $(FLAGS)"



# ===================================================================
# Git Danger Makefile
# ===================================================================
#
# This Makefile contains high-risk Git commands that may rewrite history,
# delete files, or reset commits. Use with caution, especially in shared
# or production environments.
#
# This file should be included only when you're ready to perform
# destructive Git operations with full awareness.
#
# ===================================================================

# Clone a Git repository to a specified directory
git_clone:
	@if [ ! -d "$(GIT_REPO)" ]; then \\
		git clone <repository_url> "$(GIT_REPO)"; \\
	else \\
		echo "Repository already exists."; \\
	fi

# Switch to a branch or commit
git_checkout:
	@git -C "$(GIT_REPO)" checkout $(FLAGS)

# Merge a branch into the current branch
git_merge:
	@git -C "$(GIT_REPO)" merge $(FLAGS)

# Reapply commits from another branch (can rewrite history)
git_rebase:
	@echo "⚠️  Rebasing can rewrite commit history."
	@git -C "$(GIT_REPO)" rebase $(FLAGS)

# Delete untracked files and folders
git_clean:
	@echo "⚠️  This will delete all untracked files and folders!"
	@git -C "$(GIT_REPO)" clean -fd $(FLAGS)

# Optimize the local repository by cleaning up unnecessary files
git_gc:
	@git -C "$(GIT_REPO)" gc $(FLAGS)

# Remove stale references to deleted branches on remotes
git_prune:
	@git -C "$(GIT_REPO)" remote prune origin $(FLAGS)

# Reset HEAD to a previous commit but keep staged changes
git_reset_soft:
	@echo "⚠️  This will reset commit history but retain staged changes."
	@git -C "$(GIT_REPO)" reset --soft $(FLAGS)

# Completely reset working directory and commit history (DANGER!)
git_reset_hard:
	@echo "🔥 WARNING: This will irreversibly remove all changes."
	@git -C "$(GIT_REPO)" reset --hard $(FLAGS)

# Apply a single commit from another branch or repo
git_cherry_pick:
	@git -C "$(GIT_REPO)" cherry-pick $(FLAGS)






# Aliases for common Git operations
git_co: git_checkout
git_ci: git_commit
git_st: git_status