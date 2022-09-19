


## Usage

```
docker-compose up -d && docker attach $(docker-compose ps -q web)
```

## Initialisation of the database

Before the first use, run:

```
docker-compose up -d db
docker-compose run --entrypoint "" web rake db:setup
docker-compose stop db
```

## Seeding the database from production

Get dump from heroku

```
heroku pg:backups:capture --app miss-blabla
heroku pg:backups:download --app miss-blabla
```

Load in the dev database

```
docker-compose up -d db
docker-compose run web rake db:reset
cat latest.dump | docker-compose exec -T db pg_restore -d myapp_development -U postgres
docker-compose stop db
```

docker exec -i miss-blabla-db-1 pg_restore --verbose --clean --no-acl --no-owner -U postgres -d myapp_development < xxx.dump

docker exec -i miss-blabla-db-1 pg_restore -U postgres --verbose --clean --no-acl --no-owner -h localhost -d myapp_development < db_backup_file


## Maintenance

### Generate archive

**Online**

```
heroku run -a miss-blabla sh
bundle exec rake archive
curl -F "file=@/web/tmp/media/archive.zip" https://file.io
```

This will generate a zip archive with all the invoice and returns as pdfs in `/web/tmp/media`. As the filesystem in the dyno is ephemeral, `heroku ps:copy` will not work, hence the upload trick. Use the `link` in the results to download the archive.

**Locally**

```
docker-compose run web bundle exec rake archive
```


### Reset all

```
heroku run --app miss-blabla bundle exec rake wipe_all
```
