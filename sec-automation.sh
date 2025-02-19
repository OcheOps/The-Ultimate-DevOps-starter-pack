#!/bin/bash

# Security Automation Script
# Installs security tools and sends a notification to Teams or Slack

LOG_FILE="/var/log/security_tools_install.log"
NOTIFY_TOOL=${NOTIFY_TOOL:-teams}  # Default to Teams if not set

# Define Teams and Slack Webhook URLs (Replace with actual URLs)
TEAMS_WEBHOOK_URL="https://outlook.office.com/webhook/YOUR_TEAMS_WEBHOOK_URL"
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK"

log_and_echo() {
    echo "$1" | tee -a "$LOG_FILE"
}

log_and_echo "Starting Security Tool Installation..."

# Update system and install tools
log_and_echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

log_and_echo "Installing Fail2Ban..."
sudo apt install -y fail2ban
sudo systemctl enable --now fail2ban

log_and_echo "Installing ClamAV..."
sudo apt install -y clamav clamav-daemon
sudo systemctl enable --now clamav-freshclam

log_and_echo "Installing Lynis..."
sudo apt install -y lynis

log_and_echo "Installing Trivy (Container Security Scanner)..."
sudo apt install -y trivy

log_and_echo "Installing OpenSCAP (Vulnerability Scanner)..."
sudo apt install -y libopenscap8 scap-security-guide

log_and_echo "Installing AIDE (File Integrity Monitoring)..."
sudo apt install -y aide
sudo aideinit

log_and_echo "Security tools installation completed."

# Prepare notification message
MESSAGE="Security tools installation completed successfully on $(hostname)"

send_notification() {
    if [ "$NOTIFY_TOOL" == "teams" ]; then
        curl -H "Content-Type: application/json" -d "{\"text\": \"$MESSAGE\"}" "$TEAMS_WEBHOOK_URL"
    elif [ "$NOTIFY_TOOL" == "slack" ]; then
        curl -X POST -H 'Content-type: application/json' --data "{\"text\": \"$MESSAGE\"}" "$SLACK_WEBHOOK_URL"
    else
        log_and_echo "Unknown notification tool: $NOTIFY_TOOL. Skipping notification."
    fi
}

send_notification

log_and_echo "Script execution completed."
exit 0
