#!/bin/bash

set -e  # Stop script if any command fails

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y curl wget git unzip ufw

# --- Install Docker ---
echo "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER  # Add current user to Docker group

# --- Install Docker Compose ---
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.27.0"
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# --- Install Nginx ---
echo "Installing Nginx..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

# --- Configure Firewall ---
echo "Configuring Firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable -y

# --- Install Certbot for SSL ---
echo "Installing Certbot..."
sudo apt install -y certbot python3-certbot-nginx

# --- Install Other DevOps Tools ---
echo "Installing additional DevOps tools..."
sudo apt install -y jq htop net-tools tree

# --- Print Installation Summary ---
echo "========================================"
echo "✅ DevOps Environment Setup Complete!"
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "Nginx version: $(nginx -v 2>&1)"
echo "Certbot version: $(certbot --version)"
echo "========================================"

echo "Reboot your system to apply changes. Run: sudo reboot"
