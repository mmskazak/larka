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

## Следующие шаги

_Здесь будет документация дальнейших изменений..._
