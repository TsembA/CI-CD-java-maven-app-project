#!/usr/bin/env bash

export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3

echo "🔐 Logging in to DockerHub..."
echo "$DOCKER_PWD" | sudo docker login -u "$DOCKER_USER" --password-stdin

echo "📦 Starting containers with image: $IMAGE..."
sudo docker-compose -f docker-compose.yaml up --detach

echo "✅ Deployment successful!"
