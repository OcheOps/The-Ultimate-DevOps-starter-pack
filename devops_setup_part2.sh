#!/bin/bash

set -e  # Stop script if any command fails

echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "Installing required dependencies..."
sudo apt install -y curl wget git unzip ufw jq htop net-tools tree software-properties-common

# --- PART 1: CORE DEVOPS TOOLS ---
echo "Installing Docker..."
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION="v2.27.0"
sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Installing Nginx..."
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx

echo "Configuring Firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable -y

echo "Installing Certbot for SSL..."
sudo apt install -y certbot python3-certbot-nginx

# --- PART 2: MONITORING TOOLS ---
echo "Installing Prometheus, Grafana, and Node Exporter..."
mkdir -p ~/monitoring && cd ~/monitoring

echo "Installing Prometheus..."
wget https://github.com/prometheus/prometheus/releases/download/v2.50.0/prometheus-2.50.0.linux-amd64.tar.gz
tar -xvzf prometheus-2.50.0.linux-amd64.tar.gz
sudo mv prometheus-2.50.0.linux-amd64 /usr/local/prometheus

echo "Installing Node Exporter..."
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar -xvzf node_exporter-1.7.0.linux-amd64.tar.gz
sudo mv node_exporter-1.7.0.linux-amd64 /usr/local/node_exporter

echo "Installing Grafana..."
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
sudo apt update
sudo apt install -y grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Starting Prometheus and Node Exporter..."
sudo /usr/local/prometheus/prometheus --config.file=/usr/local/prometheus/prometheus.yml --web.listen-address=":9090" &
sudo /usr/local/node_exporter/node_exporter --web.listen-address=":9100" &

# --- PART 3: KUBERNETES & OTHER DEVOPS TOOLS ---
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

echo "Installing Kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install kubectl /usr/local/bin/kubectl

echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Installing Terraform..."
wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip
unzip terraform_1.7.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/

echo "Installing Ansible..."
sudo apt update
sudo apt install -y ansible

# --- Print Installation Summary ---
echo "========================================"
echo "✅ DevOps Environment Setup Complete!"
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "Nginx version: $(nginx -v 2>&1)"
echo "Certbot version: $(certbot --version)"
echo "Prometheus is running on port 9090"
echo "Grafana is running on port 3000"
echo "Node Exporter is running on port 9100"
echo "Kubernetes Tools Installed: minikube, kubectl, Helm"
echo "Terraform and Ansible Installed"
echo "========================================"

echo "Reboot your system to apply changes. Run: sudo reboot"
