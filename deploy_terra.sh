#!/bin/bash
set -e

echo "-- terra server setup --"
echo ""

if [ ! -f "scripts/health_check.sh" ]; then
    echo "Error: Must be executed from terra-production-server directory"
    exit 1
fi

echo "installing packages..."
sudo apt update
sudo apt install -y nginx ufw fail2ban

echo ""
echo "configuring nginx..."
sudo cp configs/nginx/nginx.conf /etc/nginx/
sudo cp configs/nginx/default /etc/nginx/sites-available/
sudo mkdir -p /data/www
sudo cp web/* /data/www/
sudo nginx -t && sudo systemctl restart nginx
sudo systemctl enable nginx

echo ""
echo "configuring security..."
sudo bash scripts/ufw_setup.sh
sudo cp configs/fail2ban/jail.local /etc/fail2ban/
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

echo ""
echo "setting up monitoring..."
sudo mkdir -p /var/log/terra
sudo chown $(whoami):$(whoami) /var/log/terra
mkdir -p ~/scripts
cp scripts/health_check.sh ~/scripts/
chmod +x ~/scripts/health_check.sh
(crontab -l 2>/dev/null; echo "0 * * * * /home/$(whoami)/scripts/health_check.sh") | crontab -

echo ""
echo "configuring log rotation..."
sudo cp configs/logrotate/health_check /etc/logrotate.d/

echo ""
echo "-- deployment complete! --"
echo ""
echo "verify services:"
echo "  systemctl status nginx"
echo "  sudo ufw status verbose"
echo "  sudo fail2ban-client status"
echo "  crontab -l"
echo ""
echo "check logs:"
echo "  tail -f /var/log/terra/health_check.log"
