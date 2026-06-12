# Network Design

## Overview

The platform uses separate Azure networks for development and production.

Each environment has its own resource group, VNet, subnets and security controls.

## Dev Network

- Resource Group: rg-netflix-dev-uksouth
- VNet: vnet-netflix-dev-uksouth
- CIDR: 10.0.0.0/16

Subnets:

- system-subnet: 10.0.1.0/24
- app-subnet: 10.0.2.0/24
- ingress-subnet: 10.0.3.0/24
- private-endpoint-subnet: 10.0.4.0/24

## Prod Network

- Resource Group: rg-netflix-prod-uksouth
- VNet: vnet-netflix-prod-uksouth
- CIDR: 10.1.0.0/16

Subnets:

- system-subnet: 10.1.1.0/24
- app-subnet: 10.1.2.0/24
- ingress-subnet: 10.1.3.0/24
- private-endpoint-subnet: 10.1.4.0/24

## Production Traffic Flow

User  
→ Azure Front Door  
→ Web Application Firewall  
→ AKS Load Balancer  
→ NGINX Ingress Controller  
→ Netflix Web Service  
→ Netflix API Service

## Network Security Controls

- Separate resource groups for dev and prod
- Separate VNets for dev and prod
- Separate subnets for system, app, ingress and private endpoints
- NSGs attached to subnets
- Production HTTPS traffic restricted to Azure Front Door backend traffic
- Private endpoints for ACR and Key Vault in production
- Kubernetes Network Policies for pod-to-pod traffic control
