# Export the Heroku PG database to a local dump file
# https://devcenter.heroku.com/articles/heroku-postgres-import-export#export
heroku pgbackups:capture
curl -o latest.dump `heroku pgbackups:url`

# Install postregs & Setup  password
# https://help.ubuntu.com/community/PostgreSQL

# List databases
sudo -u postgres psql -l

# Create database for data
# http://www.commandprompt.com/ppbook/x17149
sudo -u postgres psql template1
template1=# CREATE DATABASE bikedb

# or
sudo -u postgres createdb bikedb

# Run restore script with options
# http://antonzolotov.com/2012/03/04/rails-scripts-clone-heroku-database-to-development.html
sudo -u postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -d bikedb latest.dump


# Dump the data (only, not structure) from postgres to normal SQL
# https://yuji.wordpress.com/2011/05/25/postgresql-sqlite-django-migrating-postgresql-to-sqlite3-with-pg_dump/
# http://www.linuxtopia.org/online_books/database_guides/Practical_PostgreSQL_database/PostgreSQL_x17860_001.htm
sudo -u postgres pg_dump --inserts -a -b bikedb > data.sql

# Clear all data from the development database
bundle exec rake db:drop
bundle exec rake db:schema:load


# Read data into development database
# https://yuji.wordpress.com/2011/05/25/postgresql-sqlite-django-migrating-postgresql-to-sqlite3-with-pg_dump/
sqlite3 development.sqlite3
> .read data.sql


# Additional import-export
# Use taps gem
# https://rubygems.org/gems/taps-taps/versions/0.3.24
# https://github.com/wijet/taps
