# Failure Scenarios and Troubleshooting — Secure VPC with Bastion Access

## Overview

This document outlines common failure scenarios encountered in a secure AWS VPC architecture using a bastion host for controlled access. Each scenario includes the root cause, debugging approach, and resolution steps.

Understanding and resolving these issues is critical for operating production-grade cloud environments.


## Troubleshooting Approach

When diagnosing issues, we will follow a structured approach:

> **Verify instance state -> Check network configuration -> Validate security groups and access rules -> Confirm SSH key configuration and permissions**

This layered approach ensures efficient identification of root causes.


## Scenario 1: Unable to SSH into Bastion Host

### Symptoms

* SSH connection times out
* No response from public IP

### Possible Causes

* Missing or incorrect inbound rule in security group
* Incorrect public IP
* Instance is stopped

### Debugging Steps

* Confirm bastion instance is in running state
* Verify public IP address
* Check security group inbound rules

### Resolution

* Add inbound rule:

  * SSH (Port 22) → Source: Your IP
* Restart instance if necessary


## Scenario 2: Unable to SSH from Bastion to Private Instance

### Symptoms

* SSH command hangs or times out from bastion
* No connection to private IP

### Possible Causes

* Private instance security group does not allow SSH from bastion
* Incorrect private IP address
* Instances are in different VPCs

### Debugging Steps

* Verify private instance is running
* Confirm private IP address
* Check security group configuration

### Resolution

* Update private security group:

  * SSH (Port 22) → Source: bastion security group
* Ensure both instances are in the same VPC


## Scenario 3: Permission Denied (Public Key)

### Symptoms

* SSH error: Permission denied (publickey)

### Possible Causes

* Incorrect key pair used
* Key file permissions are too open

### Debugging Steps

* Verify correct key file is being used
* Check file permissions

### Resolution

```bash
chmod 400 your-key.pem
```

* Ensure correct key pair is associated with the instance

In our case:

```bash
chmod 400 bastion-host.pem
```


## Scenario 4: Private Instance Not Reachable

### Symptoms

* SSH fails even with correct configuration
* Connection timeout from bastion

### Possible Causes

* Instance is stopped
* Network misconfiguration
* Incorrect subnet association

### Debugging Steps

* Check instance state
* Verify subnet and VPC configuration
* Confirm routing setup

### Resolution

* Start the instance
* Ensure instance is deployed in correct private subnet
* Validate network configuration


## Scenario 5: Private Instance Accidentally Exposed

### Symptoms

* Able to SSH directly from local machine to private instance
* Private instance has public IP

### Possible Causes

* Public IP assigned to private instance
* Security group allows SSH from 0.0.0.0/0

### Debugging Steps

* Check instance details for public IP
* Review security group rules

### Resolution

* Disable public IP assignment
* Restrict SSH access:

  * Source: bastion security group only


## Scenario 6: Bastion Host Compromise Risk

### Symptoms

* Bastion host accessible from any IP
* Weak access restrictions

### Possible Causes

* Security group allows SSH from 0.0.0.0/0

### Debugging Steps

* Review inbound rules of bastion security group

### Resolution

* Restrict SSH access:

  * Source: Your IP only


## Scenario 7: SSH Key Not Available on Bastion

### Symptoms

* Unable to connect to private instance from bastion
* Key file not found

### Possible Causes

* Key not copied to bastion
* Incorrect file path

### Debugging Steps

* List files in home directory
* Verify key file presence

### Resolution

* Copy key using SCP:

```bash
scp -i your-key.pem your-key.pem ec2-user@<BASTION-PUBLIC-IP>:/home/ec2-user/
```

In our case:

```bash
scp -i bastion-host.pem bastion-host.pem ec2-user@13.127.238.73:/home/ec2-user/
```

* Set correct permissions:

```bash
chmod 400 your-key.pem
```


## Scenario 8: Incorrect Route Table Configuration

### Symptoms

* Bastion host cannot access internet
* Connectivity issues within VPC

### Possible Causes

* Missing route to Internet Gateway
* Subnet not associated with correct route table

### Debugging Steps

* Check route table configuration
* Verify subnet associations

### Resolution

* Add route:

  * Destination: 0.0.0.0/0
  * Target: Internet Gateway
* Associate correct route table with public subnet


## Best Practices for Avoiding Failures

* Use least-privilege security group rules
* Avoid assigning public IPs to private resources
* Maintain clear subnet separation
* Regularly validate network configurations
* Use consistent key management practices


## Conclusion

Failure scenarios are an integral part of building robust cloud systems. This project demonstrates not only how to deploy secure infrastructure but also how to identify and resolve real-world issues effectively.
