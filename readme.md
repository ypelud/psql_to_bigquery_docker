# Postresql to Bigquery Docker

This is Docker image for creating batch for uploading data from Postgresql to BigQuery.

## Supported tags

* `ypelud/psql-bigquery:latest`

&rarr; Check out [Docker Hub](https://hub.docker.com/r/ypelud/psql-bigquery/tags/) for available tags.

[![Docker Pulls](https://img.shields.io/docker/pulls/ypelud/psql-bigquery.svg)]()
[![Docker Build Status](https://img.shields.io/docker/build/ypelud/psql-bigquery.svg)]()
[![Docker Automated buil](https://img.shields.io/docker/automated/ypelud/psql-bigquery.svg)]()

## Usage

To use this image, pull from [Docker Hub](https://hub.docker.com/r/ypelud/psql-bigquery/), run the following command:


```
docker pull ypelud/psql-bigquery:latest
```

Download file `.bigqueryrc` and change values to suit your project:

```
curl https://raw.githubusercontent.com/ypelud/psql_to_bigquery_docker/master/.bigqueryrc.sample > .bigqueryrc
```

Download file `commun.env` and change values to suit your project :

```
curl https://raw.githubusercontent.com/ypelud/psql_to_bigquery_docker/master/commun.env.sample > commun.env
```

[Create a service account key](https://cloud.google.com/docs/authentication/getting-started) for Cloud API and copy credentials file into `.bigquery.json`.


Then, run a test:

```
docker run -ti  --rm \
  -v $PWD/.bigquery.json:/root/.bigquery.json \
  -v $PWD/.bigqueryrc:/root/.bigqueryrc \
  --env-file ./commun.env \
  ypelud/psql-bigquery
```

You can now run export like this one, this push all rows from table messages with created_at equal today.

```
docker run -ti --rm \
  -v $PWD/.bigquery.json:/root/.bigquery.json \
  -v $PWD/.bigqueryrc:/root/.bigqueryrc \
  --env-file ./commun.env \
  psql-bigquery ./bigquery-upload.sh messages \
  "20180216" "20180217"
```


You can now run export like this one, this export all rows from messages with updated_at between February 16, 2018 and February 19, 2018.

```
docker run -ti --rm \
  -v $PWD/.bigquery.json:/root/.bigquery.json \
  -v $PWD/.bigqueryrc:/root/.bigqueryrc \
  --env-file ./commun.env \
  psql-bigquery ./bigquery-upload.sh messages \
  "20180216" "20180219" updated_at
```
