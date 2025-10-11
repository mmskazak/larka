# Настройка MCP серверов для проекта Larka

## Что такое MCP?

**MCP (Model Context Protocol)** - это протокол, который позволяет Claude подключаться к внешним инструментам и сервисам.

**Простыми словами:**
- Без MCP: Claude работает только с файлами проекта
- С MCP: Claude может подключаться к серверам, базам данных, GitHub и т.д.

**Преимущества для разработки:**
- 🚀 Деплой прямо из чата
- 📊 Мониторинг production сервера
- 🔍 Просмотр логов на удалённом сервере
- 💾 Работа с базой данных напрямую
- 🐙 Управление GitHub (issues, PR, releases)

---

## SSH MCP Server

### Что он даёт?

SSH MCP позволяет Claude:
- Подключаться к удалённым серверам
- Выполнять команды на сервере
- Читать и редактировать файлы
- Просматривать логи
- Делать деплой

### Установка

#### Шаг 1: Создание SSH ключа

**Ключ уже создан для этого проекта:**

```bash
# Путь к приватному ключу
C:\Users\HOME\.ssh\id_ed25519_larka

# Публичный ключ (нужно добавить на сервер)
C:\Users\HOME\.ssh\id_ed25519_larka.pub
```

**Содержимое публичного ключа:**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC4+MpDwri5E13WHzq6hHT+Hfl/rbSZpWLUaGvmA6XnY larka-project-mcp
```

**Если нужно создать новый ключ:**
```bash
ssh-keygen -t ed25519 -C "ваш-комментарий" -f ~/.ssh/id_ed25519_название -N ""
```

**Параметры команды:**
- `-t ed25519` - тип ключа (современный, безопасный)
- `-C "комментарий"` - описание ключа
- `-f путь` - имя файла
- `-N ""` - без пароля (для автоматизации)

#### Шаг 2: Добавление ключа на сервер

**Когда у вас будет production сервер:**

```bash
# Вариант 1: Автоматически (если есть доступ по паролю)
ssh-copy-id -i ~/.ssh/id_ed25519_larka.pub deployer@your-server-ip

# Вариант 2: Вручную
# 1. Скопируйте содержимое ~/.ssh/id_ed25519_larka.pub
# 2. На сервере:
ssh deployer@your-server-ip
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Вставьте скопированный ключ
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

#### Шаг 3: Настройка Claude Desktop

**Откройте конфиг файл:**

**Windows:**
```
%APPDATA%\Claude\claude_desktop_config.json
```

**Mac/Linux:**
```
~/Library/Application Support/Claude/claude_desktop_config.json
```

**Добавьте конфигурацию:**

```json
{
  "mcpServers": {
    "larka-production": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-ssh",
        "deployer@YOUR_SERVER_IP"
      ],
      "env": {
        "SSH_KEY_PATH": "C:\\Users\\HOME\\.ssh\\id_ed25519_larka"
      }
    }
  }
}
```

**Объяснение конфигурации:**

- `"larka-production"` - имя MCP сервера (любое)
- `"command": "npx"` - запуск через npx (Node Package eXecute)
- `"args"` - аргументы:
  - `-y` - автоматически подтверждать установку
  - `@modelcontextprotocol/server-ssh` - пакет SSH MCP
  - `"deployer@YOUR_SERVER_IP"` - пользователь и IP сервера
- `"env"` - переменные окружения:
  - `SSH_KEY_PATH` - путь к приватному ключу

**⚠️ Важно для Windows:**
- Используйте двойные обратные слэши: `\\`
- Или прямые слэши: `/`
- НЕ используйте одинарные `\`

#### Шаг 4: Перезапуск Claude Desktop

После изменения конфига:
1. Полностью закройте Claude Desktop
2. Откройте снова
3. MCP сервер подключится автоматически

---

## Пример использования SSH MCP

После настройки я смогу:

```bash
# Проверить статус приложения
systemctl status larka

# Посмотреть последние логи
tail -f /var/www/larka/storage/logs/laravel.log

# Выполнить деплой
cd /var/www/larka
git pull origin main
composer install --no-dev
npm run build
php artisan migrate --force
php artisan config:cache

# Проверить очереди
supervisorctl status larka-worker:*

# Мониторинг ресурсов
df -h          # Диск
free -h        # RAM
top -bn1       # CPU
```

---

## Другие полезные MCP серверы

### PostgreSQL MCP

**Для работы с production базой данных:**

```json
{
  "mcpServers": {
    "larka-database": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://larka_user:password@your-server-ip/larka"
      ]
    }
  }
}
```

**Возможности:**
- Выполнять SQL запросы
- Просматривать структуру таблиц
- Анализировать данные
- Делать бэкапы

### GitHub MCP

**Для работы с репозиторием:**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_ваш_токен"
      }
    }
  }
}
```

**Как получить GitHub токен:**
1. GitHub → Settings → Developer settings
2. Personal access tokens → Tokens (classic)
3. Generate new token
4. Выберите scope: `repo`, `read:org`, `read:user`

**Возможности:**
- Создавать и закрывать Issues
- Создавать Pull Requests
- Просматривать код
- Управлять Releases

### Docker MCP (локально)

**Для работы с контейнерами:**

```json
{
  "mcpServers": {
    "docker": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-docker"]
    }
  }
}
```

**Возможности:**
- Управлять контейнерами
- Просматривать логи
- Создавать образы
- Работать с docker-compose

---

## Полная конфигурация для проекта Larka

**Когда всё будет готово:**

```json
{
  "mcpServers": {
    "larka-production": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-ssh",
        "deployer@production-ip"
      ],
      "env": {
        "SSH_KEY_PATH": "C:\\Users\\HOME\\.ssh\\id_ed25519_larka"
      }
    },
    "larka-staging": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-ssh",
        "deployer@staging-ip"
      ],
      "env": {
        "SSH_KEY_PATH": "C:\\Users\\HOME\\.ssh\\id_ed25519_larka"
      }
    },
    "larka-database": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://larka_user:password@production-ip/larka"
      ]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "ghp_your_token"
      }
    },
    "docker-local": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-docker"]
    }
  }
}
```

---

## Безопасность

### ✅ Правильно:
- Использовать отдельные SSH ключи для разных проектов
- Использовать пользователя `deployer` (не root)
- Хранить приватные ключи локально
- Использовать сложные пароли для БД

### ❌ Неправильно:
- Давать root доступ
- Хранить ключи в репозитории
- Использовать один ключ для всех серверов
- Отключать firewall

---

## Troubleshooting

### MCP сервер не подключается

**Проверьте:**
```bash
# Проверка SSH подключения вручную
ssh -i ~/.ssh/id_ed25519_larka deployer@your-server-ip

# Проверка прав на ключ (должен быть 600)
ls -l ~/.ssh/id_ed25519_larka
chmod 600 ~/.ssh/id_ed25519_larka
```

### npx не найден

**Установите Node.js:**
- Windows: https://nodejs.org/
- Или используйте: `winget install OpenJS.NodeJS`

### Ключ не работает

**Проверьте на сервере:**
```bash
# На сервере
cat ~/.ssh/authorized_keys
# Должен содержать ваш публичный ключ

# Проверьте права
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

---

## Дополнительные ресурсы

- [MCP Documentation](https://modelcontextprotocol.io/)
- [SSH MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/ssh)
- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/github)
- [PostgreSQL MCP Server](https://github.com/modelcontextprotocol/servers/tree/main/src/postgres)

---

## Следующие шаги

1. **Сейчас:** SSH ключ создан и готов
2. **После деплоя сервера:** Добавьте ключ на сервер
3. **Настройте MCP:** Обновите конфиг Claude Desktop
4. **Перезапустите:** Claude Desktop для применения изменений
5. **Тестируйте:** Попросите меня выполнить команду на сервере

**Когда настроите - скажите, и я помогу с деплоем и мониторингом прямо через SSH MCP!**
