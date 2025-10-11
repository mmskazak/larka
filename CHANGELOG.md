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

**Файл:** [package.json](package.json:13)
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

   **Файл:** [app/Models/User.php](app/Models/User.php:5-10)

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

   **Файл:** [routes/web.php](routes/web.php:19-25)

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

   **Файл:** [.env.example](.env.example:50-66)

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

1. **[docker-compose.yml](docker-compose.yml)** - Docker Compose конфигурация

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

2. **[Makefile](Makefile)** - Удобные команды для разработки

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

3. **Обновлён [.env.example](.env.example:50-74)**

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

1. **[Makefile](Makefile)** - Убраны все эмодзи, заменены на обычный текст

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

2. **[docker-compose.yml](docker-compose.yml)** - Удалено устаревшее поле `version`

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

## Следующие шаги

_Здесь будет документация дальнейших изменений..._
