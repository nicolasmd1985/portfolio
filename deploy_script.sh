#!/bin/bash
set -e

# Default to production if not specified
ENV=${ENV:-production}

# Change to the directory of the script
cd "$(dirname "$0")"

echo "🚀 Starting deployment for $ENV environment..."

# Stop any running containers
echo "📦 Stopping existing containers..."
ENV=$ENV docker compose down

# Pull the latest images
echo "⬇️ Pulling latest images..."
ENV=$ENV docker compose pull

# Run migrations
echo "🔄 Running database migrations..."
ENV=$ENV docker compose run --rm web bundle exec rails db:migrate

# Start the containers in detached mode
echo "🚀 Starting containers..."
ENV=$ENV docker compose up -d --remove-orphans

# Wait for services to be healthy
echo "⏳ Waiting for services to be healthy..."
sleep 10

# Verify the application is running
if curl -s http://localhost:3002 > /dev/null; then
    echo "✅ Application is running successfully!"
else
    echo "❌ Application failed to start properly!"
    exit 1
fi

# Clean up old images and volumes
echo "🧹 Cleaning up unused resources..."
docker image prune -f
docker volume prune -f

echo "✨ Deployment completed successfully!" 