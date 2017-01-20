
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

Last 7 backups are stored locally in `/home/pg-dockup/local-backup`.


If that's missing:
- connect to container `docker exec -it container_name /bin/bash` 
- run `download_last.sh` to fetch last uploaded backup 


Once you have local backup, create container that has pgsql installed: `docker run --rm -it --volumes-from pg-dockup --link you_pg_db_container:pg postgres:9.5 /bin/bash`


To restore db:
 - `psql -h host -U user dbname -c 'CREATE database dbname;'`
 - `cat backup_file.tar.gz | gunzip | psql -h host -U user dbname` 