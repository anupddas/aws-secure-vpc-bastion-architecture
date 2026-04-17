# Bastion Access Flow — Secure SSH Access to Private EC2 Instances

## Overview

This document explains how secure SSH access is implemented using a bastion host within a custom Amazon Web Services (AWS) Virtual Private Cloud (VPC). The design ensures that private EC2 instances are not exposed to the internet while still allowing controlled administrative access.

The bastion host acts as a secure intermediary, enforcing a single entry point into the private network.


## Access Architecture

The SSH access flow follows a controlled, two-step connection process:

Client → Bastion Host (Public Subnet) → Private EC2 Instance (Private Subnet)

* The bastion host is the only instance with a public IP address.
* The private EC2 instance has no public IP and cannot be accessed directly from the internet.
* All administrative access is routed through the bastion host.


## Step-by-Step Access Flow

### Step 1: Connect to Bastion Host

From a local machine, establish an SSH connection to the bastion host using its public IP address:

```bash
ssh -i your-key.pem ec2-user@<BASTION-PUBLIC-IP>
```

In our case:

```bash
ssh -i bastion-host.pem ec2-user@13.172.238.73
```

**Requirements:**

* Bastion host must be running
* Security group must allow SSH access from the user's IP
* Key pair must have correct permissions (chmod 400)



### Step 2: Access Private EC2 Instance from Bastion

Once connected to the bastion host, establish a second SSH connection to the private EC2 instance using its private IP address:

```bash
ssh -i your-key.pem ec2-user@<PRIVATE-IP>
```

In our case:

```bash
ssh -i bastion-host.pem ec2-user@10.0.2.243
```

**Requirements:**

* Private instance must be running
* Security group must allow SSH access from bastion security group
* Both instances must reside within the same VPC


## SSH Key Management

Two approaches are commonly used:

### Option 1: Copy Key to Bastion Host

Transfer the SSH key to the bastion host:

```bash
scp -i your-key.pem your-key.pem ec2-user@<BASTION-PUBLIC-IP>:/home/ec2-user/
```

In our case:

```bash
ssh -i bastion-host.pem bastion-host.pem ec2-user@13.172.238.73:/home/ec2-user/
```

Set correct permissions:

```bash
chmod 400 your-key.pem
```

In our case:

```bash
chmod 400 bastion-host.pem
```

**Consideration:**

* Simpler to implement
* Less secure if bastion is compromised


### Option 2: SSH Agent Forwarding (Recommended)

Enable agent forwarding:

```bash
ssh -A -i bastion-host.pem ec2-user@13.127.23.8.73
```

Then connect to private instance:

```bash
ssh ec2-user@10.0.2.243
```

**Advantages:**

* No need to store private key on bastion host
* More secure approach
* Preferred in production environments


## Security Controls

### Bastion Host

* Publicly accessible via SSH (restricted to specific IP)
* Acts as the only entry point into the VPC
* Protected by a tightly controlled security group


### Private EC2 Instance

* No public IP assigned
* Not accessible directly from the internet
* Accepts SSH connections only from bastion security group


## Access Restrictions

* Direct SSH from client to private EC2 instance is blocked
* Internet access to private subnet is disabled
* Only authorized users with correct SSH keys can access bastion host


## Common Failure Scenarios and Fixes

### Cannot SSH into Bastion Host

**Possible Causes:**

* Incorrect security group rules
* Wrong IP restriction
* Instance not running

**Resolution:**

* Verify inbound rule allows SSH from your IP
* Check instance state and public IP


### Cannot SSH from Bastion to Private Instance

**Possible Causes:**

* Missing security group rule on private instance
* Incorrect private IP
* Key file not available or incorrect permissions

**Resolution:**

* Ensure private security group allows SSH from bastion-sg
* Verify private IP address
* Check key file permissions


### Permission Denied (Public Key)

**Possible Causes:**

* Incorrect key pair used
* Key permissions too open

**Resolution:**

```bash
chmod 400 your-key.pem
```


## Best Practices

* Restrict SSH access to specific IP addresses
* Avoid storing private keys on bastion host (use agent forwarding)
* Use least-privilege security group rules
* Regularly rotate SSH keys
* Monitor access logs for unauthorized attempts


## Conclusion

The bastion access model provides a secure and controlled method to manage private EC2 instances in AWS. By enforcing a single entry point and restricting direct access, this architecture significantly reduces the attack surface while maintaining operational accessibility.

This approach aligns with industry best practices for secure cloud infrastructure design.
