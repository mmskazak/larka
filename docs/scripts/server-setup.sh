#!/bin/bash
#
# Laravel Server Setup Script
# Ubuntu 22.04 LTS
#
# Этот скрипт устанавливает всё необходимое для Laravel:
# - Nginx
# - PHP 8.4 + расширения
# - Composer
# - Node.js 20 LTS + NPM
# - PostgreSQL 15
# - Supervisor (для очередей)
# - Certbot (для SSL)

set -e  # Остановка при ошибке

echo "========================================="
echo "Laravel Server Setup"
echo "========================================="
echo ""

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Проверка sudo
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Запустите скрипт с sudo:${NC}"
    echo "sudo bash server-setup.sh"
    exit 1
fi

echo -e "${GREEN}[1/11]${NC} Обновление системы..."
apt update && apt upgrade -y

echo -e "${GREEN}[2/11]${NC} Установка базовых пакетов..."
apt install -y \
    software-properties-common \
    curl \
    wget \
    git \
    unzip \
    supervisor \
    ufw \
    certbot \
    python3-certbot-nginx

echo -e "${GREEN}[3/11]${NC} Установка Nginx..."
apt install -y nginx

echo -e "${GREEN}[4/11]${NC} Добавление репозитория PHP..."
add-apt-repository -y ppa:ondrej/php
apt update

echo -e "${GREEN}[5/11]${NC} Установка PHP 8.4 и расширений..."
apt install -y \
    php8.4-fpm \
    php8.4-cli \
    php8.4-common \
    php8.4-mysql \
    php8.4-pgsql \
    php8.4-sqlite3 \
    php8.4-zip \
    php8.4-gd \
    php8.4-mbstring \
    php8.4-curl \
    php8.4-xml \
    php8.4-bcmath \
    php8.4-intl \
    php8.4-redis

echo -e "${GREEN}[6/11]${NC} Настройка PHP 8.4 как версии по умолчанию..."
update-alternatives --set php /usr/bin/php8.4

echo -e "${GREEN}[7/11]${NC} Установка Composer..."
curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

echo -e "${GREEN}[8/11]${NC} Установка Node.js 20 LTS..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

echo -e "${GREEN}[9/11]${NC} Установка PostgreSQL 15..."
apt install -y postgresql postgresql-contrib

echo -e "${GREEN}[10/11]${NC} Настройка firewall (UFW)..."
ufw --force enable
ufw allow OpenSSH
ufw allow 'Nginx Full'
ufw status

echo -e "${GREEN}[11/11]${NC} Проверка установленных версий..."
echo ""
echo "PHP: $(php -v | head -n 1)"
echo "Composer: $(composer --version | head -n 1)"
echo "Node.js: $(node -v)"
echo "NPM: $(npm -v)"
echo "Nginx: $(nginx -v 2>&1)"
echo "PostgreSQL: $(psql --version)"
echo ""
echo "PHP-FPM статус:"
systemctl status php8.4-fpm --no-pager | head -3
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}✓ Установка завершена!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Следующие шаги:"
echo "1. Настройте PostgreSQL базу данных: bash setup-database.sh"
echo "2. Разверните Laravel проект: bash deploy-project.sh"
echo "3. Настройте Nginx: bash setup-nginx.sh"
echo "4. Настройте SSL с Certbot (после привязки домена)"
echo ""
echo "Подробности смотрите в docs/SERVER-SETUP.md"
