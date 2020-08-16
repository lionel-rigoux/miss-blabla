#!/bin/sh
bundle exec rake assets:precompile
bundle exec rake db:migrate
