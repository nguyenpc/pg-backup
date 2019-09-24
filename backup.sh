#!/usr/bin/env bash
set -e
set -x

echo "Starting backup"
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

# Generate filenames
readonly BACKUP_FILENAME=$BACKUP_NAME-$(date +"%Y-%m-%dT%H-%M-%SZ")
readonly LOCAL_BACKUP_PATH=$LOCAL_BACKUP_DIR/$BACKUP_FILENAME

# Run backup
pg_dump --dbname=$PG_CONNECTION_STRING $PG_DUMP_OPTIONS > $LOCAL_BACKUP_PATH

# check if not empty
if [ ! -s $LOCAL_BACKUP_PATH ]; then 
  rm -f $LOCAL_BACKUP_PATH
  echo "empty backup, exiting"
  exit 1
fi

cat $LOCAL_BACKUP_PATH | gzip > $LOCAL_BACKUP_PATH.gzip

# Remove uncompressed pg_dump and prune local gzipped backups older than 30 days 
rm -f $LOCAL_BACKUP_PATH
find . -type f -name '*.gzip' -mtime +30 -delete

# Upload the backup to S3
aws s3 --region $AWS_DEFAULT_REGION cp $LOCAL_BACKUP_PATH.gzip s3://$AWS_S3_BUCKET_NAME/$BACKUP_FILENAME.gzip $AWS_S3_CP_OPTIONS
 
if [ -s $SLACK_HOOK ];
then 
  SLACK_MESSAGE="$SLACK_MESSAGE - $BACKUP_FILENAME"
  PAYLOAD="payload={\"channel\": \"$SLACK_CHANNEL\", \"username\": \"$SLACK_USERNAME\", \"text\": \"$SLACK_MESSAGE\", \"icon_emoji\": \"$SLACK_EMOJI\"}"
  curl -X POST --data-urlencode "$PAYLOAD" "$SLACK_HOOK"
fi

echo "backup done"
