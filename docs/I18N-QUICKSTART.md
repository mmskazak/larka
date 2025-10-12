# 🚀 i18n Quick Start

Быстрый старт для работы с локализацией в Larka.

## 📦 Что уже работает

✅ **Русский и Английский языки**
✅ **Переключатель в UI** (правый верхний угол)
✅ **Автосохранение выбора**
✅ **Все страницы локализованы**
✅ **Laravel валидация на русском**

## 🎯 Как использовать

### В Vue компонентах

```vue
<template>
  <!-- Простой текст -->
  <h1>{{ $t('dashboard.title') }}</h1>

  <!-- В атрибутах -->
  <button :title="$t('common.save')">
    {{ $t('common.save') }}
  </button>
</template>
```

### Смена языка

Кликните на **[Русский ▼]** в правом верхнем углу интерфейса.

## 📝 Добавить новый перевод

### 1. Откройте оба файла переводов

```bash
resources/js/locales/ru.json
resources/js/locales/en.json
```

### 2. Добавьте ключ в оба файла

**ru.json:**
```json
{
  "common": {
    "my_new_key": "Мой новый текст"
  }
}
```

**en.json:**
```json
{
  "common": {
    "my_new_key": "My new text"
  }
}
```

### 3. Используйте в компоненте

```vue
<p>{{ $t('common.my_new_key') }}</p>
```

### 4. Пересоберите frontend

```bash
npm run build
```

## 🌍 Структура ключей

```
auth.*          - Аутентификация (вход, регистрация)
dashboard.*     - Панель управления
profile.*       - Профиль пользователя
common.*        - Общие элементы (кнопки, и т.д.)
auth_extended.* - Расширенные тексты для auth
```

## 🔧 Где искать переводы

**Frontend:**
- `resources/js/locales/ru.json`
- `resources/js/locales/en.json`

**Backend:**
- `lang/ru/*.php`
- `lang/en/*.php`

## 📚 Полная документация

- **[I18N-STARTERKIT.md](./I18N-STARTERKIT.md)** - Полное руководство
- **[LOCALIZATION.md](./LOCALIZATION.md)** - Детальная документация

## 🆘 Проблемы?

### Переводы не отображаются
```bash
# Очистите кэш и пересоберите
npm run build
php artisan config:clear
```

### Язык не сохраняется
```javascript
// В консоли браузера
localStorage.setItem('locale', 'ru');
location.reload();
```

### Laravel на английском
```bash
# Проверьте config/app.php
'locale' => 'ru'  # Должно быть 'ru'

# Очистите кэш
php artisan config:clear
```

---

**Быстрый доступ к файлам:**
- Переводы: `resources/js/locales/`
- Переключатель: `resources/js/Components/LanguageSwitcher.vue`
- Конфиг: `resources/js/i18n.js`
