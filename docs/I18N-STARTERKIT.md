# 🌍 Larka I18n StarterKit

Полное руководство по системе интернационализации (i18n) в проекте Larka.

## 📋 Содержание

1. [Обзор системы](#обзор-системы)
2. [Архитектура](#архитектура)
3. [Установленные компоненты](#установленные-компоненты)
4. [Структура файлов](#структура-файлов)
5. [Использование](#использование)
6. [Добавление нового языка](#добавление-нового-языка)
7. [Добавление новых переводов](#добавление-новых-переводов)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## Обзор системы

Проект **Larka** реализует полную двухуровневую систему интернационализации:

### Frontend (Vue.js)
- **Библиотека**: Vue I18n 9
- **Языки**: Русский (по умолчанию), Английский
- **Хранилище**: JSON файлы в `resources/js/locales/`
- **Переключение**: Компонент LanguageSwitcher в UI
- **Персистентность**: localStorage браузера

### Backend (Laravel)
- **Система**: Встроенная локализация Laravel
- **Языки**: Русский (по умолчанию), Английский
- **Хранилище**: PHP файлы в `lang/`
- **Использование**: Валидация, Email, Сообщения

---

## Архитектура

```
┌─────────────────────────────────────────────────────────────┐
│                    ПОЛЬЗОВАТЕЛЬСКИЙ ИНТЕРФЕЙС                │
│  ┌────────────────────────────────────────────────────┐    │
│  │  LanguageSwitcher Component                         │    │
│  │  [Русский ▼]  [English ▼]                          │    │
│  └─────────────────┬───────────────────────────────────┘    │
│                    │                                         │
│                    ▼                                         │
│  ┌─────────────────────────────────────────────────────┐   │
│  │           Vue I18n (Composition API)                 │   │
│  │  - locale.value = 'ru' | 'en'                       │   │
│  │  - $t('key')                                         │   │
│  │  - Реактивное обновление всех компонентов           │   │
│  └─────────────────┬───────────────────────────────────┘   │
└────────────────────┼──────────────────────────────────────┘
                     │
    ┌────────────────┴────────────────┐
    │                                  │
    ▼                                  ▼
┌─────────────────────┐    ┌──────────────────────┐
│  resources/js/      │    │     Laravel          │
│  locales/           │    │     Backend          │
│                     │    │                      │
│  ├─ en.json        │    │  ├─ lang/en/         │
│  └─ ru.json        │    │  └─ lang/ru/         │
│                     │    │                      │
│  Frontend тексты    │    │  Валидация, Email   │
└─────────────────────┘    └──────────────────────┘
```

---

## Установленные компоненты

### 1. NPM пакеты
```json
{
  "vue-i18n": "^9.x"
}
```

### 2. Конфигурационные файлы

#### `resources/js/i18n.js`
```javascript
import { createI18n } from 'vue-i18n';
import en from './locales/en.json';
import ru from './locales/ru.json';

const i18n = createI18n({
    legacy: false,                              // Composition API
    locale: localStorage.getItem('locale') || 'ru',  // Русский по умолчанию
    fallbackLocale: 'en',                       // Английский как запасной
    messages: { en, ru },
});

export default i18n;
```

#### `resources/js/app.js`
```javascript
import i18n from './i18n';

createInertiaApp({
    setup({ el, App, props, plugin }) {
        return createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(ZiggyVue)
            .use(i18n)  // ← Интеграция i18n
            .mount(el);
    },
});
```

### 3. Laravel конфигурация

#### `config/app.php`
```php
'locale' => env('APP_LOCALE', 'ru'),              // Русский по умолчанию
'fallback_locale' => env('APP_FALLBACK_LOCALE', 'en'),
'faker_locale' => env('APP_FAKER_LOCALE', 'ru_RU'),
```

---

## Структура файлов

```
larka/
├── resources/js/
│   ├── i18n.js                      # Конфигурация Vue I18n
│   ├── locales/
│   │   ├── en.json                  # Английские переводы (Frontend)
│   │   └── ru.json                  # Русские переводы (Frontend)
│   │
│   ├── Components/
│   │   └── LanguageSwitcher.vue     # Переключатель языков
│   │
│   ├── Pages/
│   │   ├── Auth/
│   │   │   ├── Login.vue           # ✅ Локализовано
│   │   │   ├── Register.vue        # ✅ Локализовано
│   │   │   ├── ForgotPassword.vue  # ✅ Локализовано
│   │   │   ├── ResetPassword.vue   # ✅ Локализовано
│   │   │   ├── VerifyEmail.vue     # ✅ Локализовано
│   │   │   └── ConfirmPassword.vue # ✅ Локализовано
│   │   │
│   │   ├── Dashboard.vue           # ✅ Локализовано
│   │   │
│   │   └── Profile/
│   │       ├── Edit.vue            # ✅ Локализовано
│   │       └── Partials/
│   │           ├── UpdateProfileInformationForm.vue  # ✅ Локализовано
│   │           ├── UpdatePasswordForm.vue            # ✅ Локализовано
│   │           └── DeleteUserForm.vue                # ✅ Локализовано
│   │
│   └── Layouts/
│       └── AuthenticatedLayout.vue  # ✅ Локализовано (навигация)
│
├── lang/
│   ├── en/                          # Английские переводы (Backend)
│   │   ├── auth.php
│   │   ├── pagination.php
│   │   ├── passwords.php
│   │   └── validation.php
│   │
│   └── ru/                          # Русские переводы (Backend)
│       ├── auth.php
│       ├── pagination.php
│       ├── passwords.php
│       └── validation.php
│
└── docs/
    ├── LOCALIZATION.md              # Руководство по локализации
    └── I18N-STARTERKIT.md           # Этот файл
```

---

## Использование

### Frontend (Vue компоненты)

#### В template
```vue
<template>
  <!-- Простой перевод -->
  <h1>{{ $t('dashboard.title') }}</h1>

  <!-- В атрибутах -->
  <Head :title="$t('dashboard.title')" />
  <InputLabel :value="$t('auth.email')" />

  <!-- С интерполяцией -->
  <p>{{ $t('welcome.greeting', { name: userName }) }}</p>
</template>
```

#### В script (Composition API)
```vue
<script setup>
import { useI18n } from 'vue-i18n';

const { t, locale } = useI18n();

// Использование перевода
console.log(t('auth.login'));

// Смена языка
const changeLanguage = (lang) => {
    locale.value = lang;
    localStorage.setItem('locale', lang);
};
</script>
```

### Backend (Laravel)

#### В контроллерах
```php
return back()->with('status', __('passwords.sent'));
```

#### В Blade шаблонах (если используются)
```blade
{{ __('auth.failed') }}
```

#### Валидация (автоматически)
```php
$request->validate([
    'email' => 'required|email',  // Ошибки автоматически на русском
]);
```

---

## Добавление нового языка

### Пример: Добавление украинского языка

#### 1. Frontend (Vue I18n)

**Создайте файл перевода:**
```bash
touch resources/js/locales/uk.json
```

**Добавьте переводы:**
```json
{
  "auth": {
    "login": "Увійти",
    "email": "Електронна пошта"
  },
  "dashboard": {
    "title": "Панель керування"
  }
}
```

**Зарегистрируйте в `resources/js/i18n.js`:**
```javascript
import uk from './locales/uk.json';

const i18n = createI18n({
    messages: {
        en,
        ru,
        uk,  // ← Добавьте новый язык
    },
});
```

**Добавьте в `LanguageSwitcher.vue`:**
```javascript
const languages = [
    { code: 'ru', name: 'Русский' },
    { code: 'en', name: 'English' },
    { code: 'uk', name: 'Українська' },  // ← Добавьте
];
```

#### 2. Backend (Laravel)

**Создайте папку:**
```bash
mkdir lang/uk
```

**Скопируйте файлы:**
```bash
cp lang/ru/*.php lang/uk/
```

**Переведите содержимое файлов** в `lang/uk/`

---

## Добавление новых переводов

### 1. Определите ключ

Используйте иерархическую структуру:
```
раздел.подраздел.ключ
```

Примеры:
```
auth.login
profile.update_password
common.save
```

### 2. Добавьте в оба языка

**resources/js/locales/ru.json:**
```json
{
  "auth": {
    "two_factor": "Двухфакторная аутентификация"
  }
}
```

**resources/js/locales/en.json:**
```json
{
  "auth": {
    "two_factor": "Two-Factor Authentication"
  }
}
```

### 3. Используйте в компонентах

```vue
<h2>{{ $t('auth.two_factor') }}</h2>
```

---

## Компонент LanguageSwitcher

### Расположение
`resources/js/Components/LanguageSwitcher.vue`

### Особенности

✅ **Реактивное переключение** - все компоненты обновляются мгновенно
✅ **Персистентность** - выбор сохраняется в localStorage
✅ **Темная тема** - поддержка dark mode
✅ **Доступность** - клавиатурная навигация

### Интеграция

Уже интегрирован в:
- `resources/js/Layouts/AuthenticatedLayout.vue` (для авторизованных пользователей)

Для добавления в другие layouts:
```vue
<script setup>
import LanguageSwitcher from '@/Components/LanguageSwitcher.vue';
</script>

<template>
  <div class="header">
    <LanguageSwitcher />
  </div>
</template>
```

---

## Best Practices

### ✅ Делайте

1. **Структурируйте переводы по разделам**
   ```json
   {
     "auth": {...},
     "dashboard": {...},
     "profile": {...}
   }
   ```

2. **Используйте понятные ключи**
   ```javascript
   // ✅ Хорошо
   $t('auth.forgot_password')

   // ❌ Плохо
   $t('fp')
   ```

3. **Синхронизируйте все языки**
   - Одинаковая структура ключей
   - Все ключи во всех языках

4. **Избегайте хардкода**
   ```vue
   <!-- ❌ Плохо -->
   <button>Войти</button>

   <!-- ✅ Хорошо -->
   <button>{{ $t('auth.login') }}</button>
   ```

5. **Используйте интерполяцию для динамических значений**
   ```javascript
   $t('welcome.greeting', { name: 'Иван' })
   ```

### ❌ Не делайте

1. Не смешивайте языки в одном компоненте
2. Не дублируйте переводы
3. Не используйте переводы для логики приложения
4. Не забывайте про pluralization для чисел

---

## Переводы

### Frontend (resources/js/locales/)

#### Структура ru.json / en.json
```json
{
  "auth": {
    "login": "...",
    "register": "...",
    "logout": "...",
    "email": "...",
    "password": "...",
    "confirm_password": "...",
    "remember_me": "...",
    "forgot_password": "...",
    "reset_password": "...",
    "send_reset_link": "...",
    "verify_email": "...",
    "already_registered": "...",
    "new_password": "...",
    "verify_email_sent": "...",
    "verify_email_text": "...",
    "resend_verification": "...",
    "confirm_password_text": "..."
  },
  "dashboard": {
    "title": "...",
    "logged_in": "..."
  },
  "profile": {
    "title": "...",
    "edit": "...",
    "information": "...",
    "information_text": "...",
    "update_password": "...",
    "update_password_text": "...",
    "delete_account": "...",
    "delete_account_text": "...",
    "delete_confirm": "...",
    "delete_confirm_text": "...",
    "save": "...",
    "saved": "...",
    "name": "...",
    "current_password": "...",
    "unverified_email": "...",
    "click_to_resend": "..."
  },
  "common": {
    "cancel": "...",
    "delete": "...",
    "confirm": "...",
    "close": "...",
    "no_problem": "..."
  },
  "auth_extended": {
    "forgot_password_text": "..."
  }
}
```

### Backend (lang/ru/)

#### auth.php
- `failed` - Неверные учетные данные
- `password` - Неверный пароль
- `throttle` - Ограничение попыток входа

#### passwords.php
- `reset` - Пароль сброшен
- `sent` - Ссылка отправлена
- `throttled` - Подождите перед повтором
- `token` - Токен недействителен
- `user` - Пользователь не найден

#### validation.php
Полный набор правил валидации на русском языке

---

## Troubleshooting

### Проблема: Переводы не отображаются

**Решение 1: Проверьте наличие ключа**
```javascript
console.log(i18n.global.messages.value);
```

**Решение 2: Очистите кэш браузера**
```bash
Ctrl+Shift+R  # Жесткая перезагрузка
```

**Решение 3: Пересоберите frontend**
```bash
npm run build
```

### Проблема: Язык не сохраняется

**Проверьте localStorage:**
```javascript
console.log(localStorage.getItem('locale'));
```

**Очистите и установите заново:**
```javascript
localStorage.removeItem('locale');
localStorage.setItem('locale', 'ru');
location.reload();
```

### Проблема: Laravel валидация на английском

**Проверьте config/app.php:**
```php
'locale' => 'ru',  // Должно быть 'ru'
```

**Очистите кэш конфигурации:**
```bash
php artisan config:clear
php artisan config:cache
```

### Проблема: Email уведомления на английском

Laravel использует язык из `config/app.php`. Убедитесь что:
```php
'locale' => 'ru',
```

И файлы переводов существуют в `lang/ru/`

---

## Статистика реализации

### Локализовано компонентов: 15/15 (100%)

#### ✅ Auth (6/6)
- [x] Login
- [x] Register
- [x] ForgotPassword
- [x] ResetPassword
- [x] VerifyEmail
- [x] ConfirmPassword

#### ✅ Profile (4/4)
- [x] Edit
- [x] UpdateProfileInformationForm
- [x] UpdatePasswordForm
- [x] DeleteUserForm

#### ✅ Other (5/5)
- [x] Dashboard
- [x] AuthenticatedLayout
- [x] LanguageSwitcher
- [x] Backend валидация
- [x] Backend email

---

## Полезные ссылки

- [Vue I18n документация](https://vue-i18n.intlify.dev/)
- [Laravel Localization](https://laravel.com/docs/localization)
- [LOCALIZATION.md](./LOCALIZATION.md) - Детальное руководство
- [README.md](../README.md) - Главная документация проекта

---

## Следующие шаги

### Возможные улучшения:

1. **Добавить больше языков**
   - Украинский
   - Немецкий
   - Французский

2. **Локализация дат и времени**
   ```javascript
   import { useI18n } from 'vue-i18n';
   const { d, n } = useI18n();

   d(new Date(), 'long')  // Форматирование даты
   n(1000, 'currency')    // Форматирование чисел/валюты
   ```

3. **Плюрализация**
   ```javascript
   $t('notifications.count', { count: 5 })
   // "У вас 5 уведомлений"
   ```

4. **RTL языки**
   - Арабский
   - Иврит

5. **Автоопределение языка**
   ```javascript
   const browserLang = navigator.language.split('-')[0];
   const initialLocale = localStorage.getItem('locale') ||
                        (browserLang === 'ru' ? 'ru' : 'en');
   ```

---

**Автор**: Claude AI
**Дата создания**: 2025-10-12
**Версия**: 1.0
**Проект**: Larka - Laravel 12 + Vue 3 + Inertia.js
