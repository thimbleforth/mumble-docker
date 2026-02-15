.PHONY: help build build-chainguard up down logs clean test

help: ## Display this help message
	@echo "Mumble Docker - Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image (standard Alpine)
	docker build -t mumble-server:latest .

build-chainguard: ## Build the Docker image (Chainguard variant)
	docker build -f Dockerfile.chainguard -t mumble-server:chainguard .

up: ## Start the Mumble server
	docker-compose up -d

up-chainguard: ## Start the Mumble server (Chainguard variant)
	docker-compose -f docker-compose.chainguard.yml up -d

down: ## Stop the Mumble server
	docker-compose down

down-all: ## Stop and remove volumes
	docker-compose down -v

logs: ## Show logs
	docker-compose logs -f

shell: ## Open a shell in the running container
	docker-compose exec mumble-server sh

restart: ## Restart the Mumble server
	docker-compose restart

status: ## Show container status
	docker-compose ps

clean: ## Remove all containers, images, and volumes
	docker-compose down -v
	docker rmi mumble-server:latest mumble-server:chainguard 2>/dev/null || true

backup: ## Backup Mumble data
	@mkdir -p backups
	docker run --rm \
		-v mumble-data:/data \
		-v $(PWD)/backups:/backup \
		alpine tar czf /backup/mumble-data-$(shell date +%Y%m%d-%H%M%S).tar.gz /data
	@echo "Backup created in backups/ directory"

restore: ## Restore from backup (use BACKUP_FILE=path/to/backup.tar.gz)
	@if [ -z "$(BACKUP_FILE)" ]; then echo "Error: BACKUP_FILE not set"; exit 1; fi
	docker run --rm \
		-v mumble-data:/data \
		-v $(PWD)/backups:/backup \
		alpine tar xzf /backup/$(BACKUP_FILE) -C /
	@echo "Backup restored from $(BACKUP_FILE)"

test: ## Run basic tests
	@echo "Testing build..."
	docker build -t mumble-server:test .
	@echo "Build successful!"

scan: ## Scan image for vulnerabilities (requires trivy)
	trivy image mumble-server:latest

update: ## Pull latest base images and rebuild
	docker pull alpine:latest
	docker-compose build --pull
	docker-compose up -d

version: ## Show Mumble version
	docker run --rm mumble-server:latest murmurd -version 2>&1 || echo "Image not built yet"
