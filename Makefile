# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Default environment
ENV_FILE := .env
COMPOSE_FILE := docker-compose.dev.yml

# Help command (default)
.PHONY: help
help: ## Show this help message
	@printf "$(GREEN)Available commands:$(NC)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'

# Project Setup
.PHONY: init
init: ## Initialize project structure and dependencies
	@printf "  1. Update .env with secure values\n"
	@printf "  2. Customize backend/prisma/schema.prisma\n"

.PHONY: setup
setup: init build up migrate seed studio ## Complete project setup (init + build + up + migrate + seed)
	@printf "$(GREEN)Project setup complete!$(NC)\n"
	@printf "$(YELLOW)Services available at:$(NC)\n"
	@printf "  Frontend: http://localhost:3000\n"
	@printf "  Backend:  http://localhost:4040\n"
	@printf "  Database: localhost:5432\n"
	@printf "  Prisma Studio: localhost:5555\n"

# Docker Management
.PHONY: build
build: ## Build all Docker containers
	@printf "$(GREEN)Building Docker containers...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) build --build-arg DATABASE_URL=$(DATABASE_URL)

.PHONY: up
up: ## Start all services
	@printf "$(GREEN)Starting services...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) up -d
	@printf "$(GREEN)Services started!$(NC)\n"
	@make status

.PHONY: down
down: ## Stop all services
	@printf "$(YELLOW)Stopping services...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) down

.PHONY: restart
restart: down up ## Restart all services

.PHONY: rebuild
rebuild: down ## Rebuild and restart all services
	@printf "$(GREEN)Rebuilding containers...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) up --build -d
	@make status

.PHONY: status
status: ## Show status of all services
	@printf "$(GREEN)Service Status:$(NC)\n"
	@docker-compose -f $(COMPOSE_FILE) ps

# Logs
.PHONY: logs
logs: ## Show logs for all services
	docker-compose -f $(COMPOSE_FILE) logs -f

.PHONY: logs-backend
logs-backend: ## Show backend logs
	docker-compose -f $(COMPOSE_FILE) logs -f backend

.PHONY: logs-frontend
logs-frontend: ## Show frontend logs
	docker-compose -f $(COMPOSE_FILE) logs -f frontend

.PHONY: logs-db
logs-db: ## Show database logs
	docker-compose -f $(COMPOSE_FILE) logs -f postgres

# Database Operations
.PHONY: db-shell
db-shell: ## Access PostgreSQL shell
	@printf "$(GREEN)Connecting to PostgreSQL...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec postgres psql -U postgres -d myapp_db

.PHONY: migrate
migrate: ## Run Prisma migrations
	@printf "$(GREEN)Running Prisma migrations...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npm run db:migrate

.PHONY: migrate-reset
migrate-reset: ## Reset database and run migrations
	@printf "$(YELLOW)Resetting database...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npx prisma migrate reset --force

.PHONY: db-push
db-push: ## Push Prisma schema to database (for development)
	@printf "$(GREEN)Pushing schema to database...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npm run db:push

.PHONY: generate
generate: ## Generate Prisma client
	@printf "$(GREEN)Generating Prisma client...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npm run db:generate

.PHONY: studio
studio: ## Open Prisma Studio
	@printf "$(GREEN)Opening Prisma Studio...$(NC)\n"
	@printf "$(YELLOW)Prisma Studio will be available at http://localhost:5555$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npm run db:studio

.PHONY: seed
seed: ## Seed the database
	@printf "$(GREEN)Seeding database...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npx prisma db seed

# Development
.PHONY: dev
dev: up studio ## Start development environment
	@printf "$(GREEN)Development environment started!$(NC)\n"
	@make logs

.PHONY: shell-backend
shell-backend: ## Access backend container shell
	docker-compose -f $(COMPOSE_FILE) exec backend sh

.PHONY: shell-frontend
shell-frontend: ## Access frontend container shell
	docker-compose -f $(COMPOSE_FILE) exec frontend sh

.PHONY: install-backend
install-backend: ## Install backend dependencies
	@printf "$(GREEN)Installing backend dependencies...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npm install

.PHONY: install-frontend
install-frontend: ## Install frontend dependencies
	@printf "$(GREEN)Installing frontend dependencies...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec frontend npm install

# Testing & Health Checks
.PHONY: health
health: ## Check health of all services
	@printf "$(GREEN)Checking service health...$(NC)\n"
	@printf "$(YELLOW)Backend Health:$(NC)\n"
	@curl -s http://localhost:4040/health | jq . || printf "Backend not responding\n"
	@printf "$(YELLOW)Database Test:$(NC)\n"
	@curl -s http://localhost:4040/db-test | jq . || printf "Database not responding\n"

.PHONY: test-backend
test-backend: ## Run backend tests
	@printf "$(GREEN)Running backend tests...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec backend npm test

.PHONY: test-frontend
test-frontend: ## Run frontend tests
	@printf "$(GREEN)Running frontend tests...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec frontend npm test

# Cleanup
.PHONY: clean
clean: down ## Stop services and remove containers
	@printf "$(YELLOW)Cleaning up containers...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) down --remove-orphans
	docker system prune -f

.PHONY: clean-all
clean-all: ## Stop services, remove containers, volumes, and images
	@printf "$(RED)Warning: This will remove all data!$(NC)\n"
	@read -p "Are you sure? (y/N): " confirm && [ "$$confirm" = "y" ]
	docker-compose -f $(COMPOSE_FILE) down -v --remove-orphans
	docker system prune -af
	docker volume prune -f

.PHONY: reset
reset: clean-all setup ## Reset everything (clean + build + up + migrate)
	@printf "$(GREEN)Project reset complete!$(NC)\n"

# Backup & Restore
.PHONY: backup
backup: ## Backup database
	@printf "$(GREEN)Creating database backup...$(NC)\n"
	@mkdir -p backups
	docker-compose -f $(COMPOSE_FILE) exec -T postgres pg_dump -U postgres -d myapp_db > backups/backup_$$(date +%Y%m%d_%H%M%S).sql
	@printf "$(GREEN)Backup created in backups/ directory$(NC)\n"

.PHONY: restore
restore: ## Restore database from backup (usage: make restore BACKUP=filename)
	@if [ -z "$(BACKUP)" ]; then \
		printf "$(RED)Error: Please specify BACKUP file$(NC)\n"; \
		printf "Usage: make restore BACKUP=backups/backup_20231201_120000.sql\n"; \
		exit 1; \
	fi
	@printf "$(YELLOW)Restoring database from $(BACKUP)...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) exec -T postgres psql -U postgres -d myapp_db < $(BACKUP)
	@printf "$(GREEN)Database restored!$(NC)\n"

# Production
.PHONY: prod-build
prod-build: ## Build for production
	@printf "$(GREEN)Building for production...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) -f docker-compose.prod.yml build

.PHONY: prod-up
prod-up: ## Start production environment
	@printf "$(GREEN)Starting production environment...$(NC)\n"
	docker-compose -f $(COMPOSE_FILE) -f docker-compose.prod.yml up -d

# Utility
.PHONY: env-check
env-check: ## Check environment variables
	@printf "$(GREEN)Environment Variables:$(NC)\n"
	@if [ -f $(ENV_FILE) ]; then \
		printf "$(YELLOW)DB_NAME:$(NC) $$(grep POSTGRES_DB $(ENV_FILE) | cut -d'=' -f2)\n"; \
		printf "$(YELLOW)DB_USER:$(NC) $$(grep POSTGRES_USER $(ENV_FILE) | cut -d'=' -f2)\n"; \
		printf "$(YELLOW)FRONTEND_PORT:$(NC) $$(grep FRONTEND_PORT $(ENV_FILE) | cut -d'=' -f2)\n"; \
		printf "$(YELLOW)BACKEND_PORT:$(NC) $$(grep BACKEND_PORT $(ENV_FILE) | cut -d'=' -f2)\n"; \
		printf "$(YELLOW)BACKEND_PORT:$(NC) $$(grep BACKEND_PORT $(ENV_FILE) | cut -d'=' -f2)\n"; \
	else \
		printf "$(RED).env file not found!$(NC)\n"; \
	fi

.PHONY: ports
ports: ## Show all exposed ports
	@printf "$(GREEN)Exposed Ports:$(NC)\n"
	@printf "  $(YELLOW)3000$(NC) - Frontend\n"
	@printf "  $(YELLOW)4000$(NC) - Backend API\n"
	@printf "  $(YELLOW)5432$(NC) - PostgreSQL\n"
	@printf "  $(YELLOW)5555$(NC) - Prisma Studio (when running)\n"

# Quick aliases
.PHONY: start stop restart-quick
start: up ## Alias for 'up'
stop: down ## Alias for 'down'
restart-quick: restart ## Alias for 'restart'