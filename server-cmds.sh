#!/usr/bin/env bash
set -e  # Exit on error

echo "🔧 Updating system and installing Docker..."
sudo yum update -y
sudo yum install -y docker

echo "🚀 Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user  # Will apply on next login

echo "🐳 Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose || true

# Ensure Docker Compose works
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose installation failed. Exiting..."
    exit 1
fi

echo "✅ Docker installed: $(sudo docker --version)"
echo "✅ Docker Compose installed: $(sudo docker-compose --version)"

echo "⏳ Waiting for Docker to be ready..."
sleep 5

# Read parameters
export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3

# Create .env file for docker-compose
echo "IMAGE=$IMAGE" > .env

echo "🔐 Logging in to DockerHub..."
echo "$DOCKER_PWD" | sudo docker login -u "$DOCKER_USER" --password-stdin

echo "📦 Deploying image: $IMAGE..."
sudo docker-compose --env-file .env -f docker-compose.yaml up --detach

echo "✅ Deployment successful!"
