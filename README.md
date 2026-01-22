# TERRA

![1769008885891](https://github.com/user-attachments/assets/72e7cf15-f0ed-4928-8577-03ade242d0b7)

## Project Overview:
Terra is a virtual machine that is set up to display a web server at its most fundamental level
*What it includes:*
- Hardened Ubuntu Server 24.04 LTS base
- Nginx web server with custom configuration
- Multi-layer security (UFW firewall + fail2ban intrusion prevention)
- Automated health monitoring script via cron
- Log management with logrotate
- Complete deployment automation

*Purpose:* This project is to showcase infrastructure deployment skills, security hardening, and automated monitoring - core competencies to learn cloud/devops.
## Deployment Guide
### Prerequisites
- Ubuntu Server 24.04 LTS
- SSH access to the server
- sudo privileges
### Quick Start (Automated)
```bash
# clone repository
git clone https://github.com/djmbiana/terra-production-server.git
cd terra-production-server

# Run deployment script
sudo bash deploy_terra.sh
```

The script will:
- Install nginx, UFW, and fail2ban
- Configure web server
- Set up security (firewall + brute-force protection)
- Enable automated monitoring
- Configure log rotation

### Manual Deployment
- If you prefer manual deployment, follow this step by step.
#### 1. Clone Repository
```bash
git clone https://github.com/djmbiana/terra-production-server.git
cd terra-production-server
```

#### 2. Install Required Packages
```bash
sudo apt update
sudo apt install -y nginx ufw fail2ban
```

#### 3. Configure Web Server
```bash
# Copy nginx configurations
sudo cp configs/nginx/nginx.conf /etc/nginx/
sudo cp configs/nginx/default /etc/nginx/sites-available/

# Create web root and copy files
sudo mkdir -p /data/www
sudo cp web/* /data/www/

# Test configuration and restart
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# Verify nginx is running
systemctl status nginx
```

#### 4. Configure Security

**UFW Firewall:**
```bash
# Run UFW setup script
sudo bash scripts/ufw_setup.sh

# Verify firewall rules
sudo ufw status verbose
```

**Fail2ban:**
```bash
# copy fail2ban configuration
sudo cp configs/fail2ban/jail.local /etc/fail2ban/

# restart and enable fail2ban
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Verify fail2ban is running
sudo fail2ban-client status
```

#### 5. Set Up Monitoring

**Create log directory:**
```bash
sudo mkdir -p /var/log/terra
sudo chown $USER:$USER /var/log/terra
```

**Install health check script:**
```bash
mkdir -p ~/scripts
cp scripts/health_check.sh ~/scripts/
chmod +x ~/scripts/health_check.sh
```

**Add cron job:**
```bash
crontab -e
# add this line at the end of your crontab file:
0 * * * * ~/scripts/health_check.sh
```

**Verify cron job:**
```bash
crontab -l
```

#### 6. Configure Log Rotation
```bash
# Copy logrotate configuration
sudo cp configs/logrotate/health_check /etc/logrotate.d/

# Test logrotate configuration
sudo logrotate /etc/logrotate.conf --debug
```

#### 7. Verification
After deployment, verify all services are working:
```bash
# check nginx
systemctl status nginx
curl http://localhost

# check firewall
sudo ufw status verbose

# check fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd

# check monitoring
tail -f /var/log/terra/health_check.log

# wait an hour or force a health check
~/scripts/health_check.sh
```

### Post-Deployment
- Review `docs/TROUBLESHOOTING.md` for common issues
- See `docs/MAINTENANCE.md` for ongoing maintenance tasks
- Customize configurations in `configs/` as needed for your environment

## Web Server
- Terra uses nginx as its web server
- Configuration:
  - Main config: `/etc/nginx/nginx.conf`
  - Site config: `/etc/nginx/sites-available/default`
  - Web root: `/data/www/`
  - Serves: `index.html`, `other.html`
- Port: 80 (HTTP)
- Service status: `systemctl status nginx`

## Security
- Fail2Ban and UFW configured for security hardening
- **UFW Configuration:** 
  - Logging: Medium (logs invalid packets, new connections, policy violations)
  - Default policy: Deny incoming, Allow outgoing, Deny routed
  - Allowed ports:
    - Port 22 (SSH) - LIMITED from 192.168.122.0/24 only
    - Port 80 (HTTP) - ALLOW from anywhere
    - Port 443 (HTTPS) - ALLOW from anywhere
- **Fail2Ban Configuration:**
  - Custom config: `/etc/fail2ban/jail.local`
  - Active jails:
    - `sshd` - Prevents SSH brute-force attacks
    - `nginx-bad-request` - Blocks malformed nginx requests
    - `nginx-botsearch` - Blocks malicious bot scanners
    - `nginx-http-auth` - Protects password-protected sites
    - `nginx-limit-req` - Rate limiting for nginx
  - Check status: `sudo fail2ban-client status`

## Monitoring 
### CRON
- Automated health checking with CRON
- Monitors:
	- Disk Space
	- Nginx status & errors
	- SSH login attempts
- Logs at: `/var/log/terra/health_check.log`
- Check cron jobs with `crontab -l`
- Follow the logs live with - `tail -f /var/log/terra/health_check.log`

### LOGROTATE
- Automatic log management of health check with logrotate `configs/logrotate/health_check`
- Backups:
	- Daily
	- Creates 4 compressed copies
	- Does not create empty files
