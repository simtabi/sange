# ===================================================================
# Laravel Makefile (laravel.mk)
# ===================================================================
#
# Provides shortcuts for common Laravel Artisan commands, enabling
# automation of backend tasks like migrations, seeds, and caching.
#
# Include this file in Laravel projects for CLI convenience.
#
# ===================================================================

# -------------------------------------------------------------------
# ⚙️ Laravel Artisan Help Commands
# -------------------------------------------------------------------
laravel_help::  ## Show Laravel Artisan-related Make commands
	@$(call HR,$(HR_WIDTH))
	@echo "🎛️  Laravel Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "🧰  laravel_artisan         - Run Artisan command (use FLAGS=\"<command>\")"
	@echo "🌱  laravel_seed            - Seed the database"
	@echo "📜  laravel_migrate         - Run database migrations"
	@echo "🧪  laravel_test            - Run Laravel test suite"
	@echo "🔐  laravel_key             - Generate application key"
	@echo "🚀  laravel_optimize        - Optimize Laravel framework"
	@echo "🔗  laravel_storage_link    - Create storage symlink"
	@echo "♻️  laravel_cache_clear     - Clear config, route, and views caches"

ARTISAN ?= php artisan
FLAGS ?=

.PHONY: laravel_artisan laravel_migrate laravel_seed laravel_cache_clear laravel_key laravel_test


artisan:
	@$(ARTISAN) $(FLAGS)

laravel_migrate:
	@echo "Running Laravel migrations..."
	@$(ARTISAN) migrate $(FLAGS)

laravel_seed:
	@echo "Seeding the database..."
	@$(ARTISAN) db:seed $(FLAGS)

laravel_cache:
	@echo "Clearing Laravel caches..."
	@$(ARTISAN) config:clear
	@$(ARTISAN) route:clear
	@$(ARTISAN) view:clear
	@$(ARTISAN) cache:clear

laravel_key:
	@echo "Generating app key..."
	@$(ARTISAN) key:generate

laravel_test:
	@echo "Running Laravel tests..."
	@$(ARTISAN) test $(FLAGS)
