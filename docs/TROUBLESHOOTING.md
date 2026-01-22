# TROUBLE SHOOTING DOCUMENTATION

## NGINX

### Website not loading?
1. **Check if nginx is running:**
```bash
systemctl status nginx
```

2. **Check if port 80 is in use:**
```bash
sudo lsof -i :80
```
   If another service is using it, stop that service first.

3. **Verify configuration syntax:**
```bash
sudo nginx -t
```
   Fix any errors shown before restarting.

4. **Check web root path:**
   - Ensure files exist in `/data/www/`
   - Verify `root` directive in `/etc/nginx/sites-available/default` points to `/data/www/`

5. **Check logs:**
```bash
sudo tail -n 50 /var/log/nginx/error.log
```

## UFW 
### SSH connection failing?
1. **Check if sshd is running:**
```bash
systemctl status ssh
# if it isn't, enable it
```

2. **Check authorized_keys**
```bash
cat ~/.ssh/authorized_keys
# if your public key is not present, quickly add it and try again
```

3. **Check physical connection**
- SSH is only configured on my local IP, so check if you are connected within the local network

## CRON
### Health check script not running?
1. **Check if cron is running:**
```bash
systemctl status cron
# If it isn't running, enable it with systemctl
```

2. **Check user crontab**
```bash
crontab -l
# if it returns empty, create a cron job with crontab -e
```

3. **View cron logs**
```bash
grep "CRON" /var/log/syslog | tail -20
```

4. **Verify if ``health_check.sh`` is executable**
```bash
ls -l ~/scripts/health_check.sh
```


## LOGROTATE
### Rotations not backing up health_check.log?
1. **Check health_check logrotate config:**
```bash
cat /etc/logrotate.d/health_check
# Look for typos or syntax errors
```

2. **Test rotation manually:**
```bash
sudo logrotate /etc/logrotate.conf --force
```

3. **Verify backups created:**
```bash
ls -lh /var/log/terra/
# Should see health_check.log.1, .2.gz, etc.
```

4. **Check logrotate status:**
```bash
cat /var/lib/logrotate/status | grep health_check
```
