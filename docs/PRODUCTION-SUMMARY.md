# Production Deployment - Итоговая сводка

Полная сводка развертывания проекта Larka на production сервере.

**Дата:** 2025-10-11

---

## 🎯 Что было сделано

### 1. Развёрнут проект на production сервере

**Информация о сервере:**
- **IP адрес:** 5.180.174.206
- **Hostname:** larka
- **ОС:** Ubuntu 22.04.5 LTS (Jammy Jellyfish)
- **RAM:** 1 GB
- **Диск:** 40 GB
- **SSH доступ:** `ssh larka` или `ssh root@5.180.174.206`

**Установленный стек технологий:**
- ✅ **Nginx** - веб-сервер
- ✅ **PHP 8.4.13** - совместимо с локальной версией (8.4.4)
- ✅ **PostgreSQL 14.19** - база данных
- ✅ **Composer** - менеджер пакетов PHP
- ✅ **Node.js 20 LTS + NPM** - для frontend сборки
- ✅ **Supervisor** - для фоновых задач
- ✅ **Certbot** - для SSL (готов к использованию)
- ✅ **UFW** - firewall (порты 22, 80, 443)

**Статус проекта:**
- ✅ Проект развёрнут в `/var/www/larka`
- ✅ База данных `larka_db` создана и настроена
- ✅ Пользователь БД: `larka_user`
- ✅ Миграции применены (users, cache, jobs, sessions)
- ✅ Frontend собран (Vite + Vue 3)
- ✅ Права доступа настроены (www-data:www-data)
- ✅ Nginx сконфигурирован и запущен
- ✅ **Сайт работает:** http://5.180.174.206

---

### 2. Созданы оптимизированные deployment скрипты

**Эволюция скриптов:**
- **Было:** 7 разрозненных скриптов в папке `scripts/`
- **Стало:** 5 оптимизированных скриптов в папке `docs/scripts/`
- **Улучшение:** сокращение на 29%, консолидация логики

**Финальная структура `docs/scripts/`:**

#### 1. server-setup.sh (3.4 KB)
**Объединён с:** install-php84.sh

**Что делает:**
- Обновление системы Ubuntu
- Установка базовых пакетов (curl, wget, git, unzip)
- Установка Nginx
- Установка PHP 8.4 + все расширения (сразу 8.4, не через 8.3)
- Установка Composer
- Установка Node.js 20 LTS + NPM
- Установка PostgreSQL 15
- Настройка UFW firewall
- Проверка всех установленных версий

**Использование:**
```bash
sudo bash server-setup.sh
```

**Время выполнения:** ~5-10 минут

---

#### 2. setup-database.sh (2.3 KB)
**Изменения:** без изменений

**Что делает:**
- Создаёт базу данных `larka_db`
- Создаёт пользователя `larka_user`
- Генерирует безопасный пароль (32 символа)
- Выдаёт все права доступа
- Сохраняет credentials в `/home/deployer/.env.database`

**Использование:**
```bash
sudo bash setup-database.sh
```

**Вывод:**
```
База данных: larka_db
Пользователь: larka_user
Пароль: tFPlAH7jjAYeHuzPJ2wjrLzLD
Конфигурация сохранена в: /home/deployer/.env.database
```

---

#### 3. deploy-project.sh (4.5 KB)
**Объединён с:** fix-env.sh

**Что делает:**
1. Создаёт директорию `/var/www/larka`
2. Клонирует проект из GitHub
3. Создаёт/обновляет `.env` файл
4. Автоматически добавляет настройки БД (с раскомментированием)
5. Устанавливает Composer зависимости (`--no-dev --optimize-autoloader`)
6. Генерирует `APP_KEY`
7. Устанавливает NPM зависимости
8. Собирает frontend (`npm run build`)
9. Настраивает права доступа (www-data:www-data)
10. Очищает кеш
11. **Запускает миграции** (от www-data)

**Использование:**
```bash
sudo bash deploy-project.sh
```

**Требования:**
- Выполнен `setup-database.sh`
- Файл `/home/deployer/.env.database` существует

---

#### 4. setup-nginx.sh (1.4 KB)
**Изменения:** без изменений

**Что делает:**
- Копирует конфигурацию в `/etc/nginx/sites-available/larka`
- Отключает default сайт
- Активирует сайт larka (symlink)
- Проверяет конфигурацию (`nginx -t`)
- Перезапускает Nginx

**Использование:**
```bash
sudo bash setup-nginx.sh
```

---

#### 5. nginx-config.conf (1.1 KB)
**Изменения:** без изменений

**Конфигурация:**
- Порт 80 (HTTP)
- Server name: `_` (любой IP/домен)
- Document root: `/var/www/larka/public`
- PHP-FPM socket: `/var/run/php/php8.4-fpm.sock`
- Логи: `/var/log/nginx/larka-access.log` и `larka-error.log`
- Max upload: 20MB
- Кеширование статики: 1 год
- Защита скрытых файлов

---

#### 6. README.md (14.2 KB)
**Новый файл** - комплексное руководство

**Содержание:**
- Описание всех скриптов
- Быстрый старт (10-15 минут)
- Обновление проекта
- Конфигурация и переменные
- Безопасность и права доступа
- Troubleshooting
- Проверка состояния системы
- Логирование
- Следующие шаги (SSL, CI/CD, мониторинг, бэкапы)

---

### 3. Создана комплексная документация

**Новые файлы документации:**

#### docs/SERVER-SETUP.md (700+ строк)
**Полное руководство по настройке production сервера**

**Разделы:**
1. Информация о сервере
2. Подготовка сервера (установка ПО)
3. Установка PHP 8.4
4. Настройка PostgreSQL
5. Развертывание Laravel проекта
6. Настройка Nginx
7. Доступ к сайту
8. Структура проекта на сервере
9. Пользователи и права
10. Обслуживание (логи, кеш, перезапуск)
11. Обновление проекта (manual + автоматический скрипт)
12. Безопасность (firewall, обновления, бэкапы)
13. Troubleshooting
14. Следующие шаги (домен, SSL, CI/CD, мониторинг)

#### docs/scripts/README.md (450+ строк)
**Комплексное руководство по deployment скриптам**

**Разделы:**
1. Список и описание всех скриптов
2. Быстрый старт для нового сервера
3. Обновление проекта
4. Конфигурация и переменные
5. Безопасность (права, пользователи, firewall)
6. Troubleshooting (по каждому типу ошибок)
7. Проверка состояния системы
8. Логирование
9. Следующие шаги (домен, SSL, CI/CD, мониторинг, бэкапы)
10. Примеры скриптов для автоматизации

#### docs/CHANGELOG.md (обновлён)
**Добавлен раздел 9: "Развертывание на Production сервере"**

**Документировано:**
- Все 5 этапов развертывания
- Информация о сервере
- Созданные скрипты
- Итоговая конфигурация
- Доступ к сайту
- Текущее состояние проекта

---

## 📊 Статистика

### Git коммиты
```
a195850 - Add production deployment documentation and optimized scripts
f243829 - Update documentation links after moving files to docs folder
0d48e8d - Create folder docs and moved something files
```

### Изменения в файлах
- **Создано:** 8 новых файлов
- **Изменено:** 1 файл (CHANGELOG.md)
- **Удалено:** папка scripts/ (7 старых файлов)
- **Добавлено строк:** 1677+

### Скрипты
- **Bash скриптов:** 4
- **Конфигураций:** 1 (Nginx)
- **Документации:** 3 (SERVER-SETUP.md, scripts/README.md, PRODUCTION-SUMMARY.md)

### Документация
- **Общий объём:** 2100+ строк
- **SERVER-SETUP.md:** 700+ строк
- **scripts/README.md:** 450+ строк
- **CHANGELOG.md раздел 9:** 300+ строк
- **PRODUCTION-SUMMARY.md:** 650+ строк

---

## 📁 Финальная структура проекта

```
larka/
├── README.md                               # Главная страница проекта
│
├── docs/                                   # Документация
│   ├── CHANGELOG.md                        # История изменений (1000+ строк)
│   ├── DEPLOYMENT.md                       # Общее руководство по деплою
│   ├── SERVER-SETUP.md                     # ⭐ Настройка production (700+ строк)
│   ├── PRODUCTION-SUMMARY.md               # ⭐ Эта сводка
│   │
│   └── scripts/                            # ⭐ Deployment скрипты
│       ├── README.md                       # Комплексное руководство (450+ строк)
│       ├── server-setup.sh                 # Установка всего ПО
│       ├── setup-database.sh               # Настройка PostgreSQL
│       ├── deploy-project.sh               # Деплой проекта + миграции
│       ├── setup-nginx.sh                  # Настройка Nginx
│       └── nginx-config.conf               # Конфигурация Nginx
│
├── app/                                    # Laravel приложение
├── bootstrap/                              # Laravel bootstrap
├── config/                                 # Конфигурация Laravel
├── database/                               # Миграции и seeders
├── public/                                 # Public assets (document root)
├── resources/                              # Views, JS, CSS (Vue + Inertia)
├── routes/                                 # Маршруты
├── storage/                                # Логи, кеш, загрузки
├── tests/                                  # Тесты
│
├── .env.example                            # Пример конфигурации
├── composer.json                           # PHP зависимости
├── package.json                            # NPM зависимости
├── vite.config.js                          # Vite конфигурация
├── Makefile                                # Команды для локальной разработки
├── docker-compose.yml                      # MailHog для локальной разработки
└── test-email.php                          # Тестирование email

На сервере (/var/www/larka/):
├── Та же структура
├── .env                                    # Production конфигурация
└── public/build/                           # Собранный frontend
```

---

## 🚀 Быстрый старт

### Для нового сервера (первый деплой):

```bash
# 1. Подключение к серверу
ssh root@5.180.174.206

# 2. Клонирование проекта
git clone https://github.com/mmskazak/larka.git
cd larka/docs/scripts

# 3. Установка ПО (~10 минут)
sudo bash server-setup.sh

# 4. Настройка базы данных
sudo bash setup-database.sh
# ⚠️ СОХРАНИТЕ ПАРОЛЬ!

# 5. Развертывание проекта
sudo bash deploy-project.sh

# 6. Настройка Nginx
sudo bash setup-nginx.sh

# ✅ Готово! Сайт доступен: http://5.180.174.206
```

**Общее время:** 10-15 минут

---

### Для обновления проекта:

```bash
# Подключение
ssh root@5.180.174.206

# Переход в проект
cd /var/www/larka

# Включить maintenance режим
sudo -u www-data php artisan down

# Получить обновления из GitHub
git pull origin master

# Установить зависимости
sudo -u www-data composer install --no-dev --optimize-autoloader
npm install && npm run build

# Применить миграции
sudo -u www-data php artisan migrate --force

# Обновить кеши
sudo -u www-data php artisan config:cache
sudo -u www-data php artisan route:cache
sudo -u www-data php artisan view:cache

# Выключить maintenance режим
sudo -u www-data php artisan up

echo "✅ Обновление завершено!"
```

---

## 👥 Пользователи и права доступа

### Системные пользователи

**www-data** (веб-сервер)
- Nginx работает под www-data
- PHP-FPM работает под www-data
- Владелец всех файлов проекта
- Запуск Artisan команд: `sudo -u www-data php artisan <команда>`

**deployer** (деплой)
- Для загрузки скриптов
- Хранение .env.database
- SSH доступ для обслуживания

**root** (администрирование)
- Установка ПО
- Запуск deployment скриптов
- Настройка системы

### Права на файлы

```bash
/var/www/larka/                     → www-data:www-data (755)
/var/www/larka/storage/             → www-data:www-data (775)
/var/www/larka/bootstrap/cache/     → www-data:www-data (775)
/var/www/larka/.env                 → www-data:www-data (644)
```

### Важно

**✅ Правильно:**
```bash
sudo -u www-data php artisan migrate
```

**❌ Неправильно:**
```bash
php artisan migrate  # Создаст файлы от root!
```

---

## 🔐 Безопасность

### Firewall (UFW)

**Открытые порты:**
- 22 - SSH
- 80 - HTTP
- 443 - HTTPS (для будущего SSL)

**Проверка:**
```bash
sudo ufw status
```

### База данных

**Credentials (НЕ коммитить!):**
- Database: `larka_db`
- User: `larka_user`
- Password: `tFPlAH7jjAYeHuzPJ2wjrLzLD`
- Host: `127.0.0.1` (только localhost)

**Хранение:**
- `/home/deployer/.env.database` - на сервере
- `/var/www/larka/.env` - в проекте (исключён из Git)

### Обновления системы

```bash
# Регулярно обновляйте систему
sudo apt update && sudo apt upgrade -y
```

---

## 📝 Логирование

### Где искать логи:

```bash
# Laravel логи
tail -f /var/www/larka/storage/logs/laravel.log

# Nginx Access (посещения)
tail -f /var/log/nginx/larka-access.log

# Nginx Error (ошибки веб-сервера)
tail -f /var/log/nginx/larka-error.log

# PHP-FPM
tail -f /var/log/php8.4-fpm.log

# PostgreSQL
tail -f /var/log/postgresql/postgresql-14-main.log

# Системные логи
journalctl -xe
```

---

## 🐛 Частые проблемы и решения

### 502 Bad Gateway
**Причина:** PHP-FPM не работает

**Решение:**
```bash
sudo systemctl restart php8.4-fpm
sudo systemctl status php8.4-fpm
```

### 403 Forbidden
**Причина:** Неправильные права доступа

**Решение:**
```bash
sudo chown -R www-data:www-data /var/www/larka
sudo chmod -R 755 /var/www/larka
sudo chmod -R 775 /var/www/larka/storage
```

### Ошибка подключения к БД
**Причина:** Неверные credentials или закомментированные настройки

**Решение:**
```bash
# Проверить .env
cat /var/www/larka/.env | grep DB_

# Проверить подключение
psql -h 127.0.0.1 -U larka_user -d larka_db

# Очистить кеш конфигурации
cd /var/www/larka
sudo -u www-data php artisan config:clear
```

### Storage недоступен
**Причина:** Нет прав на запись

**Решение:**
```bash
sudo chown -R www-data:www-data /var/www/larka/storage
sudo chmod -R 775 /var/www/larka/storage
```

---

## 🔮 Следующие шаги (опционально)

### 1. Купить домен и настроить DNS

```
В DNS провайдере создать A-запись:
yourdomain.com → 5.180.174.206
www.yourdomain.com → 5.180.174.206
```

### 2. Установить SSL сертификат

```bash
# Обновить nginx-config.conf
server_name yourdomain.com www.yourdomain.com;

# Получить бесплатный SSL от Let's Encrypt
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Certbot автоматически:
# - Получит сертификат
# - Обновит конфигурацию Nginx
# - Настроит автообновление
```

### 3. Настроить CI/CD (GitHub Actions)

Создать `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [ master ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_IP }}
          username: deployer
          key: ${{ secrets.SSH_KEY }}
          script: |
            cd /var/www/larka
            git pull origin master
            sudo -u www-data composer install --no-dev
            npm install && npm run build
            sudo -u www-data php artisan migrate --force
            sudo -u www-data php artisan cache:clear
            sudo -u www-data php artisan config:cache
```

### 4. Настроить мониторинг

- **Laravel Telescope** - для debug и профилирования
- **Laravel Horizon** - для управления очередями
- **Sentry/Bugsnag** - для отслеживания ошибок
- **UptimeRobot** - для мониторинга доступности сайта

### 5. Настроить резервное копирование

Создать скрипт `/home/deployer/backup.sh`:

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/deployer/backups"

mkdir -p $BACKUP_DIR

# Бэкап БД
pg_dump -U larka_user larka_db > $BACKUP_DIR/db_$DATE.sql

# Бэкап файлов
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/larka/storage

# Удалить старые бэкапы (>7 дней)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

Добавить в cron (ежедневно в 2:00):
```bash
crontab -e
# Добавить:
0 2 * * * /home/deployer/backup.sh
```

### 6. Настроить MCP (Model Context Protocol)

После настройки SSL и домена:

1. Добавить SSH ключ на сервер:
   ```bash
   cat ~/.ssh/id_ed25519_larka.pub | ssh root@5.180.174.206 \
     "cat >> ~/.ssh/authorized_keys"
   ```

2. Настроить Claude Desktop (см. claude_desktop_config.example.json)

3. Подключиться к серверу через Claude для удалённого управления

---

## ✨ Текущее состояние проекта

### Локальная разработка ✅
- Laravel 12.33.0 + PHP 8.4.4
- Laravel Breeze + Inertia.js + Vue 3
- Email verification активирована
- MailHog для тестирования email
- Makefile для автоматизации команд
- Git repository: https://github.com/mmskazak/larka

### Production сервер ✅
- Ubuntu 22.04 LTS (1GB RAM, 40GB диск)
- Nginx + PHP 8.4.13 + PostgreSQL 14.19
- Проект развёрнут в `/var/www/larka`
- База данных настроена, миграции применены
- **Сайт работает:** http://5.180.174.206

### Что осталось (опционально) ❌
- SSL сертификат (требуется домен)
- Автоматический деплой (GitHub Actions)
- Мониторинг и алерты
- Резервное копирование
- MCP подключение для удалённого управления

### Документация ✅
- README.md - быстрый старт
- docs/CHANGELOG.md - полная история изменений
- docs/DEPLOYMENT.md - общее руководство по деплою
- docs/SERVER-SETUP.md - настройка production сервера
- docs/scripts/README.md - руководство по скриптам
- docs/PRODUCTION-SUMMARY.md - эта сводка

---

## 🎓 Что было изучено и применено

### Технологии
1. **Linux Server Administration** - Ubuntu, пользователи, права
2. **Web Server** - Nginx, конфигурация, PHP-FPM
3. **Database** - PostgreSQL, создание БД, пользователи
4. **Deployment** - git, composer, npm, миграции
5. **Security** - UFW firewall, права доступа, SSL (готово)

### Навыки
1. **Bash Scripting** - автоматизация deployment
2. **Documentation** - техническая документация, руководства
3. **DevOps** - CI/CD концепции, мониторинг, бэкапы
4. **Problem Solving** - troubleshooting, отладка
5. **Best Practices** - безопасность, структура, права

---

## 📚 Полезные ссылки

### Документация проекта
- [CHANGELOG.md](CHANGELOG.md) - история изменений
- [DEPLOYMENT.md](DEPLOYMENT.md) - руководство по деплою
- [SERVER-SETUP.md](SERVER-SETUP.md) - настройка сервера
- [scripts/README.md](scripts/README.md) - deployment скрипты

### Repository
- **GitHub:** https://github.com/mmskazak/larka
- **Issues:** https://github.com/mmskazak/larka/issues

### Production
- **URL:** http://5.180.174.206
- **Server IP:** 5.180.174.206
- **SSH:** `ssh larka` или `ssh root@5.180.174.206`

### External Docs
- [Laravel Documentation](https://laravel.com/docs)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [Let's Encrypt](https://letsencrypt.org/)

---

## ⚠️ Важные напоминания

1. **Никогда не коммитить** `.env` файлы в Git
2. **Всегда делать бэкап** перед обновлением production
3. **Запускать Artisan от www-data**, не от root
4. **Использовать maintenance режим** при обновлении
5. **Тестировать на staging** перед production
6. **Регулярно обновлять** систему и зависимости
7. **Мониторить логи** на ошибки и аномалии
8. **Сохранить пароль БД** в безопасном месте

---

**Версия:** 1.0
**Дата создания:** 2025-10-11
**Автор:** Claude Code
**Статус:** ✅ Production Ready

---

🎉 **Проект успешно развёрнут и готов к использованию!**
