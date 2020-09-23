#!/bin/sh
echo $RAILS_ENV
bundle exec rake assets:precompile
bundle exec rake db:migrate
