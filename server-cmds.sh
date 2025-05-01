#!/usr/bin/env bash
set -e  # Exit on error

echo "🔧 Updating system and installing Docker..."
sudo yum update -y
sudo yum install -y docker

echo "🚀 Starting and enabling Docker service..."
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user  # Won’t take effect until logout, so we still use sudo below

echo "🐳 Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.35.1"
sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Optional: verify installations
docker_version=$(sudo docker --version)
compose_version=$(sudo docker-compose --version)
echo "✅ Docker installed: $docker_version"
echo "✅ Docker Compose installed: $compose_version"

echo "⏳ Waiting for Docker to be ready..."
sleep 5

# Get parameters
export IMAGE=$1
export DOCKER_USER=$2
export DOCKER_PWD=$3

echo "🔐 Logging in to DockerHub..."
echo "$DOCKER_PWD" | sudo docker login -u "$DOCKER_USER" --password-stdin

echo "📦 Deploying image: $IMAGE..."
sudo docker-compose -f docker-compose.yaml up --detach

echo "✅ Deployment successful!"
