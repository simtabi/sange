# ===================================================================
# 🛠️ Sange Master Makefile (sange.mk)
# ===================================================================
#
# This Makefile serves as the central integration point for the Sange
# automation toolkit — bundling reusable workflows across Git, Docker,
# NPM/Yarn, Laravel, and other developer operations into a unified interface.
#
# It is designed to be included from project-specific Makefiles to reduce
# duplication and enforce consistency across repositories.
#
# ✅ Usage (inside a project-level Makefile):
# --------------------------------------------------
# include path/to/sange.mk
# --------------------------------------------------
#
# 🧩 Project-level overrides (optional):
# Define these before including this file to override behavior:
#   - GIT_REPO
#   - GIT_BRANCH
#   - DEFAULT_COMMIT_MESSAGE
#
# 📂 Structure Overview:
#   └── src/
#       ├── configs/     → Project-wide configuration defaults
#       │   └── config.mk
#       ├── stacks/      → All supported task stacks (git.mk, docker.mk, etc.)
#       ├── support/     → Helpers, utilities, shared logic or meta makefiles
#       └── scripts/     → Bash scripts or script-based automations
#
# 🧱 Modular & Extensible:
# Easily extend by adding new stack or support files under `src/`.
#
# -------------------------------------------------------------------
# 👤 Author:        Imani Manyara <imani@simtabi.com>
# 🪪 License:       MIT License
# 🏷️ Project:       Sange – Modern Developer Automation Stack
# 🔗 Repository:    https://github.com/simtabi/sange
# 🗓️ Last Updated:  2025-03-23
# ===================================================================

.PHONY:

# -------------------------------------------------------------------
# 🔁 Base Path for Includes
# -------------------------------------------------------------------
SANGE_ROOT := $(dir $(lastword $(MAKEFILE_LIST)))

# -------------------------------------------------------------------
# 📖 Aggregated Help from All Stacks
# -------------------------------------------------------------------
help:  ## Show all available Sange commands from loaded stacks
	@echo ""
	@$(call HR,$(HR_WIDTH))
	@echo "🧩 Sange Help — Aggregated Commands"
	@$(call HR,$(HR_WIDTH))
	@$(MAKE) -s docker_help
	@$(MAKE) -s git_help
	@$(MAKE) -s laravel_help
	@$(MAKE) -s npm_help
	@$(MAKE) -s generators_help
	@$(MAKE) -s initializers_help
	@$(MAKE) -s support_help
	@$(call HR,$(HR_WIDTH))
	@echo "📂 Project Root: $(SANGE_ROOT)"
	@$(call HR,$(HR_WIDTH))
	@echo ""

# -------------------------------------------------------------------
# 🧩 Project-Wide Configuration
# -------------------------------------------------------------------
include $(SANGE_ROOT)configs/config.mk

# -------------------------------------------------------------------
# 🧰 Support Logic (shared helpers, validations, etc.)
# -------------------------------------------------------------------
include $(SANGE_ROOT)makefiles/supports/support.mk

# -------------------------------------------------------------------
# 🧬 Git Stack (Safe, Danger, Config)
# -------------------------------------------------------------------
include $(SANGE_ROOT)makefiles/git.mk

# -------------------------------------------------------------------
# 🐳 Docker Stack
# -------------------------------------------------------------------
include $(SANGE_ROOT)makefiles/docker.mk

# -------------------------------------------------------------------
# 📦 NPM/Yarn Stack
# -------------------------------------------------------------------
include $(SANGE_ROOT)makefiles/npm.mk

# -------------------------------------------------------------------
# ⚙️ Laravel Artisan Stack
# -------------------------------------------------------------------
include $(SANGE_ROOT)makefiles/laravel.mk