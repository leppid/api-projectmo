#!/bin/sh
# remove server pids if they are exist
set -e

rm -f /api/tmp/pids/server.pid

RAILS_ENV=development rails db:create db:migrate db:seed
# bundle exec sidekiq&

exec "$@"