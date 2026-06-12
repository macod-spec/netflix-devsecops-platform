# Security Design

## Security Principle

This project uses layered security across cloud infrastructure, Kubernetes, containers, pipelines and runtime operations.

## Edge Security

Production traffic enters through Azure Front Door.

Azure WAF protects the application from:

- SQL injection
- Cross-site scripting
- malicious bots
- OWASP Top 10 attack patterns

## Network Security

Network security includes:

- Separate dev and prod resource groups
- Separate dev and prod VNets
- Subnet segmentation
- Network Security Groups
- Private endpoints in production
- Kubernetes Network Policies

## Identity Security

The platform avoids long-lived credentials.

Security controls include:

- Managed Identity for AKS
- ACR pull through managed identity
- GitHub Actions OIDC federation
- Azure Key Vault RBAC

## Secrets Security

Secrets are not committed to source control.

Secrets such as the TMDB API key are stored in Azure Key Vault or injected securely through GitHub Actions.

## Container Security

Containers are hardened using:

- non-root users
- UID 10001
- port 8080
- minimal base images
- Docker health checks
- no secrets baked into images
- multi-stage frontend build

## Kubernetes Security

Kubernetes security includes:

- namespaces
- Network Policies
- liveness probes
- readiness probes
- resource requests and limits
- runAsNonRoot
- seccomp RuntimeDefault
- automountServiceAccountToken disabled
- Pod Disruption Budgets in production

## CI/CD Security

Pipelines include:

- SonarCloud static analysis
- Trivy dependency and image scanning
- Checkov infrastructure scanning
- OWASP ZAP dynamic application scanning
- production approval gate
- critical CVEs blocking production release

## Release Security

Production uses Argo Rollouts for blue/green deployment, manual promotion and fast rollback.
