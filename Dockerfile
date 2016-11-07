FROM ubuntu:xenial
MAINTAINER Lukasz Karolewski

RUN apt-get update && apt-get install -y python-pip postgresql-client-9.5 cron && pip install awscli

ENV DIR /home/pg-dockup
ENV LOCAL_BACKUP_DIR $DIR/local-backup

RUN mkdir $DIR 
WORKDIR $DIR
COPY . $DIR
RUN chmod 755 /*.sh

VOLUME $LOCAL_BACKUP_DIR

ENV BACKUP_NAME pg_dump

ENV AWS_ACCESS_KEY_ID **DefineMe**
ENV AWS_SECRET_ACCESS_KEY **DefineMe**
ENV AWS_DEFAULT_REGION us-east-1
ENV AWS_S3_BUCKET_NAME **DefineMe**

ENV PG_DUMP_OPTIONS --verbose
ENV PG_CONNECTION_STRING postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]

#ENV CRON_TIME * */2 * *
#ENV CRON_MAILTO admin@some.domain.com

CMD ["bash $DIR/run.sh"]