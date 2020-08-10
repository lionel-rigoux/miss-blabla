
## Usage

```
docker-compose up
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
heroku pg:backups:download --app miss-blabla"
```

Load in the dev database

```
docker-compose up -d db
docker-compose run web rake db:reset
cat latest.dump | docker-compose exec -T db pg_restore -d myapp_development -U postgres
docker-compose stop db
```
