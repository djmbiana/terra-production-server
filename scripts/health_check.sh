#!/bin/bash

LOGFILE="/var/log/terra/health_check.log"

exec > >(awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> "$LOGFILE") 2>&1

DISK_SPACE=$(df --output=pcent / | tail -1 | tr -dc '0-9')
NGINX_STATUS=$(systemctl is-active nginx)
NGINX_ERRORS=$(journalctl --since "2 hours ago" -u nginx -p err --no-pager --output=cat | wc -l)
SSH_FAILED=$(grep "Failed password" /var/log/auth.log 2>/dev/null | grep "$(date '+%b %_d')" | wc -l)

echo "=== Health Check is Starting! ==="

# DISK RELATED
if [ "$DISK_SPACE" -gt 90 ]; then
    echo "ALERT: Storage is at ${DISK_SPACE}%!"
else
	echo "OK: disk space is still usable"
fi


# NGINX RELATED
if [ "$NGINX_STATUS" != "active" ]; then
	echo "ALERT: Nginx is $NGINX_STATUS (not active)"
else
	echo "OK: nginx is active"
fi

if [ "$NGINX_ERRORS" -gt 0 ]; then
	echo "WARNING: $NGINX_ERRORS nginx errors in the last 2 hours"
else 
	echo "OK: no problems with nginx"
fi

# SSH RELATED
if [ "$SSH_FAILED" -gt 5 ]; then
	echo "WARNING: $SSH_FAILED failed ssh connection attempts today"
else 
	echo "OK: $SSH_FAILED failed ssh attempts today"
fi

echo "=== Checker is over ==="
echo ""
