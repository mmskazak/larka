# Локализация приложения (i18n)

Приложение поддерживает многоязычность с помощью библиотеки **Vue I18n**.

## Поддерживаемые языки

- 🇷🇺 **Русский** (по умолчанию)
- 🇬🇧 **English**

## Структура файлов

```
resources/js/
├── i18n.js                 # Конфигурация Vue I18n
└── locales/
    ├── en.json            # Английские переводы
    └── ru.json            # Русские переводы
```

## Файлы переводов

### Структура JSON файлов

```json
{
  "auth": {
    "login": "Войти",
    "email": "Электронная почта",
    "password": "Пароль"
  },
  "dashboard": {
    "title": "Панель управления"
  },
  "profile": {
    "title": "Профиль"
  }
}
```

## Использование в компонентах

### В template

```vue
<template>
  <!-- Простой перевод -->
  <h1>{{ $t('dashboard.title') }}</h1>

  <!-- В атрибутах -->
  <Head :title="$t('dashboard.title')" />
  <InputLabel :value="$t('auth.email')" />
</template>
```

### В script (Composition API)

```vue
<script setup>
import { useI18n } from 'vue-i18n';

const { t, locale } = useI18n();

// Использование
console.log(t('auth.login'));

// Смена языка
locale.value = 'en';
</script>
```

## Компонент переключения языка

Компонент `LanguageSwitcher.vue` предоставляет визуальный интерфейс для смены языка:

```vue
<template>
  <LanguageSwitcher />
</template>

<script setup>
import LanguageSwitcher from '@/Components/LanguageSwitcher.vue';
</script>
```

### Особенности компонента

- Сохраняет выбранный язык в `localStorage`
- Поддержка темной темы
- Выпадающий список с доступными языками
- Автоматическое определение текущего языка

## Добавление нового языка

### 1. Создайте файл перевода

```bash
# Создайте новый файл, например для украинского языка
touch resources/js/locales/uk.json
```

### 2. Добавьте переводы

```json
{
  "auth": {
    "login": "Увійти",
    "email": "Електронна пошта"
  }
}
```

### 3. Зарегистрируйте в i18n.js

```javascript
import uk from './locales/uk.json';

const i18n = createI18n({
    legacy: false,
    locale: localStorage.getItem('locale') || 'ru',
    fallbackLocale: 'en',
    messages: {
        en,
        ru,
        uk, // Добавьте новый язык
    },
});
```

### 4. Добавьте в LanguageSwitcher.vue

```javascript
const languages = [
    { code: 'ru', name: 'Русский' },
    { code: 'en', name: 'English' },
    { code: 'uk', name: 'Українська' }, // Добавьте в список
];
```

## Добавление новых переводов

### 1. Добавьте ключ в оба языка

**ru.json:**
```json
{
  "common": {
    "save": "Сохранить",
    "cancel": "Отмена",
    "delete": "Удалить",
    "new_key": "Новый перевод" // Добавьте новый ключ
  }
}
```

**en.json:**
```json
{
  "common": {
    "save": "Save",
    "cancel": "Cancel",
    "delete": "Delete",
    "new_key": "New translation" // То же самое для английского
  }
}
```

### 2. Используйте в компонентах

```vue
<template>
  <button>{{ $t('common.new_key') }}</button>
</template>
```

## Переводы с параметрами

### В файле перевода

```json
{
  "welcome": {
    "greeting": "Привет, {name}!",
    "message": "У вас {count} новых сообщений"
  }
}
```

### Использование

```vue
<template>
  <p>{{ $t('welcome.greeting', { name: 'Иван' }) }}</p>
  <p>{{ $t('welcome.message', { count: 5 }) }}</p>
</template>
```

## Плюрализация

### В файле перевода

```json
{
  "notifications": {
    "count": "Нет уведомлений | {n} уведомление | {n} уведомления | {n} уведомлений"
  }
}
```

### Использование

```vue
<template>
  <p>{{ $tc('notifications.count', 0) }}</p>  <!-- Нет уведомлений -->
  <p>{{ $tc('notifications.count', 1) }}</p>  <!-- 1 уведомление -->
  <p>{{ $tc('notifications.count', 5) }}</p>  <!-- 5 уведомлений -->
</template>
```

## Настройки по умолчанию

### Язык по умолчанию

Изменяется в файле `resources/js/i18n.js`:

```javascript
const i18n = createI18n({
    locale: localStorage.getItem('locale') || 'ru', // Измените 'ru' на нужный
    fallbackLocale: 'en',
    // ...
});
```

### Fallback язык

Если перевод не найден, используется fallback язык (по умолчанию English):

```javascript
fallbackLocale: 'en', // Измените на нужный
```

## Отладка

### Проверка текущего языка

```vue
<script setup>
import { useI18n } from 'vue-i18n';

const { locale } = useI18n();
console.log('Current locale:', locale.value);
</script>
```

### Проверка всех сообщений

```vue
<script setup>
import { useI18n } from 'vue-i18n';

const { messages } = useI18n();
console.log('All messages:', messages.value);
</script>
```

## Best Practices

1. **Структурируйте переводы по разделам:**
   ```json
   {
     "auth": {...},
     "dashboard": {...},
     "profile": {...}
   }
   ```

2. **Используйте понятные ключи:**
   ```javascript
   // ✅ Хорошо
   $t('auth.forgot_password')

   // ❌ Плохо
   $t('fp')
   ```

3. **Держите файлы синхронизированными:**
   - Все языки должны иметь одинаковую структуру ключей
   - Используйте комментарии для пояснений

4. **Избегайте хардкода текста:**
   ```vue
   <!-- ❌ Плохо -->
   <button>Войти</button>

   <!-- ✅ Хорошо -->
   <button>{{ $t('auth.login') }}</button>
   ```

## Полезные ссылки

- [Vue I18n документация](https://vue-i18n.intlify.dev/)
- [Composition API](https://vue-i18n.intlify.dev/guide/advanced/composition.html)
- [Плюрализация](https://vue-i18n.intlify.dev/guide/essentials/pluralization.html)
- [Форматирование](https://vue-i18n.intlify.dev/guide/essentials/number.html)
