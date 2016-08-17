#!/bin/bash

if [[ "$RESTORE" == "true" ]]; then
  ./restore.sh
else
  ./backup.sh
fi

if [ -n "$CRON_TIME" ]; then
  # force set environment vars 
  env > /etc/environment
  
  # create brand new crontab.conf
  if [ -n "$CRON_MAILTO" ]; then
    echo 'MAILTO="${CRON_MAILTO}"' > /crontab.conf
  else
    echo "" > /crontab.conf
  fi

  # configure cron and email only stderr 
  echo "${CRON_TIME} /backup.sh >> /dockup.log /dev/null" >> /crontab.conf
  crontab  /crontab.conf
  echo "=> Running dockup backups as a cronjob for ${CRON_TIME}" error will be mailed to ${CRON_MAILTO}
  exec cron -f
fi
