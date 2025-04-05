This script installs essential **DevOps tools** on an **Ubuntu server**.

## 🚀 Features

- **Part 1: Core Tools**
  - **Docker** & **Docker Compose**
  - **Nginx** (Web Server)
  - **Certbot** (SSL via Let's Encrypt)
  - **UFW** (Firewall)
  - **Git, Curl, Unzip, Net-tools**



## 🔧 How to Use

### 1️⃣ **Download and Run the Script**
```sh
wget https://raw.githubusercontent.com/OcheOps/The-Ultimate-DevOps-starter-pack/main/devops_setup.sh
chmod +x devops_setup.sh
./devops_setup.sh

Ansible  command 

ansible-playbook -i hosts.ini devops-setup.yml

