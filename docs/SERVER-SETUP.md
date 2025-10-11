# Настройка Production Сервера

Документация по настройке и развертыванию проекта Larka на production сервере.

## Информация о сервере

- **IP адрес:** 5.180.174.206
- **ОС:** Ubuntu 22.04.5 LTS (Jammy Jellyfish)
- **RAM:** 1 GB
- **Диск:** 40 GB
- **Веб-сервер:** Nginx
- **PHP:** 8.4.13
- **База данных:** PostgreSQL 14.19
- **Node.js:** 20.x LTS

---

## Шаг 1: Подготовка сервера

### 1.1 Подключение к серверу

```bash
ssh larka
# или
ssh root@5.180.174.206
```

### 1.2 Установка базового ПО

Выполните скрипт установки (требуется root):

```bash
bash /home/deployer/server-setup.sh
```

**Что устанавливается:**
- Nginx
- PHP 8.3 + расширения
- Composer
- Node.js 20 + NPM
- PostgreSQL 15
- Supervisor
- Certbot (для SSL)
- UFW (firewall)

**Время выполнения:** ~5-10 минут

---

## Шаг 2: Установка PHP 8.4

Для совместимости с локальной версией устанавливаем PHP 8.4:

```bash
bash /home/deployer/install-php84.sh
```

**Проверка версии:**
```bash
php -v
# Должно показать: PHP 8.4.13
```

---

## Шаг 3: Настройка базы данных PostgreSQL

### 3.1 Создание базы данных

```bash
bash /home/deployer/setup-database.sh
```

Скрипт создаст:
- База данных: `larka_db`
- Пользователь: `larka_user`
- Пароль: генерируется автоматически

**Конфигурация сохраняется в:** `/home/deployer/.env.database`

### 3.2 Просмотр данных подключения

```bash
cat /home/deployer/.env.database
```

Вывод:
```env
DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=larka_db
DB_USERNAME=larka_user
DB_PASSWORD=<сгенерированный_пароль>
```

---

## Шаг 4: Развертывание Laravel проекта

### 4.1 Клонирование и установка

```bash
bash /home/deployer/deploy-initial.sh
```

**Что делает скрипт:**
1. Клонирует проект из GitHub в `/var/www/larka`
2. Создает `.env` файл
3. Добавляет настройки базы данных
4. Устанавливает Composer зависимости
5. Генерирует APP_KEY
6. Устанавливает NPM зависимости
7. Собирает frontend (Vite)
8. Настраивает права доступа

**Путь к проекту:** `/var/www/larka`

### 4.2 Исправление конфигурации (если нужно)

Если возникли проблемы с `.env`:

```bash
bash /home/deployer/fix-env.sh
```

### 4.3 Запуск миграций

**ВАЖНО:** Запускайте от имени `www-data`:

```bash
cd /var/www/larka
sudo -u www-data php artisan migrate --force
```

---

## Шаг 5: Настройка Nginx

### 5.1 Установка конфигурации

```bash
bash /home/deployer/setup-nginx.sh
```

**Что делает скрипт:**
1. Копирует конфигурацию в `/etc/nginx/sites-available/larka`
2. Отключает default сайт
3. Активирует сайт larka
4. Проверяет конфигурацию
5. Перезапускает Nginx

### 5.2 Проверка работы

```bash
systemctl status nginx
curl -I http://5.180.174.206
```

---

## Шаг 6: Доступ к сайту

**URL:** http://5.180.174.206

### Тестирование

1. Откройте браузер
2. Перейдите по адресу: http://5.180.174.206
3. Должна открыться главная страница Laravel

---

## Структура проекта на сервере

```
/var/www/larka/
├── app/              # Laravel приложение
├── public/           # Публичная директория (document root)
├── storage/          # Логи, кеш, загрузки
├── bootstrap/cache/  # Кеш загрузки
├── .env              # Конфигурация окружения
└── vendor/           # Composer зависимости
```

---

## Пользователи и права

### Веб-сервер
- **Пользователь:** `www-data`
- **PHP-FPM:** работает под `www-data`
- **Nginx:** работает под `www-data`

### Владение файлами
```bash
# Все файлы проекта
chown -R www-data:www-data /var/www/larka

# Права на запись
chmod -R 775 /var/www/larka/storage
chmod -R 775 /var/www/larka/bootstrap/cache
```

### Запуск команд Artisan

От имени www-data:
```bash
sudo -u www-data php artisan <команда>
```

---

## Обслуживание

### Просмотр логов

```bash
# Логи Laravel
tail -f /var/www/larka/storage/logs/laravel.log

# Логи Nginx
tail -f /var/log/nginx/larka-access.log
tail -f /var/log/nginx/larka-error.log

# Логи PHP-FPM
tail -f /var/log/php8.4-fpm.log
```

### Очистка кеша

```bash
cd /var/www/larka
sudo -u www-data php artisan cache:clear
sudo -u www-data php artisan config:clear
sudo -u www-data php artisan view:clear
```

### Перезапуск сервисов

```bash
# Nginx
systemctl restart nginx

# PHP-FPM
systemctl restart php8.4-fpm

# PostgreSQL
systemctl restart postgresql
```

---

## Обновление проекта

### Вариант 1: Ручное обновление

```bash
cd /var/www/larka

# 1. Переключиться на www-data или deployer
sudo -u www-data bash

# 2. Включить maintenance режим
php artisan down

# 3. Получить обновления
git pull origin master

# 4. Установить зависимости
composer install --no-dev --optimize-autoloader
npm install && npm run build

# 5. Применить миграции
php artisan migrate --force

# 6. Очистить кеши
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 7. Выключить maintenance режим
php artisan up
```

### Вариант 2: Автоматический деплой

Создайте скрипт `/home/deployer/deploy.sh`:

```bash
#!/bin/bash
cd /var/www/larka

sudo -u www-data php artisan down

git pull origin master

sudo -u www-data composer install --no-dev --optimize-autoloader --no-interaction
npm install && npm run build

sudo -u www-data php artisan migrate --force
sudo -u www-data php artisan config:cache
sudo -u www-data php artisan route:cache
sudo -u www-data php artisan view:cache

sudo -u www-data php artisan up

echo "✓ Deployment complete!"
```

Использование:
```bash
bash /home/deployer/deploy.sh
```

---

## Безопасность

### Firewall (UFW)

```bash
# Проверить статус
ufw status

# Открытые порты:
# - 22 (SSH)
# - 80 (HTTP)
# - 443 (HTTPS, когда будет SSL)
```

### Обновления системы

```bash
apt update && apt upgrade -y
```

### Резервное копирование базы данных

```bash
# Создать бэкап
pg_dump -U larka_user larka_db > backup_$(date +%Y%m%d).sql

# Восстановить из бэкапа
psql -U larka_user larka_db < backup_20251011.sql
```

---

## Troubleshooting

### 502 Bad Gateway

Проверьте PHP-FPM:
```bash
systemctl status php8.4-fpm
systemctl restart php8.4-fpm
```

### 403 Forbidden

Проверьте права:
```bash
ls -la /var/www/larka/public
# Должно быть: www-data:www-data
```

### База данных не подключается

Проверьте настройки:
```bash
cat /var/www/larka/.env | grep DB_

# Проверьте подключение
psql -h 127.0.0.1 -U larka_user -d larka_db
```

### Storage недоступен

Проверьте права:
```bash
sudo chmod -R 775 /var/www/larka/storage
sudo chown -R www-data:www-data /var/www/larka/storage
```

---

## Следующие шаги

1. **Купить домен** и настроить DNS на 5.180.174.206
2. **Настроить SSL** с помощью Let's Encrypt:
   ```bash
   certbot --nginx -d yourdomain.com
   ```
3. **Настроить автоматический деплой** через GitHub Actions
4. **Настроить мониторинг** (например, Laravel Telescope)
5. **Настроить резервное копирование**

---

## Полезные команды

```bash
# Проверка версий
php -v
composer --version
node -v
npm -v
psql --version

# Статус сервисов
systemctl status nginx
systemctl status php8.4-fpm
systemctl status postgresql

# Использование ресурсов
free -h          # RAM
df -h            # Диск
top              # Процессы
```

---

## Контакты и ссылки

- **Repository:** https://github.com/mmskazak/larka
- **Server IP:** 5.180.174.206
- **Site URL:** http://5.180.174.206

---

**Дата создания:** 2025-10-11
**Последнее обновление:** 2025-10-11
