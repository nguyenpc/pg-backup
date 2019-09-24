FROM ubuntu:bionic
LABEL maintainer="Lukasz Karolewski"

ENV BACKUP_NAME pg_dump
ENV AWS_S3_CP_OPTIONS --sse AES256
ENV PG_DUMP_OPTIONS --verbose
ENV DIR /home/backup
ENV LOCAL_BACKUP_DIR $DIR/local-backup
ENV SLACK_HOOK
ENV SLACK_USERNAME PGDockupBot
ENV SLACK_CHANNEL "#general"
ENV SLACK_EMOJI ":ghost:"
ENV SLACK_MESSAGE "Data has been backed up and uploaded to s3 successfully"

RUN mkdir $DIR 
WORKDIR $DIR

VOLUME $LOCAL_BACKUP_DIR

RUN apt-get update && apt-get upgrade -y
RUN apt-get install wget gnupg2 curl -y
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main' >> /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN apt-get update && apt-get install -y cron python-pip postgresql-client-11
RUN pip install awscli

COPY . $DIR

CMD ["./run.sh"]
