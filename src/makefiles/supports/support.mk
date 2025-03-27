# ===================================================================
# 🧰 Sange Support Helpers (support.mk)
# ===================================================================
#
# This file provides shared helper targets and includes support
# modules such as initializers and generators.
#
# It is intended to be included by the master sange.mk file,
# making the helpers globally accessible across all packages.
#
# ===================================================================
# -------------------------------------------------------------------
# 🧩 Support Stack Help Commands
# -------------------------------------------------------------------
support_help::  ## Show support module help
	@$(call HR,$(HR_WIDTH))
	@echo "🧩 Support Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "🧪 run_sange                                     - Ensure sange.sh is executable"
	@echo "📦 include makefiles/supports/all/generators.mk   - Load generation helpers"
	@echo "🧱 include makefiles/supports/all/initializers.mk - Load environment init tools"

.PHONY: print_root_path print_hello

# -------------------------------------------------------------------
# 🔗 Includes
# -------------------------------------------------------------------
# Load all initialization helpers and project generators
include $(SANGE_ROOT)makefiles/supports/all/initializers.mk
include $(SANGE_ROOT)makefiles/supports/all/generators.mk

define FAIL_HARD
( echo "$(1)"; exit 1 )
endef

# -------------------------------------------------------------------
# 📂 Print the Base Path for all Includes
# -------------------------------------------------------------------
print_root_path:
	@echo $(info "📂 The current makefile directory is: $(SANGE_ROOT)")

# -------------------------------------------------------------------
# 👋 print_hello
# -------------------------------------------------------------------
# Simple diagnostic command to verify environment variables and
# inclusion of this support file.
#
# Outputs:
#   - 👋 Hello from support.mk!
# -------------------------------------------------------------------

print_hello:
	@echo "👋 Hello from support.mk!"
