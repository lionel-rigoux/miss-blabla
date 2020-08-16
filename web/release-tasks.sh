#!/bin/sh

rake db:migrate
rake assets:precompile
