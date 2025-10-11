#!/bin/bash
#
# Setup Nginx for Laravel
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo "Запустите с sudo или от root"
    exit 1
fi

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}Nginx Configuration Setup${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

echo -e "${YELLOW}[1/5]${NC} Копирование конфигурации..."
cp /home/deployer/larka.conf /etc/nginx/sites-available/larka

echo -e "${YELLOW}[2/5]${NC} Отключение default сайта..."
rm -f /etc/nginx/sites-enabled/default

echo -e "${YELLOW}[3/5]${NC} Активация сайта larka..."
ln -sf /etc/nginx/sites-available/larka /etc/nginx/sites-enabled/

echo -e "${YELLOW}[4/5]${NC} Проверка конфигурации Nginx..."
nginx -t

echo -e "${YELLOW}[5/5]${NC} Перезапуск Nginx..."
systemctl restart nginx

echo ""
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}✓ Nginx настроен!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "Статус Nginx:"
systemctl status nginx --no-pager | head -5
echo ""
echo "Сайт доступен по адресу:"
echo "http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP')"
