# Security Groups Configuration — Secure VPC with Bastion Host

## Overview

This document describes the security group configuration used in this project to enforce controlled access within a secure Amazon Web Services (AWS) Virtual Private Cloud (VPC).

Security groups act as virtual firewalls that regulate inbound and outbound traffic at the instance level. This architecture applies the principle of least privilege to minimize exposure and ensure secure communication between resources.


## Security Design Principles

The configuration is based on the following principles:

* **Least Privilege Access** — Only required ports and sources are allowed
* **Network Isolation** — Private resources are not exposed to the internet
* **Controlled Entry Point** — All access is routed through a bastion host
* **Security Group Referencing** — Internal communication is restricted using security group IDs instead of IP ranges


## Security Groups Overview

Two primary security groups are used:

1. Bastion Security Group (`bastion-sg`)
2. Private Application Security Group (`private-app-sg`)


## Bastion Security Group (bastion-sg)

### Purpose

The bastion security group controls access to the publicly accessible bastion host. It ensures that only authorized users can initiate SSH connections.


### Inbound Rules

| Type | Protocol | Port | Source  |
| ---- | -------- | ---- | ------- |
| SSH  | TCP      | 22   | My IP |


### Outbound Rules

| Type        | Protocol | Port | Destination |
| ----------- | -------- | ---- | ----------- |
| All Traffic | All      | All  | 0.0.0.0/0   |


### Explanation

* SSH access is restricted to a specific IP address
* Prevents unauthorized access from the internet
* Outbound traffic is allowed to enable connections to private subnet resources


## Private Application Security Group (private-app-sg)

### Purpose

This security group protects the private EC2 instance by restricting access exclusively to the bastion host.


### Inbound Rules

| Type | Protocol | Port | Source     |
| ---- | -------- | ---- | ---------- |
| SSH  | TCP      | 22   | bastion-sg |


### Outbound Rules

| Type        | Protocol | Port | Destination |
| ----------- | -------- | ---- | ----------- |
| All Traffic | All      | All  | 0.0.0.0/0   |


### Explanation

* SSH access is allowed only from the bastion host
* Security group reference ensures dynamic and secure internal communication
* No direct internet access is permitted


## Traffic Flow Enforcement

The security groups enforce the following access pattern:

* User → Bastion Host → Private EC2 Instance
* Direct access from user → Private EC2 Instance is blocked

This ensures that all administrative access is routed through a controlled entry point.


## Common Misconfigurations

### 1. Allowing SSH from 0.0.0.0/0

**Issue:**

* Bastion becomes publicly accessible from anywhere

**Fix:**

* Restrict source to specific IP address


### 2. Using IP Instead of Security Group Reference

**Issue:**

* Less secure and harder to maintain

**Fix:**

* Use bastion-sg as source for private-app-sg


### 3. Assigning Public IP to Private Instance

**Issue:**

* Bypasses security model

**Fix:**

* Disable public IP assignment


### 4. Missing Inbound Rule for Bastion Access

**Issue:**

* Cannot SSH into private instance

**Fix:**

* Add SSH rule with source bastion-sg


## Best Practices

* Restrict SSH access to known IP addresses
* Use security group references for internal communication
* Avoid exposing private resources to the internet
* Regularly audit security group rules
* Remove unused or overly permissive rules


## Conclusion

The security group configuration in this project enforces strict access control and aligns with AWS best practices for secure infrastructure design. By combining least-privilege rules with controlled access through a bastion host, the architecture significantly reduces the attack surface and ensures secure communication between resources.

This approach reflects real-world cloud security implementations used in production environments.
