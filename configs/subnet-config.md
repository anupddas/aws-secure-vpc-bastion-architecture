# Subnet Configuration — Secure VPC with Bastion Host

## Overview

This document describes the subnet configuration used in this project to implement a secure and well-structured Amazon Web Services (AWS) Virtual Private Cloud (VPC) architecture.

Subnets are used to logically divide the VPC into isolated network segments, enabling controlled access, improved security, and better resource organization.


## Subnet Design Principles

The subnet architecture follows these core principles:

* **Separation of Concerns** — Public and private resources are isolated
* **Security by Design** — Private resources are not directly exposed to the internet
* **Controlled Accessibility** — Only designated components can receive external traffic
* **Scalability** — IP ranges allow future expansion


## Subnet Overview

Two subnets are created within the VPC:

1. Public Subnet
2. Private Subnet


## Public Subnet Configuration

### Details

* **Name:** public-subnet-1
* **CIDR Block:** 10.0.1.0/24
* **Availability Zone:** Single AZ (configurable)
* **Auto-assign Public IP:** Enabled


### Purpose

The public subnet is designed to host resources that require direct internet access.

In this architecture, it is used for:

* Bastion Host (Jump Server)


### Characteristics

* Connected to the Internet Gateway via route table
* Allows inbound and outbound internet traffic
* Assigns public IP addresses to instances


### Behavior

* Instances can be accessed from the internet (if security groups allow)
* Suitable for controlled entry points and publicly accessible services


## Private Subnet Configuration

### Details

* **Name:** private-subnet-1
* **CIDR Block:** 10.0.2.0/24
* **Availability Zone:** Same as public subnet
* **Auto-assign Public IP:** Disabled


### Purpose

The private subnet is designed to host sensitive resources that must not be exposed to the internet.

In this architecture, it is used for:

* Private Application Server


### Characteristics

* No direct connection to the Internet Gateway
* No public IP assignment
* Accessible only through internal VPC communication


### Behavior

* Instances cannot be accessed directly from the internet
* Communication is restricted to trusted internal sources (e.g., bastion host)


## CIDR Allocation Strategy

The VPC CIDR block (10.0.0.0/16) is divided into smaller subnet ranges:

* Public Subnet → 10.0.1.0/24
* Private Subnet → 10.0.2.0/24


### Benefits

* Clear separation between public and private resources
* Efficient IP address management
* Flexibility to add more subnets in the future


## Availability Zone Consideration

Both subnets are deployed in the same Availability Zone for simplicity.

### Note

In production environments:

* Subnets are typically distributed across multiple Availability Zones
* This improves fault tolerance and high availability


## Traffic Flow

The subnet configuration enforces the following flow:

* Internet → Public Subnet (Bastion Host)
* Bastion Host → Private Subnet (Application Server)

Direct internet access to private subnet is not permitted.


## Common Misconfigurations

### 1. Enabling Public IP in Private Subnet

**Issue:**

* Private instances become publicly accessible

**Fix:**

* Disable auto-assign public IP


### 2. Using Same Subnet for All Resources

**Issue:**

* No isolation between public and private components

**Fix:**

* Separate resources into dedicated subnets


### 3. Incorrect CIDR Allocation

**Issue:**

* Overlapping IP ranges or insufficient address space

**Fix:**

* Plan CIDR blocks carefully before deployment


### 4. Misconfigured Route Tables

**Issue:**

* Private subnet gains internet access unintentionally

**Fix:**

* Ensure no route to Internet Gateway for private subnet


## Best Practices

* Always separate public and private workloads
* Avoid assigning public IPs to sensitive resources
* Use meaningful naming conventions for subnets
* Design CIDR blocks with future scalability in mind
* Combine subnet isolation with security groups for layered security


## Conclusion

The subnet configuration in this project establishes a clear separation between public and private resources, enabling a secure and scalable network design. By isolating sensitive workloads within a private subnet and controlling access through a bastion host, the architecture aligns with best practices for secure cloud deployments in AWS.

This approach forms the foundation for building production-ready, secure, and resilient cloud applications.
