# Miss Blabla

## Production

### Deploy to Fly.io

After starting Docker desktop for local building:

```sh
flyctl deploy  --local-only
```

### Backup production db

Proxy distant db:

```sh
flyctl proxy 5432 -a miss-blabla-db &
```

Recover db secret url:

```sh
# Log in to the VM
flyctl ssh console
# display internal url
echo $DATABASE_URL
# > postgres://miss_blabla:<password>@<server>.miss-blabla-db.internal:5432/miss_blabla
```

Copy the password and exit the ssh session (ctrl-D).

Download a dump of the current state

```sh
pg_dump --verbose  --no-acl --clean \
  -d postgres://miss_blabla:<password>@localhost:5432/miss_blabla  
  -f ./latest.dump
```

## Development

### Start local VM

```sh
docker-compose up -d && docker attach $(docker-compose ps -q web)
```

### Initialisation of local database

Before the first use, run:

```sh
docker-compose up -d db
docker-compose run --entrypoint "" web rake db:setup
docker-compose stop db
```

### Seeding the database from production

Load in the dev database

```sh
docker-compose up -d db
docker-compose run web rake db:reset
cat latest.dump | docker-compose exec -T db psql  myapp_development -U postgres
docker-compose stop db
```

## Maintenance

### Generate archive

**Online**

> TODO: use fly volumes

```sh
flyctl ssh console
bundle exec rake archive
curl -F "file=@/web/tmp/media/archive.zip" https://file.io
```

This will generate a zip archive with all the invoice and returns as pdfs in `/web/tmp/media`. As the filesystem in the dyno is ephemeral, `heroku ps:copy` will not work, hence the upload trick. Use the `link` in the results to download the archive.

**Locally**

```sh
docker-compose run web bundle exec rake archive
```


### Reset all

```sh
flyctl ssh console
bundle exec rake wipe_all
```
