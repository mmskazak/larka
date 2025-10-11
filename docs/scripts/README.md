# Production Deployment Scripts

Автоматизированные скрипты для развертывания Laravel проекта Larka на production сервере Ubuntu 22.04.

## 📋 Список скриптов

### 1. server-setup.sh
**Описание:** Комплексная установка всего необходимого ПО на чистый сервер.

**Что устанавливает:**
- Nginx (веб-сервер)
- PHP 8.4 + все расширения для Laravel
- Composer (менеджер пакетов PHP)
- Node.js 20 LTS + NPM (для frontend)
- PostgreSQL 15 (база данных)
- Supervisor (для фоновых задач/очередей)
- Certbot (для SSL сертификатов)
- UFW (firewall)

**Использование:**
```bash
sudo bash server-setup.sh
```

**Требования:**
- Root права
- Чистый Ubuntu 22.04 LTS
- Минимум 1GB RAM

**Время выполнения:** ~5-10 минут

---

### 2. setup-database.sh
**Описание:** Создание и настройка PostgreSQL базы данных.

**Что создает:**
- База данных: `larka_db`
- Пользователь PostgreSQL: `larka_user`
- Пароль: генерируется автоматически (32 символа)
- Файл с credentials: `/home/deployer/.env.database`

**Использование:**
```bash
sudo bash setup-database.sh
```

**Требования:**
- Root права
- Установленный PostgreSQL (из server-setup.sh)

**⚠️ ВАЖНО:** Сохраните пароль из вывода скрипта!

**Вывод:**
```
База данных: larka_db
Пользователь: larka_user
Пароль: <сгенерированный_пароль>

Конфигурация сохранена в: /home/deployer/.env.database
```

---

### 3. deploy-project.sh
**Описание:** Полное развертывание Laravel проекта.

**Что делает:**
1. Создает директорию `/var/www/larka`
2. Клонирует репозиторий из GitHub
3. Создает/обновляет `.env` файл
4. Автоматически добавляет настройки БД из `/home/deployer/.env.database`
5. Устанавливает Composer зависимости (`--no-dev --optimize-autoloader`)
6. Генерирует `APP_KEY`
7. Устанавливает NPM зависимости
8. Собирает frontend (`npm run build`)
9. Настраивает права доступа (`www-data:www-data`)
10. Запускает миграции базы данных

**Использование:**
```bash
sudo bash deploy-project.sh
```

**Требования:**
- Root права
- Выполнен `server-setup.sh`
- Выполнен `setup-database.sh`
- Файл `/home/deployer/.env.database` существует

**Путь проекта:** `/var/www/larka`
**Document root:** `/var/www/larka/public`

---

### 4. setup-nginx.sh
**Описание:** Настройка Nginx для работы с Laravel.

**Что делает:**
1. Копирует конфигурацию в `/etc/nginx/sites-available/larka`
2. Отключает default сайт
3. Активирует сайт larka (создает symlink)
4. Проверяет конфигурацию (`nginx -t`)
5. Перезапускает Nginx

**Использование:**
```bash
# Сначала убедитесь что nginx-config.conf находится рядом
sudo bash setup-nginx.sh
```

**Требования:**
- Root права
- Установленный Nginx
- Файл `nginx-config.conf` в той же папке или `~/larka.conf`

**Конфигурация:**
- Порт: 80 (HTTP)
- Server name: `_` (принимает любой IP/домен)
- Document root: `/var/www/larka/public`
- PHP-FPM: `/var/run/php/php8.4-fpm.sock`
- Логи: `/var/log/nginx/larka-*.log`

---

### 5. nginx-config.conf
**Описание:** Конфигурационный файл Nginx для Laravel проекта.

**Особенности:**
- ✅ Pretty URLs (без index.php в адресе)
- ✅ PHP-FPM интеграция
- ✅ Защита скрытых файлов (.env, .git)
- ✅ Кеширование статики (1 год)
- ✅ Ограничение размера загрузки: 20MB
- ✅ Безопасные заголовки

**Не используется напрямую** - применяется через `setup-nginx.sh`

---

## 🚀 Быстрый старт (First Deploy)

### Полная последовательность для нового сервера:

```bash
# Шаг 1: Подключитесь к серверу
ssh root@5.180.174.206

# Шаг 2: Скачайте скрипты
cd ~
git clone https://github.com/mmskazak/larka.git
cd larka/docs/scripts

# Шаг 3: Установите базовое ПО (5-10 минут)
sudo bash server-setup.sh

# Шаг 4: Настройте базу данных
sudo bash setup-database.sh
# СОХРАНИТЕ ПАРОЛЬ!

# Шаг 5: Разверните проект
sudo bash deploy-project.sh

# Шаг 6: Настройте Nginx
sudo bash setup-nginx.sh

# Шаг 7: Проверьте результат
curl -I http://localhost
# Или откройте в браузере: http://5.180.174.206
```

**Общее время:** ~10-15 минут

---

## 🔄 Обновление проекта (Update Deploy)

Для обновления уже развернутого проекта:

```bash
cd /var/www/larka

# Включить maintenance режим
sudo -u www-data php artisan down

# Получить обновления
git pull origin master

# Установить зависимости
sudo -u www-data composer install --no-dev --optimize-autoloader
npm install && npm run build

# Применить миграции
sudo -u www-data php artisan migrate --force

# Очистить и обновить кеш
sudo -u www-data php artisan config:cache
sudo -u www-data php artisan route:cache
sudo -u www-data php artisan view:cache

# Выключить maintenance режим
sudo -u www-data php artisan up
```

**Совет:** Создайте файл `/home/deployer/update.sh` с этими командами для быстрого обновления.

---

## ⚙️ Конфигурация

### Переменные окружения

Все скрипты используют следующие параметры:

```bash
PROJECT_DIR="/var/www/larka"
GIT_REPO="https://github.com/mmskazak/larka.git"
WEB_USER="www-data"
DB_NAME="larka_db"
DB_USER="larka_user"
DB_PASSWORD="<генерируется автоматически>"
```

### Изменение параметров

Если нужно изменить параметры (например, путь к проекту):

1. Откройте скрипт в редакторе:
   ```bash
   nano deploy-project.sh
   ```

2. Измените переменные в начале файла:
   ```bash
   PROJECT_DIR="/var/www/your-project"
   GIT_REPO="https://github.com/user/repo.git"
   ```

3. Сохраните и выполните скрипт

---

## 🔐 Безопасность

### Права доступа

После развертывания:

```bash
/var/www/larka/          → www-data:www-data (755)
/var/www/larka/storage/  → www-data:www-data (775)
/var/www/larka/bootstrap/cache/ → www-data:www-data (775)
```

### Пользователи

- **www-data** - веб-сервер (Nginx + PHP-FPM)
- **deployer** - для деплоя и обслуживания
- **root** - для установки ПО

### Запуск команд Artisan

**Всегда** запускайте от `www-data`:

```bash
# Правильно ✅
sudo -u www-data php artisan migrate

# Неправильно ❌ (создаст файлы от root)
php artisan migrate
```

### Firewall (UFW)

После `server-setup.sh` открыты порты:
- **22** - SSH
- **80** - HTTP
- **443** - HTTPS (для будущего SSL)

```bash
# Проверить статус
sudo ufw status

# Заблокировать порт
sudo ufw deny 8080

# Открыть порт
sudo ufw allow 3000
```

---

## 🐛 Troubleshooting

### Ошибка: "Permission denied"

```bash
# Исправить права на скрипты
chmod +x *.sh
```

### Ошибка: "command not found"

Скрипт не найден - укажите полный путь:
```bash
sudo bash /home/deployer/larka/docs/scripts/server-setup.sh
```

### Ошибка при миграциях

```bash
# Проверить подключение к БД
psql -h 127.0.0.1 -U larka_user -d larka_db

# Проверить .env
cat /var/www/larka/.env | grep DB_

# Очистить кеш
cd /var/www/larka
sudo -u www-data php artisan config:clear
```

### Nginx не запускается

```bash
# Проверить конфигурацию
nginx -t

# Посмотреть логи
tail -f /var/log/nginx/error.log

# Проверить PHP-FPM
systemctl status php8.4-fpm
```

### 502 Bad Gateway

PHP-FPM не работает:
```bash
systemctl restart php8.4-fpm
systemctl status php8.4-fpm
```

### Проект не клонируется

Проверьте доступ к GitHub:
```bash
ssh -T git@github.com
# или для HTTPS
curl https://github.com
```

---

## 📊 Проверка состояния

### После установки

```bash
# Версии ПО
php -v
composer --version
node -v
npm -v
psql --version
nginx -v

# Статус сервисов
systemctl status nginx
systemctl status php8.4-fpm
systemctl status postgresql

# Использование ресурсов
free -h          # RAM
df -h            # Диск
top              # Процессы
```

### Проверка сайта

```bash
# Локально на сервере
curl -I http://localhost

# Извне
curl -I http://5.180.174.206

# Проверка DNS (если домен настроен)
dig yourdomain.com
```

---

## 📝 Логи

### Где найти логи:

```bash
# Laravel
tail -f /var/www/larka/storage/logs/laravel.log

# Nginx Access
tail -f /var/log/nginx/larka-access.log

# Nginx Error
tail -f /var/log/nginx/larka-error.log

# PHP-FPM
tail -f /var/log/php8.4-fpm.log

# PostgreSQL
tail -f /var/log/postgresql/postgresql-15-main.log

# System
journalctl -xe
```

---

## 🔮 Следующие шаги

После успешного развертывания:

### 1. Настроить домен

```bash
# В вашем DNS провайдере создайте A-запись:
yourdomain.com → 5.180.174.206
```

### 2. Установить SSL

```bash
# Обновить nginx-config.conf
server_name yourdomain.com;

# Получить бесплатный SSL от Let's Encrypt
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Certbot автоматически обновит конфигурацию Nginx
```

### 3. Настроить автообновление SSL

Certbot автоматически создает cron задачу для обновления сертификатов.

Проверить:
```bash
sudo certbot renew --dry-run
```

### 4. Настроить CI/CD

GitHub Actions для автоматического деплоя:

```yaml
# .github/workflows/deploy.yml
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
```

### 5. Настроить мониторинг

- Laravel Telescope (для debug)
- Laravel Horizon (для очередей)
- Логирование ошибок в Sentry/Bugsnag
- Uptime мониторинг (UptimeRobot, Pingdom)

### 6. Настроить резервное копирование

```bash
# Создать скрипт бэкапа
cat > /home/deployer/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/deployer/backups"
mkdir -p $BACKUP_DIR

# Бэкап БД
pg_dump -U larka_user larka_db > $BACKUP_DIR/db_$DATE.sql

# Бэкап файлов
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/larka/storage

# Удалить старые бэкапы (старше 7 дней)
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
EOF

chmod +x /home/deployer/backup.sh

# Добавить в cron (ежедневно в 2:00)
crontab -e
# Добавить строку:
0 2 * * * /home/deployer/backup.sh
```

---

## 📚 Документация

**Полная документация:**
- [SERVER-SETUP.md](../SERVER-SETUP.md) - детальное руководство по настройке
- [DEPLOYMENT.md](../DEPLOYMENT.md) - общее руководство по деплою
- [CHANGELOG.md](../CHANGELOG.md) - история всех изменений

**Repository:** https://github.com/mmskazak/larka

---

## ⚠️ Важные замечания

1. **Всегда делайте бэкап** перед обновлением production
2. **Тестируйте на staging** перед деплоем
3. **Используйте maintenance режим** при обновлении
4. **Запускайте Artisan от www-data**, а не от root
5. **Не коммитьте .env** в Git
6. **Регулярно обновляйте** систему и пакеты
7. **Мониторьте логи** на ошибки

---

**Версия:** 2.0
**Дата создания:** 2025-10-11
**Последнее обновление:** 2025-10-11
