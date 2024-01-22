#!/bin/sh

set -e

rm -f /rails-app/tmp/pids/server.pid

bundle exec rails s -b 0.0.0.0
