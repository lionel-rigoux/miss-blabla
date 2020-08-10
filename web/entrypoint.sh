#!/bin/bash
set -e

>&2 echo "$RAKE_ENV"

>&2 echo "Migrating database"
rake db:migrate

# Remove a potentially pre-existing server.pid for Rails.
rm -f /web/tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
