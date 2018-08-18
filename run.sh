#!/bin/bash

./backup.sh

if [ -n "$CRON_TIME" ]; then
  CRON_FILE=/etc/cron.d/pg-dockup

  # force set environment vars 
  env > /etc/environment
  
  # configure cron
  echo "$CRON_TIME root $DIR/backup.sh >> /var/log/cron.log 2>&1" > $CRON_FILE
  echo "# Don't remove the empty line at the end of this file. It is required to run the cron job" >> $CRON_FILE
  
  chmod 0644 $CRON_FILE
  touch /var/log/cron.log

  echo "=> Backup running with following schedule $CRON_TIME"
  cron && tail -f /var/log/cron.log
fi
