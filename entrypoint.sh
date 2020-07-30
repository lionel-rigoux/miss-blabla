#!/bin/bash
set -e

>&2 echo "Migrating database"
rake db:create
rake db:migrate

# Remove a potentially pre-existing server.pid for Rails.
rm -f /myapp/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
