#!/bin/bash

# ------------------------------------------------------------------

# Script: bastion-setup.sh

# Description: Basic setup for Bastion Host (Jump Server)

# Author: Anup Das

# ------------------------------------------------------------------

set -e

echo "Starting Bastion Host setup..."

# Update system packages

echo "Updating system packages..."
sudo yum update -y

# Install essential utilities

echo "Installing required packages..."
sudo yum install -y git wget curl unzip

# Install and enable fail2ban (basic SSH protection)

echo "Installing fail2ban..."
sudo yum install -y fail2ban

echo "Enabling fail2ban service..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Configure basic fail2ban for SSH

echo "Configuring fail2ban for SSH protection..."

sudo bash -c 'cat > /etc/fail2ban/jail.local <<EOF
[sshd]
enabled = true
port = 22
logpath = /var/log/secure
maxretry = 3
bantime = 600
EOF'

sudo systemctl restart fail2ban

# Set timezone (optional)

echo "Setting timezone..."
sudo timedatectl set-timezone Asia/Kolkata

# Create a simple SSH login banner (optional security practice)

echo "Setting SSH warning banner..."

sudo bash -c 'cat > /etc/issue.net <<EOF
WARNING: Unauthorized access to this system is prohibited.
All activities are monitored and logged.
EOF'

sudo sed -i 's/^#Banner none/Banner /etc/issue.net/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Harden SSH configuration (basic level)

echo "Applying basic SSH hardening..."

sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

sudo systemctl restart sshd

echo "Bastion Host setup completed successfully."
