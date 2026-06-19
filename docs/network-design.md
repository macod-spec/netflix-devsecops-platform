Network Design
Overview
This project uses a segmented Azure network design for the development environment. The network is provisioned with Terraform and supports AKS, Azure Container Registry, monitoring, and application workloads.
The current implementation is a development-grade cloud network. Production-grade edge controls such as Azure Front Door, WAF, private endpoints, and Kubernetes Network Policies are documented as future enhancements rather than current runtime dependencies.
Current Dev Network
The dev environment is defined in:
environment/dev
The network includes:
* Azure Resource Group
* Virtual Network
* dedicated subnets
* Network Security Groups
* AKS system subnet
* application subnet
* ingress subnet
* private endpoint subnet reserved for future use
Dev Addressing
VNet:
10.0.0.0/16
Subnets:
system-subnet:            10.0.1.0/24
app-subnet:               10.0.2.0/24
ingress-subnet:           10.0.3.0/24
private-endpoint-subnet:  10.0.4.0/24
Runtime Traffic Flow
The current application runtime flow is:
End user
  → Kubernetes LoadBalancer
  → netflix-web service
  → NGINX frontend container
  → /api proxy
  → netflix-api ClusterIP service
  → FastAPI backend
  → TMDB API
The frontend is the public entry point. The API service remains internal to the cluster and is reached through the NGINX /api proxy.
The frontend does not call TMDB directly and does not expose the TMDB API key in the browser.
Kubernetes Service Design
The platform uses two main Kubernetes services:
netflix-web   LoadBalancer   Public frontend entry point
netflix-api   ClusterIP      Internal backend API service
This separates public access from internal service-to-service communication.
Delivery Flow
The delivery flow is separate from runtime traffic:
Developer
  → GitHub
  → GitHub Actions
  → Azure Container Registry
  → Helm values update
  → Argo CD
  → AKS
GitHub Actions builds and publishes images. Argo CD deploys the Helm chart into AKS.
Active Deployment Source of Truth
The active Kubernetes deployment source of truth is the Helm chart:
charts/netflix-platform
The previous raw Kubernetes manifests have been archived under:
docs/archive/k8s-raw-manifests
They are retained for reference only and should not be used for active deployment.
Network Security Controls
Current controls include:
* dedicated Azure resource group for the dev environment
* VNet and subnet segmentation
* Network Security Groups attached to subnets
* internal ClusterIP service for the backend API
* public exposure limited to the frontend service
* no TMDB API key in the frontend bundle
* backend-only outbound access to TMDB
Future Production Enhancements
The following controls are suitable future enhancements for a production version of the platform:
* Azure Front Door
* Web Application Firewall
* NGINX Ingress Controller or Application Gateway Ingress Controller
* HTTPS/TLS termination
* private AKS cluster
* private endpoints for ACR and Key Vault
* Kubernetes Network Policies
* separate production VNet and resource group
* stricter inbound restrictions to only trusted edge services
