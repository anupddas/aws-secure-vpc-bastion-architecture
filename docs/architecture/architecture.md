# Architecture Diagram — Secure VPC with Bastion Host

## Overview

This document explains the architecture diagram for a secure Amazon Web Services (AWS) Virtual Private Cloud (VPC) implementation using a bastion host to control access to private resources.

The design demonstrates a production-style network setup with strict access control, subnet isolation, and secure SSH connectivity.

## Architecture Diagram

![Secure VPC Architecture](../docs/architecture-diagram.png)


## High-Level Architecture

The architecture is built using a two-tier network model:

* Public Subnet for controlled external access
* Private Subnet for secure internal resources

All traffic flows through a single controlled entry point.


## Components Breakdown

### 1. Virtual Private Cloud (VPC)

* **Name:** secure-vpc-lab
* **CIDR Block:** 10.0.0.0/16

The VPC acts as an isolated network environment that hosts all resources in this architecture.



### 2. Public Subnet

* **CIDR Block:** 10.0.1.0/24
* **Purpose:** Hosts the bastion host

Key characteristics:

* Connected to the Internet Gateway
* Allows inbound SSH access from a restricted IP range
* Assigns public IP addresses to instances


### 3. Bastion Host (Jump Server)

* Deployed in the public subnet
* Accessible via public IP
* Serves as the only entry point into the private network

Responsibilities:

* Accept SSH connections from authorized users
* Forward access to private instances
* Enforce controlled access



### 4. Private Subnet

* **CIDR Block:** 10.0.2.0/24
* **Purpose:** Hosts the application server

Key characteristics:

* No public IP assignment
* No direct internet access
* Fully isolated from external traffic


### 5. Private Application Server

* Deployed in the private subnet
* Accessible only from the bastion host
* Not exposed to the internet

This ensures maximum security for backend resources.


### 6. Internet Gateway

* Attached to the VPC
* Enables internet access for the public subnet

It allows the bastion host to:

* Receive inbound SSH traffic
* Initiate outbound connections if required


### 7. Route Tables

#### Public Route Table

* Route: 0.0.0.0/0 → Internet Gateway
* Associated with public subnet

#### Private Route Table

* No route to Internet Gateway
* Ensures isolation of private subnet


## Traffic Flow Explanation

The diagram illustrates the following access pattern:

1. User initiates SSH connection from local machine
2. Traffic reaches the Internet Gateway
3. Internet Gateway routes traffic to bastion host in public subnet
4. Bastion host authenticates user
5. Bastion initiates SSH connection to private application server
6. Private server responds through bastion

Direct access to the private server from the internet is not possible.


## Security Model

The architecture enforces multiple layers of security:

### Network Isolation

* Public and private subnets are clearly separated

### Controlled Entry Point

* Only bastion host is publicly accessible

### Security Group Enforcement

* Bastion allows SSH only from trusted IP
* Private server allows SSH only from bastion

### No Public Exposure

* Private resources have no public IP addresses


## Key Benefits

* Strong isolation between public and private resources
* Reduced attack surface
* Centralized access control via bastion host
* Alignment with industry best practices

## Conclusion

The architecture diagram represents a secure and scalable AWS network design that prevents direct exposure of critical resources. By enforcing controlled access through a bastion host and isolating workloads within private subnets, this setup reflects real-world cloud security practices used in production environments.

This design serves as a strong foundation for building secure and resilient cloud applications.
