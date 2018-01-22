#!/usr/bin/env bash

cat $1 | gunzip | psql --dbname=$PG_CONNECTION_STRING