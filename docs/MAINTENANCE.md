# TERRA MAINTENANCE

## NGINX
- **Weekly:** Review nginx logs for any error

```bash
  sudo tail -n 50 /var/log/nginx/error.log
```

- **Monthly:** Check disk space for logs

```bash
  du -sh /var/log/nginx/
```

- **After config changes:** Test syntax before restarting

```bash
  sudo nginx -t && sudo systemctl restart nginx
```

## FAIL2BAN
- **Weekly:** Check banned IPs and review logs

```bash
  sudo fail2ban-client status sshd
  sudo tail -n 50 /var/log/fail2ban.log
```

- **Configuration:** Always edit `.local` files (not `.conf`) to prevent overwrites during updates

## Monitoring
- **Daily:** Review health check logs for issues

```bash
  tail -50 /var/log/terra/health_check.log
```
- **Weekly:** Verify cron job is still running

```bash
  grep "health_check" /var/log/syslog | tail -10
```

## LOGROTATE
- **Daily:** Check if the rotation is working correctly

```bash
ls /var/log/terra/
# Check if there are compressed copies of health_check.log being created
```

- **Weekly:** Verify old copies are being automatically deleted
```bash
ls /var/log/terra/ | grep health_check | wc -l
# Should be 5 total (current + 4 backups)
```
