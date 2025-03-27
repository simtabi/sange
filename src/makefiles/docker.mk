# ===================================================================
# Docker Makefile (docker.mk)
# ===================================================================
#
# Provides standardized commands for Docker container lifecycle
# management such as building, running, stopping, and logging.
#
# This file should be included in your project Makefile to streamline
# Docker usage across development and deployment.
#
# ===================================================================

DOCKER_IMAGE ?= sange-app
DOCKER_CONTAINER ?= sange-container
DOCKERFILE ?= Dockerfile
FLAGS ?=

# -------------------------------------------------------------------
# 🐳 Docker Help Commands
# -------------------------------------------------------------------
docker_help::  ## Show Docker-related Make commands
	@$(call HR,$(HR_WIDTH))
	@echo "🐳 Docker Help Commands"
	@$(call HR,$(HR_WIDTH))
	@echo "🐳 docker_build        - Build Docker image"
	@echo "🚀 docker_up           - Start containers (docker-compose up)"
	@echo "🛑 docker_down         - Stop and remove containers"
	@echo "📦 docker_exec         - Execute command inside container"
	@echo "🧹 docker_prune        - Remove all stopped containers/images/volumes"

.PHONY: docker_build docker_run docker_stop docker_rm docker_logs docker_exec

docker_build:
	@echo "Building Docker image: $(DOCKER_IMAGE)..."
	@docker build -f $(DOCKERFILE) -t $(DOCKER_IMAGE) . $(FLAGS)

docker_run:
	@echo "Running Docker container: $(DOCKER_CONTAINER)..."
	@docker run --name $(DOCKER_CONTAINER) $(FLAGS) $(DOCKER_IMAGE)

docker_stop:
	@echo "Stopping Docker container..."
	@docker stop $(DOCKER_CONTAINER)

docker_rm:
	@echo "Removing Docker container..."
	@docker rm $(DOCKER_CONTAINER)

docker_logs:
	@echo "Fetching logs from container..."
	@docker logs $(FLAGS) $(DOCKER_CONTAINER)

docker_exec:
	@echo "Entering container shell..."
	@docker exec -it $(DOCKER_CONTAINER) sh
