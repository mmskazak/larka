#!/bin/bash
#
# Laravel Project Deployment Script
# Развертывание проекта в /var/www/larka
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="/var/www/larka"
GIT_REPO="https://github.com/mmskazak/larka.git"
WEB_USER="www-data"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Запустите скрипт с sudo или от root${NC}"
    exit 1
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Laravel Project Deployment${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

echo -e "${YELLOW}[1/10]${NC} Создание директории проекта..."
mkdir -p $PROJECT_DIR
cd $PROJECT_DIR

echo -e "${YELLOW}[2/10]${NC} Клонирование репозитория..."
if [ -d ".git" ]; then
    echo "Репозиторий уже существует, обновляем..."
    git pull origin master
else
    git clone $GIT_REPO .
fi

echo -e "${YELLOW}[3/10]${NC} Создание .env файла..."
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ".env создан из .env.example"
else
    echo ".env уже существует, обновляем..."
fi

echo -e "${YELLOW}[4/10]${NC} Добавление настроек базы данных в .env..."
if [ -f "/home/deployer/.env.database" ]; then
    # Читаем данные БД
    DB_NAME=$(grep DB_DATABASE /home/deployer/.env.database | cut -d'=' -f2)
    DB_USER=$(grep DB_USERNAME /home/deployer/.env.database | cut -d'=' -f2)
    DB_PASS=$(grep DB_PASSWORD /home/deployer/.env.database | cut -d'=' -f2)

    # Обновляем .env (раскомментируем и устанавливаем значения)
    sed -i "s/DB_CONNECTION=.*/DB_CONNECTION=pgsql/" .env
    sed -i "s/# DB_HOST=.*/DB_HOST=127.0.0.1/" .env
    sed -i "s/DB_HOST=.*/DB_HOST=127.0.0.1/" .env
    sed -i "s/# DB_PORT=.*/DB_PORT=5432/" .env
    sed -i "s/DB_PORT=.*/DB_PORT=5432/" .env
    sed -i "s/# DB_DATABASE=.*/DB_DATABASE=$DB_NAME/" .env
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=$DB_NAME/" .env
    sed -i "s/# DB_USERNAME=.*/DB_USERNAME=$DB_USER/" .env
    sed -i "s/DB_USERNAME=.*/DB_USERNAME=$DB_USER/" .env
    sed -i "s/# DB_PASSWORD=.*/DB_PASSWORD=$DB_PASS/" .env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$DB_PASS/" .env

    echo "Настройки базы данных добавлены"
else
    echo -e "${RED}Файл /home/deployer/.env.database не найден!${NC}"
    echo "Сначала запустите setup-database.sh"
    exit 1
fi

echo -e "${YELLOW}[5/10]${NC} Установка зависимостей Composer..."
composer install --no-dev --optimize-autoloader --no-interaction

echo -e "${YELLOW}[6/10]${NC} Генерация APP_KEY..."
if grep -q "APP_KEY=$" .env || grep -q "APP_KEY=\"\"" .env; then
    php artisan key:generate --force
    echo "APP_KEY сгенерирован"
else
    echo "APP_KEY уже установлен"
fi

echo -e "${YELLOW}[7/10]${NC} Установка NPM зависимостей и сборка фронтенда..."
npm install
npm run build

echo -e "${YELLOW}[8/10]${NC} Настройка прав доступа..."
chown -R $WEB_USER:$WEB_USER $PROJECT_DIR
chmod -R 755 $PROJECT_DIR
chmod -R 775 $PROJECT_DIR/storage
chmod -R 775 $PROJECT_DIR/bootstrap/cache

echo -e "${YELLOW}[9/10]${NC} Очистка кеша..."
sudo -u $WEB_USER php artisan config:clear 2>/dev/null || echo "Кеш будет очищен после миграций"
sudo -u $WEB_USER php artisan cache:clear 2>/dev/null || echo "Кеш будет очищен после миграций"

echo -e "${YELLOW}[10/10]${NC} Запуск миграций..."
sudo -u $WEB_USER php artisan migrate --force

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}✓ Проект успешно развернут!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Путь к проекту: $PROJECT_DIR"
echo "Public директория: $PROJECT_DIR/public"
echo ""
echo "Проверка настроек БД:"
grep DB_ $PROJECT_DIR/.env | grep -v "^#"
echo ""
echo "Следующие шаги:"
echo "1. Настройте Nginx: bash setup-nginx.sh"
echo "2. Проверьте сайт в браузере"
echo "3. Настройте SSL сертификат (после привязки домена)"
