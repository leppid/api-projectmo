#!/bin/sh
set -e

rake assets:precompile
rails db:migrate
# bundle exec sidekiq&

exec "$@"