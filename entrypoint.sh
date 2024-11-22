#!/bin/sh
set -e

rm -f /app/tmp/pids/server.pid

echo "Waiting for database to be ready..."
until nc -z $DB_HOST $DB_PORT; do
  sleep 1
done
echo "Database is ready!"

echo "Running database setup..."
bundle exec rails db:create db:migrate

echo "Starting Rails server..."
exec "$@"