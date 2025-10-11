# Changelog проекта Larka

Документация всех изменений и настроек проекта.

---

## 2025-10-11 - Начало проекта

### 1. Установка Laravel 12.33.0

**Действия:**
```bash
composer create-project laravel/laravel .
```

**Что установлено:**
- Laravel Framework 12.33.0
- PHP 8.4.4
- Composer 2.8.8
- SQLite база данных (database/database.sqlite)

**Автоматические настройки:**
- Создан `.env` файл из `.env.example`
- Сгенерирован APP_KEY
- Выполнены базовые миграции:
  - `0001_01_01_000000_create_users_table`
  - `0001_01_01_000001_create_cache_table`
  - `0001_01_01_000002_create_jobs_table`

**Git:**
- Инициализирован репозиторий
- Создан коммит: "Initial Laravel 12 installation"
- Запушено в https://github.com/mmskazak/larka.git

---

### 2. Установка Laravel Breeze с Inertia.js и Vue 3

**Действия:**
```bash
composer require laravel/breeze --dev
php artisan breeze:install vue --dark
```

**Установленные пакеты (Composer):**
- `laravel/breeze: ^2.3.8`
- `inertiajs/inertia-laravel: ^2.0.10`
- `laravel/sanctum: ^4.2.0`
- `tightenco/ziggy: ^2.6.0`

**Установленные пакеты (NPM):**
- `@inertiajs/vue3: ^2.0.0`
- `@tailwindcss/forms: ^0.5.3`
- `@tailwindcss/vite: ^4.0.0`
- `@vitejs/plugin-vue: ^6.0.0` ⚠️ (обновлено с 5.0.0)
- `vue: ^3.4.0`
- `vite: ^7.0.7`
- `laravel-vite-plugin: ^2.0.0`
- `tailwindcss: ^3.2.1`

**Важно! Исправление конфликта версий:**

**Проблема:** `@vitejs/plugin-vue: ^5.0.0` несовместим с `vite: ^7.0.7`

**Решение:** Обновлен `@vitejs/plugin-vue` до версии `^6.0.0` в `package.json`

**Файл:** [package.json](../package.json:13)
```json
"@vitejs/plugin-vue": "^6.0.0"
```

**Команды установки:**
```bash
# После изменения package.json
npm install
npm run build
php artisan migrate:fresh
```

**Созданные файлы и директории:**

**Controllers:**
- `app/Http/Controllers/Auth/` (8 контроллеров авторизации)
- `app/Http/Controllers/ProfileController.php`

**Middleware:**
- `app/Http/Middleware/HandleInertiaRequests.php`

**Requests:**
- `app/Http/Requests/Auth/LoginRequest.php`
- `app/Http/Requests/ProfileUpdateRequest.php`

**Vue компоненты:**
- `resources/js/Components/` (13 переиспользуемых компонентов)
- `resources/js/Layouts/` (2 layout'а)
- `resources/js/Pages/` (9 страниц)

**Конфигурация:**
- `routes/auth.php` - маршруты авторизации
- `tailwind.config.js` - настройки Tailwind CSS
- `postcss.config.js` - PostCSS конфигурация
- `jsconfig.json` - настройки JavaScript
- `vite.config.js` - обновлен для Vue

**Тесты:**
- `tests/Feature/Auth/` (6 тестов авторизации)
- `tests/Feature/ProfileTest.php`

**Доступные маршруты:**
```
GET    /                    - главная страница (Welcome)
GET    /login               - страница входа
POST   /login               - обработка входа
POST   /logout              - выход
GET    /register            - страница регистрации
POST   /register            - обработка регистрации
GET    /dashboard           - панель управления (защищено auth)
GET    /profile             - редактирование профиля (защищено auth)
PATCH  /profile             - обновление профиля
DELETE /profile             - удаление профиля
GET    /forgot-password     - страница восстановления пароля
POST   /forgot-password     - отправка ссылки восстановления
GET    /reset-password/{token} - страница сброса пароля
POST   /reset-password      - обработка сброса пароля
GET    /verify-email        - уведомление о верификации email
GET    /verify-email/{id}/{hash} - верификация email
POST   /email/verification-notification - повторная отправка письма
GET    /confirm-password    - подтверждение пароля
POST   /confirm-password    - обработка подтверждения
PUT    /password            - обновление пароля
```

**Особенности настройки:**
- ✅ Dark mode поддержка (флаг `--dark`)
- ✅ Tailwind CSS с формами
- ✅ Inertia.js для SPA-навигации
- ✅ Vue 3 Composition API
- ✅ Laravel Sanctum для API аутентификации
- ✅ Ziggy для использования Laravel роутов в JavaScript

**Git:**
- Создан коммит: "Add Laravel Breeze authentication with Inertia Vue"
- Запушено в GitHub

---

## Запуск проекта

```bash
# Backend
php artisan serve

# Frontend (в отдельном терминале)
npm run dev
```

Приложение доступно по адресу: http://localhost:8000

---

## Технологии

**Backend:**
- Laravel 12.33.0
- PHP 8.4.4
- SQLite

**Frontend:**
- Vue 3
- Inertia.js 2.0
- Tailwind CSS 3.2
- Vite 7.0

**Аутентификация:**
- Laravel Breeze 2.3
- Laravel Sanctum 4.2

---

### 3. Включение верификации email

**Дата:** 2025-10-11

**Действия:**

1. **Активирован интерфейс MustVerifyEmail в модели User**

   **Файл:** [app/Models/User.php](../app/Models/User.php:5-10)

   Изменения:
   ```php
   // Было:
   // use Illuminate\Contracts\Auth\MustVerifyEmail;
   class User extends Authenticatable

   // Стало:
   use Illuminate\Contracts\Auth\MustVerifyEmail;
   class User extends Authenticatable implements MustVerifyEmail
   ```

2. **Добавлен middleware 'verified' к защищённым маршрутам**

   **Файл:** [routes/web.php](../routes/web.php:19-25)

   Изменения:
   ```php
   // Dashboard уже был защищён
   Route::get('/dashboard', function () {
       return Inertia::render('Dashboard');
   })->middleware(['auth', 'verified'])->name('dashboard');

   // Добавлена защита к маршрутам профиля
   Route::middleware(['auth', 'verified'])->group(function () {
       Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
       Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
       Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
   });
   ```

3. **Обновлён .env.example с настройками почты**

   **Файл:** [.env.example](../.env.example:50-66)

   Добавлены комментарии для разработчиков:
   ```env
   MAIL_MAILER=log
   MAIL_ENCRYPTION=null
   MAIL_FROM_ADDRESS="hello@example.com"
   MAIL_FROM_NAME="${APP_NAME}"

   # For development, use Mailtrap (https://mailtrap.io) or MailHog
   # MAIL_MAILER=smtp
   # MAIL_HOST=sandbox.smtp.mailtrap.io
   # MAIL_PORT=2525
   # MAIL_USERNAME=your_mailtrap_username
   # MAIL_PASSWORD=your_mailtrap_password
   # MAIL_ENCRYPTION=tls
   ```

**Как работает верификация email:**

1. Пользователь регистрируется
2. Ему отправляется письмо со ссылкой подтверждения
3. При попытке доступа к защищённым маршрутам (/dashboard, /profile) его перенаправляет на `/verify-email`
4. На странице `/verify-email` пользователь видит уведомление и может запросить повторную отправку письма
5. После клика по ссылке в письме email подтверждается, поле `email_verified_at` устанавливается
6. Пользователь получает доступ к защищённым маршрутам

**Маршруты верификации:**
```
GET    /verify-email                    - страница уведомления (verification.notice)
GET    /verify-email/{id}/{hash}        - обработка подтверждения (verification.verify)
POST   /email/verification-notification - повторная отправка письма (verification.send)
```

**Для тестирования в development:**

По умолчанию `MAIL_MAILER=log`, письма сохраняются в `storage/logs/laravel.log`

Для реальной отправки:
- Используйте [Mailtrap.io](https://mailtrap.io) - сервис для тестирования email
- Или [MailHog](https://github.com/mailhog/MailHog) - локальный SMTP сервер
- Настройте SMTP в `.env` файле

**Git:**
- Изменено 3 файла
- Коммит будет создан

---

### 4. Настройка MailHog через Docker и создание Makefile

**Дата:** 2025-10-11

**Цель:** Упростить локальную разработку с тестированием email через MailHog в Docker

**Созданные файлы:**

1. **[docker-compose.yml](../docker-compose.yml)** - Docker Compose конфигурация

   ```yaml
   version: '3.8'

   services:
     mailhog:
       image: mailhog/mailhog:latest
       container_name: larka_mailhog
       ports:
         - "1025:1025"  # SMTP server
         - "8025:8025"  # Web UI
       networks:
         - larka_network
       restart: unless-stopped
   ```

   **Порты:**
   - `1025` - SMTP сервер (для отправки писем из Laravel)
   - `8025` - Web UI (для просмотра писем в браузере)

2. **[Makefile](../Makefile)** - Удобные команды для разработки

   **Команды MailHog:**
   ```bash
   make mail-up       # Запустить MailHog
   make mail-down     # Остановить MailHog
   make mail-restart  # Перезапустить MailHog
   make mail-logs     # Показать логи MailHog
   make mail-ui       # Открыть Web UI в браузере
   ```

   **Команды для разработки:**
   ```bash
   make install       # Установить зависимости (composer + npm)
   make dev           # Запустить Laravel + Vite
   make build         # Собрать frontend
   make serve         # Запустить только Laravel
   make test          # Запустить тесты
   make clean         # Очистить кеш
   make help          # Показать все команды
   ```

3. **Обновлён [.env.example](../.env.example:50-74)**

   ```env
   MAIL_MAILER=smtp
   MAIL_HOST=localhost
   MAIL_PORT=1025
   MAIL_USERNAME=null
   MAIL_PASSWORD=null
   MAIL_ENCRYPTION=null
   MAIL_FROM_ADDRESS="noreply@larka.test"
   MAIL_FROM_NAME="${APP_NAME}"

   # MailHog (Docker) - for local development
   # Start: make mail-up
   # Web UI: http://localhost:8025
   # SMTP: localhost:1025
   ```

**Использование:**

**⚠️ Требования:**
- Docker Desktop должен быть установлен и **запущен**
- Для Windows: https://www.docker.com/products/docker-desktop/

1. **Запустить Docker Desktop** (если ещё не запущен)

2. **Запуск MailHog:**
   ```bash
   make mail-up
   ```

3. **Открыть Web UI:**
   ```bash
   make mail-ui
   # Или вручную: http://localhost:8025
   ```

4. **Обновить .env файл:**
   Скопируйте настройки из `.env.example` в `.env`:
   ```env
   MAIL_MAILER=smtp
   MAIL_HOST=localhost
   MAIL_PORT=1025
   MAIL_ENCRYPTION=null
   ```

4. **Тестирование:**
   - Зарегистрируйте пользователя через `/register`
   - Письмо с подтверждением появится в MailHog Web UI
   - Кликните по ссылке для верификации email

**Преимущества MailHog:**
- ✅ Не требует регистрации (в отличие от Mailtrap)
- ✅ Работает локально (нет отправки в интернет)
- ✅ Удобный Web интерфейс
- ✅ Мгновенное получение писем
- ✅ Можно тестировать без интернета
- ✅ Автоматический запуск через Makefile

**Альтернативы:**
- `MAIL_MAILER=log` - письма в `storage/logs/laravel.log`
- Mailtrap.io - облачный сервис для тестирования

**Git:**
- Созданы 2 новых файла
- Обновлён .env.example
- Коммит будет создан

---

### 5. Исправления для Windows: кодировка и Docker Compose

**Дата:** 2025-10-11

**Проблемы:**
1. Эмодзи в Makefile не отображались в Windows PowerShell
2. Docker Compose выдавал warning о устаревшем поле `version`

**Исправления:**

1. **[Makefile](../Makefile)** - Убраны все эмодзи, заменены на обычный текст

   ```makefile
   # Было:
   @echo "📧 MailHog (Email Testing):"
   @echo "🚀 Starting MailHog..."

   # Стало:
   @echo "[MailHog - Email Testing]"
   @echo "Starting MailHog..."
   ```

   Также исправлена команда `mail-ui` для Windows:
   ```makefile
   # Было:
   @start http://localhost:8025 2>/dev/null || ...

   # Стало:
   @start http://localhost:8025 2>nul || echo "Please open http://localhost:8025 in your browser"
   ```

2. **[docker-compose.yml](../docker-compose.yml)** - Удалено устаревшее поле `version`

   ```yaml
   # Было:
   version: '3.8'

   services:
     mailhog:

   # Стало:
   services:
     mailhog:
   ```

**Результат:**
- ✅ Makefile корректно отображается в Windows PowerShell
- ✅ Docker Compose больше не выдаёт warnings
- ✅ Команда `make mail-ui` работает в Windows

**Команды остались те же:**
```bash
make help          # Показать все команды
make mail-up       # Запустить MailHog
make mail-ui       # Открыть Web UI
```

**Git:**
- Изменены 2 файла
- Обновлена документация
- Коммит будет создан

---

### 6. Настройка .env для работы с MailHog и тестовый скрипт

**Дата:** 2025-10-11

**Проблема:** При попытке отправить письмо оно не попадало в MailHog, так как в `.env` был `MAIL_MAILER=log`

**Решение:**

1. **Обновлён [.env](../.env:50-58)** для работы с MailHog

   ```env
   # Было:
   MAIL_MAILER=log
   MAIL_HOST=127.0.0.1
   MAIL_PORT=2525
   MAIL_FROM_ADDRESS="hello@example.com"

   # Стало:
   MAIL_MAILER=smtp
   MAIL_HOST=localhost
   MAIL_PORT=1025
   MAIL_ENCRYPTION=null
   MAIL_FROM_ADDRESS="noreply@larka.test"
   ```

2. **Создан [test-email.php](../test-email.php)** - скрипт для быстрого тестирования отправки email

   ```php
   <?php
   use Illuminate\Support\Facades\Mail;

   require __DIR__.'/vendor/autoload.php';
   $app = require_once __DIR__.'/bootstrap/app.php';
   $app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

   Mail::raw('This is a test email from Laravel!', function ($message) {
       $message->to('test@example.com')
               ->subject('Test Email from Larka Project');
   });

   echo "Test email sent to MailHog!\n";
   echo "Check: http://localhost:8025\n";
   ```

**Использование тестового скрипта:**

```bash
# 1. Убедитесь что MailHog запущен
make mail-up

# 2. Отправьте тестовое письмо
php test-email.php

# 3. Откройте MailHog Web UI
make mail-ui
# Или http://localhost:8025
```

**После изменения .env всегда очищайте кеш:**
```bash
php artisan config:clear
```

**Проверка текущих настроек почты:**
```bash
php artisan tinker --execute="echo config('mail.mailers.smtp.host') . ':' . config('mail.mailers.smtp.port');"
# Должно вывести: localhost:1025
```

**Git:**
- Изменён .env
- Создан test-email.php
- Обновлена документация
- Коммит будет создан

---

### 7. Создание документации по деплою и workflow разработки

**Дата:** 2025-10-11

**Цель:** Предоставить полное руководство по развертыванию проекта на production сервере и организации процесса разработки

**Созданные файлы:**

1. **[DEPLOYMENT.md](DEPLOYMENT.md)** - Полное руководство по деплою (500+ строк)

   **Содержание:**
   - Варианты деплоя (VPS, Laravel Forge, PaaS, Shared Hosting)
   - Подготовка сервера (Ubuntu, Nginx, PHP, PostgreSQL)
   - Первоначальный деплой (пошаговая инструкция)
   - Настройка SSL (Let's Encrypt)
   - Настройка Supervisor для очередей
   - Workflow разработки (Git Flow)
   - Скрипты автоматического деплоя
   - CI/CD с GitHub Actions
   - Troubleshooting
   - Чек-листы

   **Рекомендации:**
   - **Для начала:** VPS (DigitalOcean/Hetzner) - $5-6/месяц
   - **Для production:** Laravel Forge - $12/месяц (автоматизация)
   - **Для экспериментов:** PaaS (Railway/Heroku) - бесплатный tier

2. **[README.md](../README.md)** - Обновлён с полной документацией

   **Добавлено:**
   - Quick Start для разработки
   - Список всех команд Makefile
   - Описание features
   - Краткий обзор вариантов деплоя
   - Development Workflow (Git Flow)
   - Troubleshooting секция
   - Ссылки на документацию

**Git Flow (рекомендуемый):**

```
main (production)     ← только стабильные релизы
  ↑
develop (staging)     ← разработка и тестирование
  ↑
feature/название      ← новые фичи
hotfix/название       ← срочные исправления
```

**Процесс разработки:**

1. Создать feature branch: `git checkout -b feature/new-feature`
2. Разработать и протестировать локально
3. Создать Pull Request в `develop`
4. После тестирования - мерж в `main`
5. Деплой на production: `./deploy.sh` или через GitHub Actions

**Скрипт деплоя (deploy.sh):**

```bash
#!/bin/bash
php artisan down
git pull origin main
composer install --no-dev --optimize-autoloader
npm ci && npm run build
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
sudo supervisorctl restart larka-worker:*
php artisan up
```

**Автоматический деплой через GitHub Actions:**

При push в `main` автоматически запускается деплой на сервер через SSH.

**Git:**
- Созданы 2 новых файла документации
- Обновлён README
- Коммит будет создан

---

### 8. Настройка MCP (Model Context Protocol) для удалённого управления

**Дата:** 2025-10-11

**Цель:** Подготовить возможность управления production сервером через Claude с использованием SSH MCP

**Что такое MCP:**
- Протокол для подключения Claude к внешним инструментам
- Позволяет работать с серверами, базами данных, GitHub и др.
- После настройки Claude сможет выполнять команды на сервере напрямую

**Созданные файлы:**

1. **MCP-SETUP.md** - Полное руководство по настройке MCP (300+ строк) _(файл не сохранён в текущей версии)_

   **Содержание:**
   - Что такое MCP и зачем он нужен
   - SSH MCP сервер для удалённого доступа
   - Создание и настройка SSH ключей
   - Конфигурация Claude Desktop
   - PostgreSQL MCP для работы с БД
   - GitHub MCP для управления репозиторием
   - Docker MCP для локальных контейнеров
   - Безопасность и best practices
   - Troubleshooting

2. **[claude_desktop_config.example.json](../claude_desktop_config.example.json)** - Пример конфигурации

   ```json
   {
     "mcpServers": {
       "larka-production": {
         "command": "npx",
         "args": ["-y", "@modelcontextprotocol/server-ssh", "deployer@YOUR_IP"],
         "env": {"SSH_KEY_PATH": "путь_к_ключу"}
       }
     }
   }
   ```

**Созданы SSH ключи:**

```bash
# Приватный ключ (СЕКРЕТНЫЙ, хранить локально)
C:\Users\HOME\.ssh\id_ed25519_larka

# Публичный ключ (добавить на сервер)
C:\Users\HOME\.ssh\id_ed25519_larka.pub
```

**Содержимое публичного ключа:**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4+MpDwri5E13WHzq6hHT+Hfl/rbSZpWLUaGvmA6XnY larka-project-mcp
```

**Тип ключа:** ed25519
- Современный криптографический алгоритм
- Короткий (99 символов против 400+ для RSA)
- Безопасный и быстрый
- Без пароля (для автоматизации)

**Следующие шаги для активации MCP:**

1. **После деплоя сервера:**
   ```bash
   # Добавьте публичный ключ на сервер
   ssh deployer@your-server-ip
   mkdir -p ~/.ssh
   echo "ssh-ed25519 AAAAC3Nza..." >> ~/.ssh/authorized_keys
   chmod 600 ~/.ssh/authorized_keys
   chmod 700 ~/.ssh
   ```

2. **Настройте Claude Desktop:**
   - Откройте: `%APPDATA%\Claude\claude_desktop_config.json`
   - Скопируйте конфиг из `claude_desktop_config.example.json`
   - Замените `YOUR_IP` на IP вашего сервера
   - Перезапустите Claude Desktop

3. **После подключения я смогу:**
   ```bash
   # Деплоить код
   cd /var/www/larka && ./deploy.sh

   # Смотреть логи
   tail -f /var/www/larka/storage/logs/laravel.log

   # Проверять статус
   systemctl status nginx
   supervisorctl status

   # Выполнять миграции
   php artisan migrate
   ```

**Доступные MCP серверы:**

| MCP сервер | Назначение | Пакет |
|------------|-----------|-------|
| SSH | Удалённые команды | `@modelcontextprotocol/server-ssh` |
| PostgreSQL | Работа с БД | `@modelcontextprotocol/server-postgres` |
| GitHub | Issues, PR, Releases | `@modelcontextprotocol/server-github` |
| Docker | Управление контейнерами | `@modelcontextprotocol/server-docker` |

**Преимущества для разработки:**

- ✅ Деплой одной командой через чат
- ✅ Мониторинг сервера в реальном времени
- ✅ Быстрая отладка production проблем
- ✅ Работа с БД без внешних клиентов
- ✅ Управление GitHub из чата
- ✅ Автоматизация рутинных задач

**Безопасность:**

- ⚠️ Используйте отдельные ключи для разных проектов
- ⚠️ Не давайте root доступ (только deployer)
- ⚠️ Храните приватные ключи локально
- ⚠️ Никогда не коммитьте ключи в Git
- ⚠️ Используйте сильные пароли для БД

**Git:**
- Созданы 2 файла документации
- Сгенерированы SSH ключи
- Публичный ключ готов для добавления на сервер
- Коммит будет создан

---

### 9. Развертывание на Production сервере

**Дата:** 2025-10-11

**Цель:** Настроить и развернуть Laravel проект на production сервере с Ubuntu 22.04

**Информация о сервере:**
- **IP адрес:** 5.180.174.206
- **ОС:** Ubuntu 22.04.5 LTS (Jammy Jellyfish)
- **Hostname:** larka
- **RAM:** 1 GB
- **Диск:** 40 GB
- **SSH доступ:** `ssh larka` или `ssh root@5.180.174.206`

---

#### Этап 1: Установка базового ПО

**Создан:** [docs/scripts/server-setup.sh](scripts/server-setup.sh)

**Что устанавливается:**
- Nginx
- PHP 8.3 + расширения
- Composer
- Node.js 20 LTS + NPM
- PostgreSQL 15
- Supervisor (для фоновых задач)
- Certbot (для SSL)
- UFW (firewall)

**Выполнено:**
```bash
sudo bash /home/deployer/server-setup.sh
```

**Время выполнения:** ~5-10 минут

---

#### Этап 2: Обновление до PHP 8.4

**Создан:** [docs/scripts/install-php84.sh](scripts/install-php84.sh)

**Причина:** Для совместимости с локальной версией разработки (PHP 8.4.4)

**Что делает скрипт:**
1. Добавляет репозиторий PHP 8.4
2. Устанавливает PHP 8.4 и все расширения
3. Устанавливает PHP 8.4 как версию по умолчанию
4. Останавливает PHP 8.3 FPM
5. Запускает PHP 8.4 FPM

**Выполнено:**
```bash
sudo bash /home/deployer/install-php84.sh
```

**Результат:**
```
PHP 8.4.13 (cli) (built: Oct  1 2025 20:33:51) (NTS)
```

---

#### Этап 3: Настройка PostgreSQL базы данных

**Создан:** [docs/scripts/setup-database.sh](scripts/setup-database.sh)

**Что создается:**
- База данных: `larka_db`
- Пользователь: `larka_user`
- Пароль: генерируется автоматически
- Файл credentials: `/home/deployer/.env.database`

**Выполнено:**
```bash
sudo bash /home/deployer/setup-database.sh
```

**Конфигурация БД:**
```env
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=larka_db
DB_USERNAME=larka_user
DB_PASSWORD=tFPlAH7jjAYeHuzPJ2wjrLzLD
```

**Проверка подключения:**
```
PostgreSQL 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1) on x86_64-pc-linux-gnu
```

---

#### Этап 4: Развертывание Laravel проекта

**Создан:** [docs/scripts/deploy-initial.sh](scripts/deploy-initial.sh)

**Структура:**
```
/var/www/larka/       ← основная директория проекта
├── public/           ← document root для Nginx
├── storage/          ← логи, кеш, загрузки
├── .env              ← конфигурация окружения
└── ...
```

**Что делает скрипт:**
1. Создает директорию `/var/www/larka`
2. Клонирует проект из GitHub
3. Создает `.env` файл из `.env.example`
4. Добавляет настройки базы данных
5. Устанавливает Composer зависимости (`--no-dev`)
6. Генерирует APP_KEY
7. Устанавливает NPM зависимости
8. Собирает frontend (`npm run build`)
9. Настраивает права доступа (`www-data:www-data`)

**Выполнено:**
```bash
sudo bash /home/deployer/deploy-initial.sh
```

**Исправление конфигурации:**

**Создан:** [docs/scripts/fix-env.sh](scripts/fix-env.sh)

Проблема: настройки БД в `.env` были закомментированы

**Выполнено:**
```bash
sudo bash /home/deployer/fix-env.sh
```

**Запуск миграций:**
```bash
cd /var/www/larka
sudo -u www-data php artisan migrate --force
```

✅ Все таблицы созданы успешно

---

#### Этап 5: Настройка Nginx

**Создан:** [docs/scripts/nginx-config.conf](scripts/nginx-config.conf)

**Конфигурация:**
- Слушает порт 80 (HTTP)
- Server name: `_` (любой домен/IP)
- Document root: `/var/www/larka/public`
- PHP-FPM: `/var/run/php/php8.4-fpm.sock`
- Логи: `/var/log/nginx/larka-*.log`
- Max upload size: 20MB
- Кеширование статики (1 год)

**Создан:** [docs/scripts/setup-nginx.sh](scripts/setup-nginx.sh)

**Что делает скрипт:**
1. Копирует конфигурацию в `/etc/nginx/sites-available/larka`
2. Отключает default сайт
3. Создает симлинк в `/etc/nginx/sites-enabled/`
4. Проверяет конфигурацию (`nginx -t`)
5. Перезапускает Nginx

**Выполнено:**
```bash
# Загрузка конфигурации
scp scripts/nginx-config.conf larka:~/larka.conf

# Применение конфигурации
sudo bash /home/deployer/setup-nginx.sh
```

---

#### Итоговая конфигурация

**Пользователи и права:**
- Веб-сервер: `www-data`
- PHP-FPM: работает под `www-data`
- Nginx: работает под `www-data`
- Деплой: через `deployer` или `root`

**Права доступа:**
```bash
/var/www/larka/          → www-data:www-data (755)
/var/www/larka/storage/  → www-data:www-data (775)
/var/www/larka/bootstrap/cache/ → www-data:www-data (775)
```

**Запуск команд Artisan:**
```bash
# Всегда от имени www-data
sudo -u www-data php artisan <команда>
```

---

#### Доступ к сайту

**URL:** http://5.180.174.206

**Статус:** ✅ Сайт развернут и работает

**Логи:**
- Laravel: `/var/www/larka/storage/logs/laravel.log`
- Nginx access: `/var/log/nginx/larka-access.log`
- Nginx error: `/var/log/nginx/larka-error.log`
- PHP-FPM: `/var/log/php8.4-fpm.log`

---

#### Созданная документация

1. **[docs/SERVER-SETUP.md](SERVER-SETUP.md)** - Полное руководство по настройке сервера (200+ строк)
   - Пошаговая инструкция
   - Все команды с объяснениями
   - Troubleshooting
   - Обслуживание и обновления
   - Безопасность

2. **[docs/scripts/README.md](scripts/README.md)** - Описание всех deployment скриптов
   - Назначение каждого скрипта
   - Параметры и требования
   - Порядок выполнения
   - Примеры использования

---

#### Созданные скрипты развертывания

Все скрипты в папке `scripts/`:

1. **server-setup.sh** - Установка базового ПО (Nginx, PHP 8.3, PostgreSQL, etc.)
2. **install-php84.sh** - Обновление до PHP 8.4
3. **setup-database.sh** - Создание и настройка PostgreSQL БД
4. **deploy-initial.sh** - Первоначальное развертывание Laravel проекта
5. **fix-env.sh** - Исправление .env и прав доступа
6. **setup-nginx.sh** - Настройка Nginx конфигурации
7. **nginx-config.conf** - Конфигурационный файл Nginx

---

#### Следующие шаги (опционально)

**Для production использования:**

1. **Купить домен** и настроить DNS
   ```
   A запись: yourdomain.com → 5.180.174.206
   ```

2. **Настроить SSL сертификат:**
   ```bash
   # Обновить nginx-config.conf с доменом
   server_name yourdomain.com;

   # Получить SSL сертификат
   sudo certbot --nginx -d yourdomain.com
   ```

3. **Настроить автоматический деплой:**
   - GitHub Actions для CI/CD
   - Webhook для автоматического обновления

4. **Настроить мониторинг:**
   - Laravel Telescope для отладки
   - Логи и алерты

5. **Резервное копирование:**
   - Автоматический бэкап БД
   - Снапшоты сервера

---

**Git:**
- Созданы 7 скриптов в папке `scripts/`
- Созданы 2 файла документации
- Обновлён CHANGELOG
- Коммит будет создан

---

## Текущее состояние проекта

**Локальная разработка:**
- ✅ Laravel 12.33.0 + PHP 8.4.4
- ✅ Laravel Breeze + Inertia + Vue 3
- ✅ Email verification активирована
- ✅ MailHog для тестирования email
- ✅ Makefile для автоматизации
- ✅ Git repository: https://github.com/mmskazak/larka

**Production сервер:**
- ✅ Ubuntu 22.04 LTS (1GB RAM, 40GB диск)
- ✅ Nginx + PHP 8.4.13 + PostgreSQL 14.19
- ✅ Laravel проект развернут в `/var/www/larka`
- ✅ База данных настроена и миграции применены
- ✅ Сайт доступен: http://5.180.174.206
- ❌ SSL сертификат (требуется домен)
- ❌ MCP подключение (требуется добавить SSH ключ)

**Документация:**
- ✅ README.md - быстрый старт
- ✅ CHANGELOG.md - полная история изменений
- ✅ docs/DEPLOYMENT.md - руководство по деплою
- ✅ docs/SERVER-SETUP.md - настройка production сервера
- ✅ scripts/README.md - описание deployment скриптов

_Здесь будет документация дальнейших изменений..._
