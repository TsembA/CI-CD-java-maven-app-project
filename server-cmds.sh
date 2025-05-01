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
DOCKER_COMPOSE_VERSION="1.29.2"
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version


# Ensure /usr/local/bin is in the PATH
export PATH=$PATH:/usr/local/bin

# Check if docker-compose was installed correctly
if ! command -v docker-compose &> /dev/null; then
    echo "❌ docker-compose installation failed. Exiting..."
    exit 1
fi

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
