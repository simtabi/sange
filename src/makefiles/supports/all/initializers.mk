# ===================================================================
# 🚀 Sange Bootstrap Makefile (init.mk)
# ===================================================================
#
# Provides quick project bootstrapping and environment setup targets
# to ensure consistency across machines and contributors.
#
# Include this in your root Makefile or run standalone via:
#   make -f path/to/init.mk [target]
#
# ===================================================================

# -------------------------------------------------------------------
# 📚 Help: List available targets
# -------------------------------------------------------------------
initializers_help:  ## Show init and environment validation commands
	@$(call HR,$(HR_WIDTH))
	@echo "📚 Initializers Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "🧪  Available init commands:"
	@echo "🛠  make init           - Run all setup checks"
	@echo "🌍  make check_env      - Check if environment variables are loaded"
	@echo "💻  make check_node     - Ensure Node.js and NPM/Yarn are installed"
	@echo "🐳  make check_docker   - Verify Docker is running"

.PHONY: init help check_env check_node check_docker run_sange

# -------------------------------------------------------------------
# 🎯 Bootstrap everything at once
# -------------------------------------------------------------------
init: check_env check_node check_docker run_sange
	@echo "✅ Sange environment is ready!"

# -------------------------------------------------------------------
# 🔍 Check if essential environment variables are present
# -------------------------------------------------------------------
check_env:
	@if [ -z "$(PROJECT_NAME)" ]; then \
		echo "⚠️  PROJECT_NAME is not set. Using fallback: sange"; \
	else \
		echo "✅ Environment variable PROJECT_NAME: $(PROJECT_NAME)"; \
	fi

# -------------------------------------------------------------------
# 🧪 Check Node.js and Package Manager
# -------------------------------------------------------------------
check_node:
	@if ! command -v node > /dev/null 2>&1; then \
		echo "❌ Node.js is not installed."; exit 1; \
	else \
		echo "✅ Node.js: $$(node -v)"; \
	fi; \
	if [ -f yarn.lock ]; then \
		echo "📦 Yarn detected."; yarn --version; \
	else \
		echo "📦 NPM detected."; npm --version; \
	fi

# -------------------------------------------------------------------
# 🐳 Check Docker installation and status
# -------------------------------------------------------------------
check_docker:
	@if ! command -v docker > /dev/null 2>&1; then \
		echo "❌ Docker is not installed."; exit 1; \
	fi; \
	if ! docker info > /dev/null 2>&1; then \
		echo "❌ Docker is installed but not running."; exit 1; \
	else \
		echo "✅ Docker is running."; \
	fi


# -------------------------------------------------------------------
# 🛠️ Auto-run Sange Core Script (silent + background)
# Run in the foreground
# @$(SANGE_ROOT)/scripts/sange.sh $(CMD) $(ARGS)
# -------------------------------------------------------------------
run_sange:
	@chmod +x $(SANGE_ROOT)/scripts/sange.sh
	@nohup $(SANGE_ROOT)/scripts/sange.sh >/dev/null 2>&1 &
