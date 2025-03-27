# ===================================================================
# NPM/Yarn Makefile (npm.mk)
# ===================================================================
#
# Provides a unified interface for common NPM or Yarn commands.
# Automatically detects the package manager based on yarn.lock.
#
# This file is useful for frontend project automation tasks.
#
# ===================================================================

# -------------------------------------------------------------------
# 📦 NPM/Yarn Help Commands
# -------------------------------------------------------------------
npm_help::  ## Show NPM/Yarn-related Make commands
	@$(call HR,$(HR_WIDTH))
	@echo "📦 NPM/Yarn Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "📦 npm_install         - Install dependencies"
	@echo "🧪 npm_run             - Run script (pass with FLAGS=\"<script>\")"
	@echo "🧼 npm_clean           - Remove node_modules and reinstall"
	@echo "🚀 npm_build           - Build frontend assets"
	@echo "🧹 npm_cache_clear     - Clear npm/yarn cache"

PACKAGE_MANAGER := $(shell [ -f yarn.lock ] && echo yarn || echo npm)
FLAGS ?=

.PHONY: npm_install npm_run npm_dev npm_build npm_clean

npm_install:
	@echo "Installing dependencies using $(PACKAGE_MANAGER)..."
	@$(PACKAGE_MANAGER) install $(FLAGS)

npm_run:
	@echo "Running: $(PACKAGE_MANAGER) run $(FLAGS)..."
	@$(PACKAGE_MANAGER) run $(FLAGS)

npm_dev:
	@echo "Starting dev server..."
	@$(PACKAGE_MANAGER) run dev $(FLAGS)

npm_build:
	@echo "Building for production..."
	@$(PACKAGE_MANAGER) run build $(FLAGS)

npm_clean:
	@echo "Cleaning node_modules..."
	@rm -rf node_modules