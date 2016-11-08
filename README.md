
# pg-dockup

Docker image to backup your postgres database deployed to Docker container

Why the name? pg_dump + docker + backup = pg-dockup

# Usage
Link this container to your postgres db

## Backup
Launch `pg-dockup` container with the following flags:

```
$ docker run --rm \
--env-file env.txt \
--link mysql \
--name dockup tutum/dockup:latest
```

The contents of `env.txt` being:

```
BACKUP_NAME=backup

AWS_ACCESS_KEY_ID=<key_here>
AWS_SECRET_ACCESS_KEY=<secret_here>
AWS_DEFAULT_REGION=us-east-1
AWS_S3_BUCKET_NAME=docker-backups.example.com
AWS_S3_CP_OPTIONS='--sse'

PG_DUMP_OPTIONS='--verbose'
PG_CONNECTION_STRING='postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]'

CRON_TIME='* */2 * *'
```

for `AWS_S3_CP_OPTIONS` refer to `http://docs.aws.amazon.com/cli/latest/reference/s3/cp.html`

`pg-dockup` will use your AWS credentials to create a new bucket with name as per the environment variable `AWS_S3_BUCKET_NAME`, or if not defined, using the default name `docker-backups.example.com`. The paths in `PATHS_TO_BACKUP` will be tarballed, gzipped, time-stamped and uploaded to the S3 bucket.


## Restore
connect to running container 

`docker exec -it container_name /bin/bash`

last 7 backups are stored locally in `/home/pg-dockup/local-backup`
if that's missing, use `download_last.sh` to fetch last uploaded backup to above directory

to restore, make sure database was created and db run `cat backup_file.tar.gz | gunzip | psql -U user dbname` 

## A note on Buckets

> [Bucket naming guidelines](http://docs.aws.amazon.com/cli/latest/userguide/using-s3-commands.html):
> "Bucket names must be unique and should be DNS compliant. Bucket names can contain lowercase letters, numbers, hyphens and periods. Bucket names can only start and end with a letter or number, and cannot contain a period next to a hyphen or another period."

These rules are enforced in some regions.


[AWS S3 Regions](http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region)

| Region name               | Region         |
| ------------------------- | -------------- |
| US Standard               | us-east-1      |
| US West (Oregon)          | us-west-2      |
| US West (N. California)   | us-west-1      |
| EU (Ireland)              | eu-west-1      |
| EU (Frankfurt)            | eu-central-1   |
| Asia Pacific (Singapore)  | ap-southeast-1 |
| Asia Pacific (Sydney)     | ap-southeast-2 |
| Asia Pacific (Tokyo)      | ap-northeast-1 |
| South America (Sao Paulo) | sa-east-1      |


To perform a restore launch the container with the RESTORE variable set to true