#!/bin/bash
set -e

# Change to the directory of the script
cd "$(dirname "$0")"

# Stop any running containers
docker compose down

# Pull the latest images
docker compose pull

# Run migrations
docker compose run --rm web bundle exec rails db:migrate

# Start the containers in detached mode
docker compose up -d --remove-orphans

# Clean up old images and volumes
docker image prune -f
docker volume prune -f 