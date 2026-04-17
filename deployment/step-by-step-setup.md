# Step-by-Step Setup — Secure VPC with Bastion Host Architecture

## Overview

This guide provides a complete, step-by-step procedure to deploy a secure Amazon Web Services (AWS) Virtual Private Cloud (VPC) architecture with a bastion host and a private EC2 instance.

The setup demonstrates how to implement network isolation, controlled SSH access, and secure communication between resources.

## Prerequisites

Before starting, ensure you have:

* An active AWS account
* Access to AWS Management Console
* A key pair (.pem file) for EC2 access
* Basic understanding of EC2 and VPC concepts

## Step 1: Create Custom VPC

1. Navigate to VPC Dashboard
2. Click **Create VPC**
3. Select **VPC only**

**Configuration:**

* Name: secure-vpc-lab
* IPv4 CIDR Block: 10.0.0.0/16

4. Click **Create VPC**


## Step 2: Create Internet Gateway

1. Go to **Internet Gateways**
2. Click **Create Internet Gateway**

**Configuration:**

* Name: secure-vpc-igw

3. Attach to VPC:

   * Select VPC: secure-vpc-lab


## Step 3: Create Public Subnet

1. Go to **Subnets → Create Subnet**

**Configuration:**

* Name: public-subnet-1
* VPC: secure-vpc-lab
* CIDR: 10.0.1.0/24
* Availability Zone: Any

2. Enable:

* Auto-assign public IPv4 address


## Step 4: Configure Public Route Table

1. Go to **Route Tables → Create**

**Configuration:**

* Name: public-route-table
* VPC: secure-vpc-lab

2. Associate with:

* public-subnet-1

3. Add Route:

* Destination: 0.0.0.0/0
* Target: Internet Gateway


## Step 5: Launch Bastion Host

1. Go to EC2 → Launch Instance

**Configuration:**

* Name: bastion-host
* AMI: Amazon Linux
* Instance Type: t2.micro
* Subnet: public-subnet-1
* Public IP: Enabled

2. Create Security Group:

* Name: bastion-sg

**Inbound Rules:**

* SSH (22) → Your IP

3. Launch instance


## Step 6: Create Private Subnet

1. Go to **Subnets → Create Subnet**

**Configuration:**

* Name: private-subnet-1
* CIDR: 10.0.2.0/24
* Auto-assign Public IP: Disabled

## Step 7: Launch Private App Server

1. Go to EC2 → Launch Instance

**Configuration:**

* Name: private-app-server
* AMI: Amazon Linux
* Instance Type: t2.micro
* Subnet: private-subnet-1
* Public IP: Disabled

2. Create Security Group:

* Name: private-app-sg

**Inbound Rules:**

* SSH (22) → Source: bastion-sg

3. Launch instance


## Step 8: Connect to Bastion Host

From local machine:

```bash id="azpjok"
ssh -i your-key.pem ec2-user@<BASTION-PUBLIC-IP>
```


## Step 9: Access Private Server via Bastion

### Option 1: Copy Key

```bash id="xjxxh9"
scp -i your-key.pem your-key.pem ec2-user@<BASTION-PUBLIC-IP>:/home/ec2-user/
chmod 400 your-key.pem
ssh -i your-key.pem ec2-user@<PRIVATE-IP>
```

### Option 2: SSH Agent Forwarding (Recommended)

```bash id="m24q6k"
ssh -A -i your-key.pem ec2-user@<BASTION-PUBLIC-IP>
ssh ec2-user@<PRIVATE-IP>
```

## Step 10: Verify Architecture

* Bastion host accessible via public IP
* Private instance has no public IP
* Direct SSH to private instance fails
* SSH via bastion works successfully


## Final Architecture Flow

Client → Bastion Host → Private EC2 Instance


## Common Issues and Fixes

### Cannot SSH into Bastion

* Check security group allows SSH from your IP

### Cannot Access Private Instance

* Ensure private security group allows SSH from bastion-sg

### Permission Denied

* Set correct key permissions:

```bash id="wp8fqi"
chmod 400 your-key.pem
```


## Cost Optimization Tips

* Use t2.micro instances (free tier eligible)
* Stop instances when not in use
* Avoid NAT Gateway and Load Balancer
* Delete resources after completion


## Conclusion

This step-by-step setup demonstrates how to build a secure AWS network using a bastion host and private subnet architecture. The design ensures that sensitive resources remain protected while still allowing controlled administrative access.

This approach aligns with real-world cloud security practices and is highly relevant for cloud engineering and DevOps roles.
