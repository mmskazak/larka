.PHONY: help mail-up mail-down mail-logs mail-restart mail-ui install dev build serve test clean

# Default target
help:
	@echo "Larka Project - Available commands:"
	@echo ""
	@echo "[MailHog - Email Testing]"
	@echo "  make mail-up       - Start MailHog container"
	@echo "  make mail-down     - Stop MailHog container"
	@echo "  make mail-restart  - Restart MailHog container"
	@echo "  make mail-logs     - Show MailHog logs"
	@echo "  make mail-ui       - Open MailHog web UI in browser"
	@echo ""
	@echo "[Development]"
	@echo "  make install       - Install PHP and NPM dependencies"
	@echo "  make dev           - Start Laravel and Vite dev servers"
	@echo "  make build         - Build frontend assets for production"
	@echo "  make serve         - Start Laravel development server"
	@echo ""
	@echo "[Testing]"
	@echo "  make test          - Run PHPUnit tests"
	@echo ""
	@echo "[Maintenance]"
	@echo "  make clean         - Clean cache and logs"
	@echo ""

# MailHog commands
mail-up:
	@echo "Starting MailHog..."
	docker-compose up -d mailhog
	@echo "MailHog started!"
	@echo "SMTP: localhost:1025"
	@echo "Web UI: http://localhost:8025"

mail-down:
	@echo "Stopping MailHog..."
	docker-compose down
	@echo "MailHog stopped!"

mail-restart:
	@echo "Restarting MailHog..."
	docker-compose restart mailhog
	@echo "MailHog restarted!"

mail-logs:
	@echo "MailHog logs:"
	docker-compose logs -f mailhog

mail-ui:
	@echo "Opening MailHog UI in browser..."
	@start http://localhost:8025 2>nul || echo "Please open http://localhost:8025 in your browser"

# Development commands
install:
	@echo "Installing dependencies..."
	composer install
	npm install
	@echo "Dependencies installed!"

dev:
	@echo "Starting development servers..."
	@echo "Laravel: http://localhost:8000"
	@echo "Vite: http://localhost:5173"
	@start cmd /k "php artisan serve"
	npm run dev

build:
	@echo "Building frontend assets..."
	npm run build
	@echo "Build complete!"

serve:
	@echo "Starting Laravel server..."
	@echo "Application: http://localhost:8000"
	php artisan serve

# Testing
test:
	@echo "Running tests..."
	php artisan test

# Maintenance
clean:
	@echo "Cleaning cache and logs..."
	php artisan cache:clear
	php artisan config:clear
	php artisan route:clear
	php artisan view:clear
	@echo "Cache cleared!"
