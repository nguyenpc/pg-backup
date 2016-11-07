#!/bin/bash

# Get timestamp
readonly REMOTE_BACKUP=$BACKUP_NAME-$(date +"%Y-%m-%dT%H:%M:%SZ").tar.gz
readonly LOCAL_BACKUP=/tmp/$BACKUP_NAME-$(date +%A).tar.gz

# Run backup
pg_dump --dbname=$PG_CONNECTION_STRING $PG_DUMP_OPTIONS | gzip > $LOCAL_BACKUP

# Create bucket, if it doesn't already exist
BUCKET_EXIST=$(aws s3 ls | grep $S3_BUCKET_NAME | wc -l)
if [ $BUCKET_EXIST -eq 0 ];
then
  aws s3 mb s3://$S3_BUCKET_NAME
fi

# Upload the backup to S3 with timestamp
aws s3 --region $AWS_DEFAULT_REGION cp $LOCAL_BACKUP s3://$S3_BUCKET_NAME/$REMOTE_BACKUP