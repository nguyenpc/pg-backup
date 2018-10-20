#!/bin/bash

./backup.sh

CRON_TIME=${CRON_TIME:="0 8 * * *"}

if [ -n "$CRON_TIME" ]; then
  echo "=> Backup running with $CRON_TIME schedule"

  # set environment vars for cron
  env > /etc/environment
  
  # configure crontab
  CRON_FILE=/etc/cron.d/backup
  echo "$CRON_TIME root $DIR/backup.sh >> /var/log/cron.log 2>&1" > $CRON_FILE
  printf "\n" >> $CRON_FILE # needs a newline
  
  chmod 0644 $CRON_FILE
  touch /var/log/cron.log

  cron && tail -f /var/log/cron.log
fi
