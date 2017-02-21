#!/bin/sh
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

# Get timestamp
readonly LOCAL_BACKUP=$LOCAL_BACKUP_DIR/$BACKUP_NAME-$(date +%A).gzip
readonly REMOTE_BACKUP=$BACKUP_NAME-$(date +"%Y-%m-%dT%H:%M:%SZ").gzip

# Run backup
pg_dump --dbname=$PG_CONNECTION_STRING $PG_DUMP_OPTIONS | gzip > $LOCAL_BACKUP

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aws s3 ls | grep $AWS_S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
then
  aws s3 mb s3://$AWS_S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp $LOCAL_BACKUP s3://$AWS_S3_BUCKET_NAME/$REMOTE_BACKUP $AWS_S3_CP_OPTIONS
