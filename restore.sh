#!/usr/bin/env bash
# unzip & restore
cat $1 | gunzip | psql --dbname=$PG_CONNECTION_STRING
