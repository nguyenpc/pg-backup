FROM alpine:edge
MAINTAINER Lukasz Karolewski

RUN apk add --no-cache postgresql-client 

RUN \
	apk -Uuv add groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

ENV DIR /home/pg-dockup
ENV LOCAL_BACKUP_DIR $DIR/local-backup

RUN mkdir -p $DIR 
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

CMD ["$DIR/run.sh"]
