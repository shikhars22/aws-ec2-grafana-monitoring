#!/bin/bash

# Update and upgrade system packages
echo "Updating packages..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Download and run the official Docker convenience installer
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add current user to the docker group so you don't need sudo
echo "Adding user $USER to docker group..."
sudo usermod -aG docker $USER

# Clean up the installer script
rm get-docker.sh

# Verify Docker installation immediately using the new group context
echo "Verifying Docker installation..."
sg docker -c "docker run hello-world"

echo "Applying group changes to current session..."
# Apply the docker group changes to your active shell session
newgrp docker
