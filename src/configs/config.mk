# ===================================================================
# 🧩 Project-Wide Configuration
# ===================================================================
# 👤 Author:        Imani Manyara <imani@sange.io>
# 🪪 License:       MIT License
# 🏷️ Project:       Sange – Modern Developer Automation Stack
# 🔗 Repository:    https://github.com/your-org/sange
# 🗓️ Last Updated:  2025-03-23
# ===================================================================
# Loads global settings and defaults that apply across all stacks,
# tools, and commands within the Sange ecosystem.
#
# These values are intended to be reused across Git, Docker, NPM/Yarn,
# Laravel, or any future stack integration — keeping your setup DRY.
#
# 🔁 Examples of values typically defined here:
#   - PROJECT_NAME
#   - DEFAULT_COMMIT_MESSAGE
#   - DOCKER_IMAGE
#   - GLOBAL_FLAGS
#
# ===================================================================


# -------------------------------------------------------------------
# 📏 Macro: HR (Horizontal Rule)
# -------------------------------------------------------------------
# Dynamically prints a horizontal line using `=` to span X% of the
# terminal width.
#
# Usage:
#   - Define HR_WIDTH := 90 (or any %)
#   - Call it like: $(call HR,$(HR_WIDTH))
#
# Example:
#   HR_WIDTH := 50
#   @$(call HR,$(HR_WIDTH))
#
# -------------------------------------------------------------------

HR_WIDTH := 65 # Prints HR_WIDTH% of terminal width
HR = printf '%*s\n' "$$(($$(tput cols) * $(1) / 100))" '' | tr ' ' '='

# -------------------------------------------------------------------
# 🌐 Global Sange Environment Mode
# -------------------------------------------------------------------
# Controls behavior of certain scripts and commands
# Set to: local | ci
# -------------------------------------------------------------------

SANGE_ENV ?= local
