#!/bin/bash
#
# PostgreSQL Database Setup для Laravel проекта Larka
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Параметры базы данных
DB_NAME="larka_db"
DB_USER="larka_user"
DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)

if [ "$EUID" -ne 0 ]; then
    echo "Запустите скрипт с sudo или от root"
    exit 1
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}PostgreSQL Database Setup${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

echo -e "${YELLOW}[1/4]${NC} Создание базы данных '$DB_NAME'..."
sudo -u postgres psql -c "CREATE DATABASE $DB_NAME;" 2>/dev/null || echo "База данных уже существует"

echo -e "${YELLOW}[2/4]${NC} Создание пользователя '$DB_USER'..."
sudo -u postgres psql -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';" 2>/dev/null || echo "Пользователь уже существует"

echo -e "${YELLOW}[3/4]${NC} Выдача прав пользователю..."
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;"
sudo -u postgres psql -c "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"

echo -e "${YELLOW}[4/4]${NC} Сохранение конфигурации..."
cat > /home/deployer/.env.database << EOF
# PostgreSQL Database Configuration
# Добавьте эти строки в .env файл Laravel проекта

DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=$DB_NAME
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASSWORD
EOF

chown deployer:deployer /home/deployer/.env.database

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}✓ База данных настроена!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "База данных: $DB_NAME"
echo "Пользователь: $DB_USER"
echo "Пароль: $DB_PASSWORD"
echo ""
echo -e "${YELLOW}ВАЖНО:${NC} Сохраните эти данные!"
echo "Конфигурация сохранена в: /home/deployer/.env.database"
echo ""
echo "Проверка подключения:"
PGPASSWORD=$DB_PASSWORD psql -h 127.0.0.1 -U $DB_USER -d $DB_NAME -c "SELECT version();" | head -3
