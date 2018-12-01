#!/usr/bin/env bash
set -e
set -x

echo "Starting backup"
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

# Generate filenames
readonly $BACKUP_FILENAME=$BACKUP_NAME-$(date +"%Y-%m-%dT%H:%M:%SZ").gzip
readonly LOCAL_BACKUP_PATH=$LOCAL_BACKUP_DIR/$BACKUP_FILENAME

# Run backup
pg_dump --dbname=$PG_CONNECTION_STRING $PG_DUMP_OPTIONS | gzip > $LOCAL_BACKUP_PATH

# Keep backups from last 30 days locally
find . -type f -name '*.gzip' -mtime +30 -delete

# Upload the backup to S3
aws s3 --region $AWS_DEFAULT_REGION cp $LOCAL_BACKUP_PATH s3://$AWS_S3_BUCKET_NAME/$BACKUP_FILENAME $AWS_S3_CP_OPTIONS
echo "backup done"
