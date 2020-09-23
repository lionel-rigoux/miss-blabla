#!/bin/sh
echo $RAILS_ENV
bundle exec rake db:migrate
