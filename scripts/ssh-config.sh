# ------------------------------------------------------------------

# File: ssh-config

# Location: ~/.ssh/config

# Description: SSH configuration for Bastion + Private EC2 access

# Author: Anup Das

# ------------------------------------------------------------------

# =========================

# Bastion Host Configuration

# =========================

Host bastion
HostName <BASTION-PUBLIC-IP>
User ec2-user
IdentityFile ~/.ssh/your-key.pem
IdentitiesOnly yes
StrictHostKeyChecking no
ServerAliveInterval 60
ServerAliveCountMax 3

# =========================

# Private App Server (via Bastion)

# =========================

Host private-app
HostName <PRIVATE-IP>
User ec2-user
IdentityFile ~/.ssh/your-key.pem
ProxyJump bastion
IdentitiesOnly yes
StrictHostKeyChecking no
ServerAliveInterval 60
ServerAliveCountMax 3

# =========================

# Optional: Debug Mode

# =========================

Host debug-private
HostName <PRIVATE-IP>
User ec2-user
IdentityFile ~/.ssh/your-key.pem
ProxyJump bastion
LogLevel DEBUG
