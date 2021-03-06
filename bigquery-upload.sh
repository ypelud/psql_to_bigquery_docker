#!/bin/bash

# taken from this blog : https://statsbot.co/blog/postgres-to-bigquery-etl/
# thanks to them

 
function upload_day {
  table=$1
  sel=$2
  day=$3  
  field=$4
  bq_suffix=$(date -d "$day" +%Y%m%d)
  echo "Uploading $table: $day with $field..."
  psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_NAME  -c "\\copy (select $sel from $table where date($field) = '$day') TO '$table-$day.csv' WITH CSV HEADER"
  gzip $table-$day.csv
  bq load .$table$bq_suffix $table-$day.csv.gz
  rm $table-$day.csv.gz
};
 
function upload_table {
  t=$1
  s=$2
  start_date=$3
  end_date=$4
  f=$5

  if [ -z "$start_date" ]; then
    start_date=$(date +%Y%m%d)
  fi

  if [ "$start_date" == 'yesterday' ]; then
    start_date=$(date -d "1 day ago" +%Y%m%d)
  fi

  if [ -z "$end_date" ]; then
    end_date=$start_date
  fi

  if [ -z "$f" ]; then
    f="created_at"
  fi

  while [ "$start_date" -le "$end_date" ]; do
       upload_day "$t" "$s" "$start_date" "$f"
       start_date=$(date -d "$start_date+1 days" +%Y%m%d)
  done
}

function multi_tables {
  tables=$(echo "$1" | tr ";" "\n")
  shift # remove first args

  for t in $tables
  do
    upload_table "$t" '*' "$@"
  done

}

export PGPASSWORD=$POSTGRES_PASSWORD

FILE=/root/.bigquery.json

if [ -f $FILE ]; then
  multi_tables $@
else
   echo "/root/.bigquery.json doesn't exists"
fi



