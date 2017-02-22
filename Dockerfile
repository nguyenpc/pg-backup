FROM ubuntu:xenial
MAINTAINER Lukasz Karolewski
RUN apt-get update && apt-get install -y wget
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
RUN apt-get update && apt-get install -y python-pip postgresql-client-9.6 cron && pip install awscli

ENV DIR /home/pg-dockup
ENV LOCAL_BACKUP_DIR $DIR/local-backup

RUN mkdir $DIR 
WORKDIR $DIR
COPY . $DIR
RUN chmod 755 $DIR/*.sh

VOLUME $LOCAL_BACKUP_DIR

ENV BACKUP_NAME pg_dump

ENV AWS_ACCESS_KEY_ID **DefineMe**
ENV AWS_SECRET_ACCESS_KEY **DefineMe**
ENV AWS_DEFAULT_REGION us-east-1
ENV AWS_S3_BUCKET_NAME **DefineMe**
ENV AWS_S3_CP_OPTIONS --sse

ENV PG_DUMP_OPTIONS --verbose
ENV PG_CONNECTION_STRING postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]

#ENV CRON_TIME * */2 * *

CMD ["./run.sh"]
