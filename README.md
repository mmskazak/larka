# Larka Project

Laravel 12 application with Breeze authentication, Inertia.js, and Vue 3.

## Tech Stack

**Backend:**
- Laravel 12.33.0
- PHP 8.4.4
- SQLite (development) / PostgreSQL (production)

**Frontend:**
- Vue 3
- Inertia.js 2.0
- Tailwind CSS 3.2
- Vite 7.0
- Vue I18n 9 (internationalization)

**Authentication:**
- Laravel Breeze 2.3
- Email verification enabled
- Laravel Sanctum

**Development Tools:**
- MailHog (Docker) for email testing
- Makefile for quick commands

---

## Quick Start (Development)

### Requirements

- PHP 8.4+
- Composer
- Node.js 20+
- Docker Desktop (for MailHog)

### Installation

```bash
# 1. Clone repository
git clone https://github.com/mmskazak/larka.git
cd larka

# 2. Install dependencies
make install
# Or manually:
composer install
npm install

# 3. Configure environment
cp .env.example .env
php artisan key:generate
php artisan migrate

# 4. Start MailHog (for email testing)
make mail-up

# 5. Start development servers
make dev
# Or manually:
php artisan serve  # Laravel: http://localhost:8000
npm run dev        # Vite: http://localhost:5173
```

### Testing Email

```bash
# Send test email
php test-email.php

# Open MailHog web UI
make mail-ui
# Or visit: http://localhost:8025
```

---

## Available Commands

```bash
make help          # Show all available commands

# MailHog (Email Testing)
make mail-up       # Start MailHog container
make mail-down     # Stop MailHog
make mail-ui       # Open web UI in browser

# Development
make install       # Install dependencies
make dev           # Start Laravel + Vite
make build         # Build frontend for production
make serve         # Start Laravel server only

# Testing & Maintenance
make test          # Run PHPUnit tests
make clean         # Clear cache
```

---

## Features

- ✅ User registration with email verification
- ✅ Login / Logout
- ✅ Password reset
- ✅ User profile management
- ✅ Dark mode support
- ✅ SPA navigation with Inertia.js
- ✅ Responsive design with Tailwind CSS
- ✅ Multi-language support (Russian/English) with Vue I18n

---

## Документация

Вся документация по проекту находится в папке `docs/`:

### Основная документация
- **[История изменений (CHANGELOG.md)](docs/CHANGELOG.md)** - Полная история изменений проекта
- **[Руководство по развертыванию (DEPLOYMENT.md)](docs/DEPLOYMENT.md)** - Подробные инструкции по деплою на production-сервер

### Интернационализация (i18n) 🌍
- **[🚀 Quick Start (I18N-QUICKSTART.md)](docs/I18N-QUICKSTART.md)** - Быстрый старт по локализации
- **[📚 StarterKit (I18N-STARTERKIT.md)](docs/I18N-STARTERKIT.md)** - Полное руководство по системе локализации
- **[Локализация (LOCALIZATION.md)](docs/LOCALIZATION.md)** - Детальная документация по переводам

---

## Deployment to Production

Подробное руководство смотрите в файле: **[docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)**

### Quick Overview

**Recommended options:**

1. **Laravel Forge** (easiest) - $12/month + VPS
   - Automatic server setup
   - One-click deployment
   - Free SSL, monitoring, backups
   - https://forge.laravel.com/

2. **VPS (DigitalOcean, Linode, Hetzner)** - $5-6/month
   - Full control
   - Manual setup required
   - Best for learning

3. **PaaS (Heroku, Railway, Fly.io)** - Free tier available
   - Zero server management
   - Auto-deploy from GitHub
   - Quick setup

### Basic Deployment Steps

```bash
# On server
git clone https://github.com/mmskazak/larka.git
cd larka
composer install --no-dev --optimize-autoloader
npm install && npm run build
cp .env.example .env
php artisan key:generate
php artisan migrate --force
php artisan config:cache
```

См. [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md) для полных инструкций.

---

## Development Workflow

### Git Flow

```
main (production)     ← stable releases only
  ↑
develop (staging)     ← development & testing
  ↑
feature/name          ← new features
hotfix/name           ← urgent production fixes
```

### Creating a Feature

```bash
# 1. Create feature branch
git checkout develop
git checkout -b feature/new-feature

# 2. Develop and test
# ... your code ...

# 3. Commit changes
git add .
git commit -m "Add new feature"

# 4. Push and create Pull Request
git push origin feature/new-feature
```

### Updating Production

```bash
# 1. Merge to main
git checkout main
git merge develop
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin main --tags

# 2. On server (or use GitHub Actions)
cd /var/www/larka
./deploy.sh  # See DEPLOYMENT.md
```

---

## Troubleshooting

### Email not showing in MailHog?

Check `.env` configuration:
```env
MAIL_MAILER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
```

Then clear config cache:
```bash
php artisan config:clear
```

### Docker errors?

Make sure Docker Desktop is running:
```bash
docker ps  # Should show running containers
```

### 500 Error?

Check logs:
```bash
tail -f storage/logs/laravel.log
```

---

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

---

## Links

- **Repository:** https://github.com/mmskazak/larka
- **Issues:** https://github.com/mmskazak/larka/issues
- **Laravel Docs:** https://laravel.com/docs
- **Vue.js Docs:** https://vuejs.org/
- **Inertia.js Docs:** https://inertiajs.com/
