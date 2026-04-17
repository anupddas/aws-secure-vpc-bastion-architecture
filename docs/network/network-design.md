# Network Design — Secure VPC with Bastion Host Architecture


## Overview

This document describes the network architecture implemented in this project, focusing on **security**, **isolation**, and **controlled access** using a bastion host. The design follows industry best practices for deploying applications within a secure Amazon Web Services (AWS) Virtual Private Cloud (VPC).

The architecture ensures that private resources are not directly exposed to the internet while still allowing controlled administrative access.

## Architecture Summary

The network is designed using a two-tier subnet architecture:

* Public Subnet (Bastion Host)
* Private Subnet (Private Application Server)

Traffic flow:

Client → Bastion Host (Public Subnet) → Private EC2 Instance (Private Subnet)


## VPC Configuration

* **VPC Name:** secure-vpc-lab
* **CIDR Block:** 10.0.0.0/16

The VPC provides an isolated network environment with a large IP address range to support scalability.


## Subnet Design

### Public Subnet

* **Name:** public-subnet-1
* **CIDR Block:** 10.0.1.0/24
* **Availability Zone:** Single AZ (configurable)
* **Public IP Assignment:** Enabled

**Purpose:**

* Hosts the bastion server
* Allows inbound SSH access from the internet
* Routes traffic through the Internet Gateway


### Private Subnet

* **Name:** private-subnet-1
* **CIDR Block:** 10.0.2.0/24
* **Availability Zone:** Same as public subnet
* **Public IP Assignment:** Disabled

**Purpose:**

* Hosts the application server
* Completely isolated from direct internet access
* Accessible only via bastion host


## Internet Gateway

* **Name:** secure-vpc-igw
* **Attached to:** secure-vpc-lab

**Function:**

* Enables internet connectivity for resources in the public subnet
* Acts as a bridge between the VPC and the internet


## Route Tables

### Public Route Table

* **Name:** public-route-table
* **Associated Subnet:** public-subnet-1

**Routes:**

* 0.0.0.0/0 → Internet Gateway

**Purpose:**

* Allows outbound internet access for bastion host
* Enables inbound traffic via public IP


### Private Route Table

* Uses default/main route table
* No route to Internet Gateway

**Purpose:**

* Ensures private subnet remains isolated
* Prevents direct internet access


## Security Groups

### Bastion Security Group (bastion-sg)

**Inbound Rules:**

* SSH (Port 22) → Allowed only from Admin's IP address

**Purpose:**

* Restricts access to trusted sources
* Acts as the only entry point into the VPC


### Private App Security Group (private-app-sg)

**Inbound Rules:**

* SSH (Port 22) → Allowed only from bastion-sg

**Purpose:**

* Ensures private instance is not accessible from the internet
* Enforces access through bastion host only


## Access Flow

1. Admin connects to bastion host using SSH via public IP
2. Bastion host connects to private EC2 instance using private IP
3. Direct access from user to private instance is blocked

This design enforces strict access control and minimizes attack surface.


## Key Design Principles

### Network Isolation

Private subnet resources are fully isolated from the internet.

### Least Privilege Access

Access to private resources is restricted to a single trusted source (bastion host).

### Defense in Depth

Multiple layers of security:

* Subnet isolation
* Route table restrictions
* Security group controls

### Controlled Entry Point

All administrative access is funneled through the bastion host.


## Optional Enhancements (Not Implemented to Save Cost)

* NAT Gateway for outbound internet access from private subnet
* Multi-AZ deployment for high availability
* VPN or Direct Connect for enterprise connectivity
* AWS Systems Manager Session Manager to replace SSH


## Conclusion

This network design demonstrates a secure and scalable approach to deploying applications in AWS. By combining VPC isolation, subnet segmentation, and strict access control via a bastion host, the architecture aligns with real-world cloud security practices.

It provides a strong foundation for building production-ready, secure cloud environments.
