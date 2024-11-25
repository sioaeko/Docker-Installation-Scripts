#!/bin/bash

# Check if script is run with root privileges
if [ "$EUID" -ne 0 ]; then 
    echo "This script must be run as root"
    echo "Please run again with: sudo bash $0"
    exit 1
fi

# Update system packages
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install required packages
echo "Installing required packages..."
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list
apt-get update

# Install Docker
echo "Installing Docker..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Install Docker Compose
echo "Installing Docker Compose..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

# Add current user to docker group
USER_NAME=$(logname)
usermod -aG docker $USER_NAME

# Verify installation
echo "Verifying installation..."
docker --version
docker compose version

echo "Installation completed successfully!"
echo "Please either restart your system or run the following command to apply docker group changes:"
echo "newgrp docker"

# Additional information
echo ""
echo "To verify Docker installation, you can run:"
echo "docker run hello-world"
echo ""
echo "Common Docker commands:"
echo "- docker ps         : List running containers"
echo "- docker images    : List downloaded images"
echo "- docker --help    : Show Docker help"
