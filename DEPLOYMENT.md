# Руководство по деплою проекта Larka

Полное руководство по развертыванию Laravel приложения на production сервере и организации workflow разработки.

---

## Содержание

1. [Варианты деплоя](#варианты-деплоя)
2. [Подготовка сервера](#подготовка-сервера)
3. [Первоначальный деплой](#первоначальный-деплой)
4. [Workflow разработки](#workflow-разработки)
5. [Обновление production](#обновление-production)
6. [CI/CD автоматизация](#cicd-автоматизация)
7. [Troubleshooting](#troubleshooting)

---

## Варианты деплоя

### 1. Простой VPS (Рекомендуется для начала)

**Провайдеры:**
- [DigitalOcean](https://www.digitalocean.com/) - $6/месяц
- [Linode](https://www.linode.com/) - $5/месяц
- [Vultr](https://www.vultr.com/) - $6/месяц
- [Hetzner](https://www.hetzner.com/) - €4/месяц (дешевле)

**Плюсы:**
- Полный контроль над сервером
- Дешево
- Подходит для обучения

**Минусы:**
- Нужно настраивать самому
- Нужно следить за безопасностью

### 2. Laravel Forge (Самый простой)

**Ссылка:** https://forge.laravel.com/

**Плюсы:**
- Автоматическая настройка сервера
- Нулевой downtime деплой
- Бесплатный SSL (Let's Encrypt)
- Мониторинг, бэкапы, очереди
- Деплой одной кнопкой

**Стоимость:** $12/месяц + стоимость VPS

**Лучший вариант для production!**

### 3. Shared хостинг

**Провайдеры:**
- [Hostinger](https://www.hostinger.com/)
- [Namecheap](https://www.namecheap.com/)

**Плюсы:**
- Очень дешево ($1-5/месяц)
- Не нужно настраивать

**Минусы:**
- Ограниченный контроль
- Могут быть проблемы с Laravel

### 4. PaaS платформы

**Варианты:**
- [Heroku](https://www.heroku.com/) - бесплатный tier есть
- [Railway](https://railway.app/) - удобный, современный
- [Fly.io](https://fly.io/) - быстрый деплой

**Плюсы:**
- Автоматический деплой из GitHub
- Не нужно настраивать сервер
- Масштабирование одной кнопкой

**Минусы:**
- Дороже чем VPS при росте

---

## Подготовка сервера (для VPS)

### Требования

- Ubuntu 22.04 LTS (рекомендуется)
- Минимум 1GB RAM
- PHP 8.4
- Node.js 20+
- Composer
- Nginx или Apache
- PostgreSQL или MySQL (рекомендуется вместо SQLite)

### Быстрая установка через скрипт

Используем официальный скрипт Laravel для настройки сервера:

```bash
# 1. Подключитесь к серверу по SSH
ssh root@ваш-ip

# 2. Обновите систему
apt update && apt upgrade -y

# 3. Установите Laravel Server Script
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# 4. Установите PHP 8.4 и расширения
apt install -y software-properties-common
add-apt-repository ppa:ondrej/php -y
apt update
apt install -y php8.4 php8.4-cli php8.4-fpm php8.4-mysql php8.4-pgsql \
    php8.4-sqlite3 php8.4-curl php8.4-mbstring php8.4-xml php8.4-zip \
    php8.4-bcmath php8.4-gd php8.4-redis

# 5. Установите Nginx
apt install -y nginx

# 6. Установите Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# 7. Установите PostgreSQL (или MySQL)
apt install -y postgresql postgresql-contrib

# 8. Настройте Firewall
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw enable
```

### Создание базы данных

**PostgreSQL:**
```bash
sudo -u postgres psql
CREATE DATABASE larka;
CREATE USER larka_user WITH PASSWORD 'ваш_надёжный_пароль';
GRANT ALL PRIVILEGES ON DATABASE larka TO larka_user;
\q
```

**MySQL:**
```bash
mysql -u root -p
CREATE DATABASE larka;
CREATE USER 'larka_user'@'localhost' IDENTIFIED BY 'ваш_надёжный_пароль';
GRANT ALL PRIVILEGES ON larka.* TO 'larka_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Создание пользователя для деплоя

```bash
# Создать пользователя
adduser deployer
usermod -aG www-data deployer

# Настроить sudo
usermod -aG sudo deployer

# Настроить SSH ключ (на локальной машине)
ssh-copy-id deployer@ваш-ip
```

---

## Первоначальный деплой

### Вариант 1: Ручной деплой (для обучения)

**На сервере:**

```bash
# 1. Переключитесь на пользователя deployer
su - deployer

# 2. Создайте директорию для проекта
sudo mkdir -p /var/www/larka
sudo chown -R deployer:www-data /var/www/larka
cd /var/www/larka

# 3. Клонируйте репозиторий
git clone https://github.com/mmskazak/larka.git .

# 4. Установите зависимости
composer install --no-dev --optimize-autoloader
npm install
npm run build

# 5. Настройте .env
cp .env.example .env
nano .env
```

**Настройте .env для production:**

```env
APP_NAME=Larka
APP_ENV=production
APP_KEY=
APP_DEBUG=false
APP_URL=https://ваш-домен.com

# База данных
DB_CONNECTION=pgsql  # или mysql
DB_HOST=127.0.0.1
DB_PORT=5432  # 3306 для MySQL
DB_DATABASE=larka
DB_USERNAME=larka_user
DB_PASSWORD=ваш_надёжный_пароль

# Почта (используйте реальный SMTP)
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com  # или ваш SMTP
MAIL_PORT=587
MAIL_USERNAME=ваш-email@gmail.com
MAIL_PASSWORD=ваш-app-пароль
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS="noreply@ваш-домен.com"
MAIL_FROM_NAME="${APP_NAME}"

# Очереди
QUEUE_CONNECTION=database  # или redis для production

# Кеш
CACHE_STORE=redis  # или database
SESSION_DRIVER=redis  # или database
```

**Продолжение настройки:**

```bash
# 6. Сгенерируйте ключ приложения
php artisan key:generate

# 7. Выполните миграции
php artisan migrate --force

# 8. Оптимизация
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 9. Настройте права доступа
sudo chown -R deployer:www-data /var/www/larka
sudo chmod -R 755 /var/www/larka
sudo chmod -R 775 /var/www/larka/storage
sudo chmod -R 775 /var/www/larka/bootstrap/cache
```

### Настройка Nginx

```bash
sudo nano /etc/nginx/sites-available/larka
```

**Конфигурация:**

```nginx
server {
    listen 80;
    listen [::]:80;
    server_name ваш-домен.com www.ваш-домен.com;
    root /var/www/larka/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
        fastcgi_hide_header X-Powered-By;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

**Активируйте сайт:**

```bash
sudo ln -s /etc/nginx/sites-available/larka /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Установка SSL сертификата (Let's Encrypt)

```bash
# Установите certbot
sudo apt install -y certbot python3-certbot-nginx

# Получите сертификат
sudo certbot --nginx -d ваш-домен.com -d www.ваш-домен.com

# Автоматическое обновление сертификата
sudo systemctl status certbot.timer
```

### Настройка supervisor (для очередей)

```bash
sudo apt install -y supervisor

sudo nano /etc/supervisor/conf.d/larka-worker.conf
```

**Конфигурация:**

```ini
[program:larka-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/larka/artisan queue:work --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=deployer
numprocs=2
redirect_stderr=true
stdout_logfile=/var/www/larka/storage/logs/worker.log
stopwaitsecs=3600
```

**Запустите worker:**

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start larka-worker:*
```

---

## Workflow разработки

### Рекомендуемый Git Flow

```
main (production)     ← только стабильные релизы
  ↑
develop (staging)     ← разработка и тестирование
  ↑
feature/название      ← новые фичи
  ↑
hotfix/название       ← срочные исправления в production
```

### Процесс разработки

**1. Создание новой фичи:**

```bash
# Локально
git checkout develop
git pull origin develop
git checkout -b feature/user-avatar

# Разработка...
# Тестируйте локально

# Коммит
git add .
git commit -m "Add user avatar upload feature"
git push origin feature/user-avatar
```

**2. Создайте Pull Request на GitHub:**
- Из `feature/user-avatar` в `develop`
- Опишите изменения
- Дождитесь проверки (code review)

**3. После мержа в develop - тестируйте на staging:**

```bash
# На staging сервере
cd /var/www/larka
git pull origin develop
composer install --no-dev
npm install && npm run build
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

**4. Когда всё стабильно - мержите в main:**

```bash
git checkout main
git merge develop
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin main --tags
```

---

## Обновление production

### Скрипт деплоя (создайте на сервере)

```bash
nano /var/www/larka/deploy.sh
```

**Содержимое:**

```bash
#!/bin/bash
set -e

echo "🚀 Starting deployment..."

# Переход в директорию проекта
cd /var/www/larka

# Включение maintenance mode
php artisan down

# Получение последних изменений
git pull origin main

# Установка зависимостей
composer install --no-dev --optimize-autoloader

# Установка npm пакетов и сборка
npm ci --production=false
npm run build

# Выполнение миграций
php artisan migrate --force

# Очистка и оптимизация кеша
php artisan config:clear
php artisan cache:clear
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Перезапуск очередей
sudo supervisorctl restart larka-worker:*

# Выключение maintenance mode
php artisan up

echo "✅ Deployment completed successfully!"
```

**Сделайте скрипт исполняемым:**

```bash
chmod +x /var/www/larka/deploy.sh
```

**Использование:**

```bash
# На сервере
cd /var/www/larka
./deploy.sh
```

### Автоматизация через GitHub Actions

Создайте `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd /var/www/larka
            ./deploy.sh
```

**Настройте Secrets в GitHub:**
1. Перейдите в Settings → Secrets → Actions
2. Добавьте:
   - `SERVER_HOST` - IP сервера
   - `SERVER_USER` - deployer
   - `SSH_PRIVATE_KEY` - ваш приватный SSH ключ

---

## CI/CD автоматизация (продвинутый уровень)

### GitHub Actions для тестов

Создайте `.github/workflows/tests.yml`:

```yaml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  tests:
    runs-on: ubuntu-latest

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_DB: larka_test
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3

      - name: Setup PHP
        uses: shivammathur/setup-php@v2
        with:
          php-version: '8.4'
          extensions: mbstring, xml, ctype, json, bcmath, pdo, pgsql

      - name: Copy .env
        run: php -r "file_exists('.env') || copy('.env.example', '.env');"

      - name: Install Composer dependencies
        run: composer install --prefer-dist --no-interaction

      - name: Generate key
        run: php artisan key:generate

      - name: Set up database
        run: php artisan migrate --force
        env:
          DB_CONNECTION: pgsql
          DB_HOST: localhost
          DB_PORT: 5432
          DB_DATABASE: larka_test
          DB_USERNAME: postgres
          DB_PASSWORD: postgres

      - name: Run tests
        run: php artisan test
```

---

## Troubleshooting

### Проблема: 500 ошибка после деплоя

```bash
# Проверьте логи
tail -f /var/www/larka/storage/logs/laravel.log

# Проверьте права доступа
sudo chown -R deployer:www-data /var/www/larka
sudo chmod -R 775 /var/www/larka/storage
sudo chmod -R 775 /var/www/larka/bootstrap/cache

# Очистите кеш
php artisan cache:clear
php artisan config:clear
php artisan view:clear
```

### Проблема: База данных недоступна

```bash
# Проверьте подключение
php artisan tinker
DB::connection()->getPdo();

# Проверьте .env
cat .env | grep DB_
```

### Проблема: Email не отправляются

```bash
# Проверьте настройки
php artisan tinker
config('mail');

# Отправьте тестовое письмо
php artisan tinker
Mail::raw('Test', fn($m) => $m->to('test@example.com')->subject('Test'));
```

### Проблема: Очереди не работают

```bash
# Проверьте статус
sudo supervisorctl status

# Перезапустите
sudo supervisorctl restart larka-worker:*

# Проверьте логи
tail -f /var/www/larka/storage/logs/worker.log
```

---

## Чек-лист деплоя

### Перед первым деплоем

- [ ] Домен настроен и указывает на сервер
- [ ] SSH доступ к серверу работает
- [ ] База данных создана
- [ ] .env файл настроен для production
- [ ] SSL сертификат установлен
- [ ] Nginx настроен
- [ ] Supervisor настроен для очередей

### При каждом обновлении

- [ ] Код протестирован локально
- [ ] Создан git tag с версией
- [ ] Backup базы данных сделан
- [ ] `php artisan down` - maintenance mode
- [ ] `git pull` - получены изменения
- [ ] `composer install` - обновлены зависимости
- [ ] `npm run build` - собран frontend
- [ ] `php artisan migrate` - применены миграции
- [ ] Кеш очищен и пересоздан
- [ ] Workers перезапущены
- [ ] `php artisan up` - выключен maintenance mode
- [ ] Сайт протестирован

---

## Полезные ссылки

**Документация:**
- [Laravel Deployment](https://laravel.com/docs/deployment)
- [Laravel Forge](https://forge.laravel.com/)
- [DigitalOcean Laravel Guide](https://www.digitalocean.com/community/tutorials/how-to-deploy-laravel-on-ubuntu)

**Инструменты:**
- [Laravel Envoy](https://laravel.com/docs/envoy) - деплой скрипты
- [Deployer](https://deployer.org/) - PHP deployment tool
- [Vapor](https://vapor.laravel.com/) - serverless деплой на AWS

---

## Следующий шаг

После успешного деплоя рекомендуется настроить:

1. **Мониторинг** - [Laravel Telescope](https://laravel.com/docs/telescope), [Sentry](https://sentry.io)
2. **Бэкапы** - регулярные автоматические backup базы данных
3. **CDN** - для статических файлов (Cloudflare)
4. **Redis** - для кеша и очередей
5. **Горизонтальное масштабирование** - когда вырастет нагрузка
