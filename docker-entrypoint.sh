#!/bin/bash
set -e

FILE=/root/.bigquery.json
export PGPASSWORD=$POSTGRES_PASSWORD

if [ -f $FILE ]; then
   gcloud auth activate-service-account --key-file $FILE
   gcloud auth list
else
   echo "/root/.bigquery.json doesn't exists"
fi

exec "$@"
