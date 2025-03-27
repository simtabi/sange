# ===================================================================
# Git Master Config (git_config.mk)
# ===================================================================
#
# This file holds shared Git-related configuration variables.
# It should be included at the top of all Git Makefiles to ensure
# consistency and to follow the DRY (Don't Repeat Yourself) principle.
#
# ===================================================================

# Path to the Git repository (defaults to current directory)
GIT_REPO ?= .

# The default branch to use for push/pull operations
GIT_DEFAULT_BRANCH ?= main

# -------------------------------------------------------------------
# 📜 Default Commit Message Options
# -------------------------------------------------------------------
#
# Reusable, human-friendly, and automation-safe commit messages
# for use in Sange-powered projects or any CI/CD workflow.
#
# 💡 These are used when the user skips entering a message.
#    Ideal for bots, tools, and maintaining consistent commit history.
#
# 🧰 Common Defaults:
#   🔧 chore: automated update
#       Generic and safe — ideal for most CI/CD and bot tasks.
#
#   📦 task: routine update
#       Structured and intentional — fits weekly jobs, cleanup, etc.
#
#   🤖 bot: update via Sange
#       Tool-branded — good for tracking Sange/scripting actions.
#
#   ⚙️ ci: auto-generated changes
#       CI-friendly — clearly marks automated changes.
#
#   🛠️ refactor: scripted improvements
#       Indicates changes were automated for structure or style.
#
#   🧠 system: auto-sync complete
#       Clean, enterprise-safe — good for server/system-level updates.
#
# 🚀 Release Scenarios:
#   🚀 release: initial deployment
#       First commits, semver tagging, first stable release.
#
#   🧨 release: initial (WIP)
#       Like above, but for preview/beta/testing releases.
#
# 🗃 Maintenance + Ops:
#   🗃️ meta: update project metadata
#       README, LICENSE, package.json, composer.json, etc.
#
#   📝 docs: auto-generated update
#       Doc tools (Swagger, Sphinx, typedoc, etc.).
#
#   🧼 style: formatting cleanup
#       Prettier, lint-fix, whitespace, markdown fixes.
#
#   🔁 sync: align with main branch
#       GitOps, monorepo syncs, auto-merge workflows.
#
#   ⬆️ build: upgrade dependencies
#   ⬇️ build: downgrade dependencies
#       Composer, NPM, Yarn, Pip, etc.
#
#   🗑️ chore: cleanup unused files
#       Stale files, removed stubs, old logs or cache.
#
#   🛎️ ops: scheduled maintenance update
#       Cron jobs, server upkeep, infrastructure refreshes.
#
#   🚧 wip: in-progress automation
#       Temporary message during rollouts, dry runs, test commits.
#
# ✅ Recommended Default:
#   DEFAULT_COMMIT_MESSAGE ?= 🔧 chore: automated update
#
# -------------------------------------------------------------------
DEFAULT_COMMIT_MESSAGE ?= 🔧 chore: automated update

# Optional additional flags to pass to Git commands
FLAGS ?=

