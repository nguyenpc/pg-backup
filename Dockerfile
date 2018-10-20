FROM ubuntu:bionic
LABEL maintainer="Lukasz Karolewski"

ENV BACKUP_NAME pg_dump
ENV AWS_S3_CP_OPTIONS --sse AES256
ENV PG_DUMP_OPTIONS --verbose
ENV DIR /home/backup
ENV LOCAL_BACKUP_DIR $DIR/local-backup

RUN mkdir $DIR 
WORKDIR $DIR

VOLUME $LOCAL_BACKUP_DIR

RUN apt-get update && apt-get install -y cron python-pip postgresql-client-10
RUN pip install awscli

COPY . $DIR

CMD ["./run.sh"]
