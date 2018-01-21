#!/bin/bash

./backup.sh

if [ -n "$CRON_TIME" ]; then
  # force set environment vars 
  env > /etc/environment
  
  # configure cron
  echo "$CRON_TIME root $DIR/backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/pg-dockup
  chmod 0644 /etc/cron.d/pg-dockup
  touch /var/log/cron.log

  echo "=> Running dockup backups with following crontab $CRON_TIME"
  cron && tail -f /var/log/cron.log
fi
