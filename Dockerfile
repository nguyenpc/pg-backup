FROM ubuntu:xenial
MAINTAINER Lukasz Karolewski

RUN apt-get update && apt-get install -y python-pip postgresql-client-9.5 cron && pip install awscli

ADD backup.sh /backup.sh
ADD restore.sh /restore.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh

ENV S3_BUCKET_NAME docker-backups.example.com
ENV AWS_ACCESS_KEY_ID **DefineMe**
ENV AWS_SECRET_ACCESS_KEY **DefineMe**
ENV AWS_DEFAULT_REGION us-east-1
ENV PG_DUMP_OPTIONS --verbose
ENV PG_CONNECTION_STRING postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]
ENV BACKUP_NAME backup
ENV RESTORE false
#ENV CRON_TIME * */2 * *
#ENV CRON_MAILTO admin@some.domain.com

CMD ["/run.sh"]