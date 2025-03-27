# ===================================================================
# 📦 Sange Generators Makefile
# ===================================================================
#
# This Makefile defines utility commands for generating boilerplate
# configuration and scaffolding files across packages in the MukoraCMS
# monorepo, such as Makefiles using the sange template engine.
#
# -------------------------------------------------------------------
# 📝 Notes:
#   - All targets here are reusable and safe for shared use
#   - Intended to be included in higher-level Makefiles
#
# ===================================================================

# -------------------------------------------------------------------
# ⚙️ Generators Help Commands
# -------------------------------------------------------------------
generators_help:  ## Show project scaffolding/generation help
	@$(call HR,$(HR_WIDTH))
	@echo "⚙️ Generators Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "🧩 generate_project_makefile  - Prompt and create a project Makefile using the template"

.PHONY: generate_project_makefile

# -------------------------------------------------------------------
# 🧩 generate_project_makefile
# -------------------------------------------------------------------
# Interactive CLI utility that:
#   - Prompts for a package name
#   - Prompts for a destination directory
#   - Generates a Makefile using a sange template
#
# ✅ Aborts if:
#   - Required inputs are not provided
#   - A Makefile already exists at the destination
#
# Usage:
#   make generate_project_makefile
# -------------------------------------------------------------------

generate_project_makefile:
	@bash $(SANGE_ROOT)/scripts/all/generators/project-makefile.sh
