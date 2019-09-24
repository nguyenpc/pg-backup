
# pg-dockup

Recurring backup of your postgres database to s3, with local copy for instant access.

# Usage

Specify following environment variables:

```
# postgres connection string
PG_CONNECTION_STRING=postgresql://user:password@ip[:port]/dbname

# pg_dump options to be appended to pg_dump command
# by default: PG_DUMP_OPTIONS=--verbose

# aws credentials
AWS_ACCESS_KEY_ID=<key_here>
AWS_SECRET_ACCESS_KEY=<secret_here>
AWS_DEFAULT_REGION=us-east-1

# bucket where backup will be uploaded
AWS_S3_BUCKET_NAME=my-backups.example.com
# prefix for pg_dump files
# by default: BACKUP_NAME=pg_dump  

# awscli cp command option to be appended, refer to `http://docs.aws.amazon.com/cli/latest/reference/s3/cp.html`
# by default: AWS_S3_CP_OPTIONS=--sse AES256

# if defined will install cron, time in UTC. By default will run backup once and exit
CRON_TIME=0 2 * * *

SLACK_HOOK=https://hooks.slack.com/services/xxxxxx/xxxxxx/xxxxxx
SLACK_USERNAME=PGDockupBot
SLACK_CHANNEL="#general"
SLACK_EMOJI=":ghost:"
SLACK_MESSAGE="Data has been backed up and uploaded to s3 successfully"

```

## Backup
Just run the image:

```
$ docker run --rm \
--env-file env.txt \
--name pg-dockup 
lkarolewski/pg-dockup:latest
```

## Restore

Connect to container using `docker exec -it <container name> /bin/bash` 


Last 7 backups are stored locally in `/home/pg-dockup/local-backup`.


To retieve last backup from s3:
- `./download_last.sh`


To restore db:
 - `./restore.sh <filename>`
