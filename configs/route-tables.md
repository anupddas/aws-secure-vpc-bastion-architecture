# Route Tables Configuration — Secure VPC with Bastion Host

## Overview

This document explains the route table configuration used in this project to control network traffic within a secure Amazon Web Services (AWS) Virtual Private Cloud (VPC).

Route tables define how traffic flows between subnets, the internet, and other network components. Proper configuration is essential for enabling controlled connectivity while maintaining strict isolation of private resources.


## Routing Design Principles

The routing strategy is based on the following principles:

* **Explicit Internet Access** — Only public subnet has internet connectivity
* **Private Subnet Isolation** — No direct internet route for private resources
* **Controlled Traffic Flow** — All access to private resources must pass through bastion host
* **Minimal Exposure** — Reduce attack surface by limiting routes


## Route Tables Overview

Two routing configurations are used:

1. Public Route Table
2. Main (Private) Route Table


## Public Route Table

### Configuration

* **Name:** public-route-table
* **Associated Subnet:** public-subnet-1


### Routes

| Destination | Target                            |
| ----------- | --------------------------------- |
| 10.0.0.0/16 | local                             |
| 0.0.0.0/0   | Internet Gateway (secure-vpc-igw) |


### Explanation

* The `local` route enables communication within the VPC
* The `0.0.0.0/0` route allows outbound traffic to the internet
* Internet Gateway enables both inbound and outbound connectivity


### Purpose

* Enables bastion host to:

  * Receive SSH connections from the internet
  * Initiate outbound connections if required


## Private Route Table (Main Route Table)

### Configuration

* Uses default/main route table
* Associated with private-subnet-1


### Routes

| Destination | Target |
| ----------- | ------ |
| 10.0.0.0/16 | local  |


### Explanation

* Only internal VPC traffic is allowed
* No route to Internet Gateway is defined


### Purpose

* Ensures private subnet has no direct internet access
* Prevents external exposure of private EC2 instance

## Traffic Flow Behavior

### Public Subnet

* Can send and receive internet traffic via Internet Gateway
* Used for bastion host


### Private Subnet

* Can communicate only within VPC
* Cannot access or be accessed from internet


## Access Flow Enforcement

The routing configuration supports the following pattern:

1. External traffic enters via Internet Gateway
2. Routed to public subnet (bastion host)
3. Bastion host communicates with private subnet via internal VPC routing
4. Private instance responds through bastion

Direct internet routing to private subnet is not possible.

## Common Misconfigurations

### 1. Adding Internet Gateway Route to Private Subnet

**Issue:**

* Private resources become publicly accessible

**Fix:**

* Remove route:

  * 0.0.0.0/0 → Internet Gateway

### 2. Not Associating Public Subnet with Correct Route Table

**Issue:**

* Bastion host cannot access internet

**Fix:**

* Associate public-subnet-1 with public-route-table

### 3. Missing Internet Gateway Route

**Issue:**

* No internet connectivity for public subnet

**Fix:**

* Add route:

  * 0.0.0.0/0 → Internet Gateway

### 4. Incorrect Subnet Association

**Issue:**

* Traffic does not follow intended routing path

**Fix:**

* Verify subnet associations in route table settings

## Best Practices

* Use separate route tables for public and private subnets
* Avoid unnecessary routes to the internet
* Keep routing configuration simple and explicit
* Regularly review route tables for misconfigurations
* Combine routing with security groups for layered security

## Conclusion

The route table configuration in this architecture ensures controlled internet access and strict isolation of private resources. By allowing only the public subnet to communicate with the internet and restricting the private subnet to internal communication, the design enforces a secure and production-ready networking model.

This approach aligns with best practices for building secure, scalable, and maintainable cloud infrastructure in AWS.
