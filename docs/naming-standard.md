# Naming Standard

## Azure Region

Primary region: UK South.

## Resource Groups

- Dev: rg-netflix-dev-uksouth
- Prod: rg-netflix-prod-uksouth
- Terraform State: rg-netflix-tfstate-uksouth

## Virtual Networks

- Dev VNet: vnet-netflix-dev-uksouth
- Prod VNet: vnet-netflix-prod-uksouth

## Address Spaces

- Dev: 10.0.0.0/16
- Prod: 10.1.0.0/16

## Subnets

Each environment will use:

- system-subnet
- app-subnet
- ingress-subnet
- private-endpoint-subnet

## AKS

- Dev AKS: aks-netflix-dev-uksouth
- Prod AKS: aks-netflix-prod-uksouth

## ACR

- Dev ACR: acrnetflixdevYOURNAME
- Prod ACR: acrnetflixprodYOURNAME

## Key Vault

- Dev Key Vault: kv-netflix-dev-YOURNAME
- Prod Key Vault: kv-netflix-prod-YOURNAME

## Security Principle

Security is designed from the beginning, not added after deployment.
