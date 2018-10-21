#!/bin/bash

CRON_TIME=${CRON_TIME:="0 8 * * *"}
LOGFILE=/var/log/backup.log

./backup.sh >> $LOGFILE 2>&1

if [ -n "$CRON_TIME" ]; then
  echo "=> configured crontab for backup with $CRON_TIME schedule"

  # set environment vars for cron
  env > /etc/environment
  
  # configure crontab
  CRON_FILE=/etc/cron.d/backup
  echo "$CRON_TIME root $DIR/backup.sh >> $LOGFILE 2>&1" > $CRON_FILE
  printf "\n" >> $CRON_FILE # needs a newline
  
  chmod 0644 $CRON_FILE

  # https://stackoverflow.com/questions/21926465/issues-running-cron-in-docker-on-different-hosts
  sed -e '/pam_loginuid.so/ s/^#*/#/' -i /etc/pam.d/cron

  service cron start && tail -f $LOGFILE
fi
