# TERRA

## Web Service
- Terra uses nginx as its web server
- Configuration:
  - Main config: `/etc/nginx/nginx.conf`
  - Site config: `/etc/nginx/sites-available/default`
  - Web root: `/data/www/`
  - Serves: `index.html`, `other.html`
- Port: 80 (HTTP)
- Service status: `systemctl status nginx`
