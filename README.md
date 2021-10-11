


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

## Maintenance

### Generate archive

Get database dump and load in the dev database, then run

```
docker-compose run web bundle exec rake archive
```

This will generate a zip archive with all the invoice and returns as pdfs in `/web/tmp/media`.

### Reset all

```
heroku run --app miss-blabla bundle exec rake wipe_all
```
