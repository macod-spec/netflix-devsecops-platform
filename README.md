Netflix DevSecOps Platform on Azure

Project Overview

This project takes an existing Netflix-style web application and builds a secure, cloud-native DevSecOps platform around it on Microsoft Azure.

The main focus is not only the application itself, but the platform engineering around it: containerisation, infrastructure as code, CI/CD, GitOps deployment, security scanning, monitoring, alerting, and FinOps guardrails.

The platform demonstrates how a containerised application can be built, scanned, deployed, monitored, and controlled using modern DevSecOps practices.

Business Problem

A business has an existing video streaming application that needs to be deployed safely to the cloud.

The platform must support:

* repeatable cloud infrastructure provisioning
* secure container image build and release
* automated deployment to Kubernetes
* GitOps-based release management
* infrastructure and container security checks
* operational monitoring and alerting
* cost visibility and budget control
* evidence for audit, troubleshooting, and portfolio review

Engineering Goal

The goal is to build a DevSecOps platform on Azure that supports secure and automated delivery of a containerised application into Azure Kubernetes Service.

The project demonstrates the following capabilities:

* provision Azure infrastructure with Terraform
* deploy workloads to AKS
* store container images in Azure Container Registry
* build and scan images through GitHub Actions
* deploy through Helm and Argo CD
* monitor the platform using Azure Monitor and Log Analytics
* create alert rules and notification routing
* add FinOps budget guardrails
* enforce security scanning through CI/CD gates

Current Repository Structure

apps/web                      React frontend served by NGINX
services/api                  FastAPI backend service
charts/netflix-platform       Active Helm chart for Kubernetes deployment
argocd                        Argo CD application definition
environment/dev               Dev Terraform environment
Modules                       Reusable Terraform modules
docs                          Architecture, security, network, and evidence documentation
docs/archive                  Archived historical files
.github/workflows             CI/CD, deployment, and security workflows

Raw Kubernetes manifests previously used for deployment have been archived under:

docs/archive/k8s-raw-manifests

The active Kubernetes deployment source of truth is now the Helm chart:

charts/netflix-platform

Application Architecture

The application is split into two services:

End user
  → Netflix-style React frontend
  → NGINX /api proxy
  → FastAPI backend
  → TMDB API

The frontend does not call TMDB directly and does not hold the TMDB API key in the browser.

The TMDB API key is injected into the backend through Kubernetes Secret configuration managed by Helm. This keeps the secret on the server side and avoids exposing it through the frontend bundle.

Solution Architecture

The platform follows a layered DevSecOps architecture.

Source Control

GitHub stores the application code, Terraform infrastructure code, Helm chart, Argo CD definition, workflows, and documentation.

CI/CD Pipeline

GitHub Actions builds the web and API container images, runs security checks, pushes images to Azure Container Registry, validates deployment configuration, and supports the GitOps handoff.

Security Pipeline

Gitleaks scans for committed secrets. Checkov scans Terraform code for infrastructure misconfiguration. Trivy scans container images before release.

Container Registry

Azure Container Registry stores versioned application images. Images are tagged using Git commit SHAs so releases can be traced back to source code.

Infrastructure as Code

Terraform provisions the Azure platform foundation, including resource group, networking, AKS, ACR, monitoring, alerting, and budget controls.

GitOps Deployment

Argo CD watches the Git repository and deploys the Helm chart into AKS. Git becomes the source of truth for the desired Kubernetes state.

Kubernetes Runtime

AKS runs the netflix-web and netflix-api workloads inside the netflix-dev namespace.

The web service is exposed publicly through a Kubernetes LoadBalancer. The API service remains internal to the cluster and is reached through the frontend NGINX /api proxy.

Observability and Operations

Azure Monitor and Log Analytics collect cluster, pod, node, and container telemetry. Alert rules detect unhealthy pods and container restarts.

FinOps

Azure Budget provides cost guardrails for the development environment and sends notifications when defined spend thresholds are reached.

Implementation Summary

1. Application Containerisation

The existing Netflix-style application was packaged into two containers:

* netflix-web for the React frontend
* netflix-api for the FastAPI backend

The frontend is served through NGINX. The backend runs as a FastAPI service and acts as the server-side proxy to TMDB.

Health and readiness endpoints were added so Kubernetes can check whether the services are alive and ready.

The frontend container also includes basic HTTP security headers through NGINX.

2. Azure Infrastructure with Terraform

Terraform was used to provision and manage the Azure infrastructure.

The infrastructure includes:

* Azure Resource Group
* Virtual Network
* Subnets
* Network Security Groups
* Azure Container Registry
* Azure Kubernetes Service
* Log Analytics Workspace
* Azure Monitor alert rules
* Action Group notifications
* Azure Budget guardrail

The Terraform code is split into reusable modules:

Modules/resource-group
Modules/networking
Modules/ACR
Modules/AKS
Modules/monitoring
Modules/finops

This makes the platform easier to extend into additional environments later.

3. Azure Container Registry

Azure Container Registry stores the frontend and backend container images.

The pipeline builds the images, tags them with the Git commit SHA, and pushes them to ACR.

AKS is granted permission to pull images from ACR using Azure-managed identity and AcrPull permissions.

4. AKS Runtime

Azure Kubernetes Service is used as the runtime platform.

The platform deploys into the namespace:

netflix-dev

The main workloads are:

* netflix-web
* netflix-api

The web service is public. The API service is internal.

5. Helm Deployment

The Kubernetes deployment is packaged as a Helm chart.

The chart manages:

* namespace
* web deployment
* web service
* API deployment
* API service
* image registry
* image tag
* health and readiness probes
* backend TMDB configuration
* Kubernetes resource requests and limits
* container hardening settings

Environment-specific configuration is stored in:

charts/netflix-platform/values-dev.yaml

6. GitOps with Argo CD

Argo CD deploys the platform using the Helm chart.

The Argo CD application definition is stored in:

argocd/netflix-platform-dev.yaml

Argo CD provides:

* automated synchronisation
* drift detection
* self-healing
* deployment visibility
* Git-based release history

7. Security Scanning

Security checks are included in the delivery process.

The project uses:

* Gitleaks for secret scanning
* Checkov for Terraform security scanning
* Trivy for container image vulnerability scanning

Accepted Checkov exceptions are documented directly in the Terraform code with skip comments and explanations.

This makes the security posture visible rather than hidden.

8. Monitoring and Alerting

Azure Monitor and Log Analytics collect operational telemetry from AKS.

The platform captures:

* cluster metrics
* node metrics
* pod status
* container health
* pod restart data

Alert rules were added for unhealthy pods and container restarts. Azure Action Groups route notifications by email.

9. FinOps Guardrails

A monthly Azure budget was added for the development environment.

Budget alerts support both actual and forecasted spend notifications. This shows that the platform includes cost governance, not only deployment automation.

Tooling

Tool	Purpose
Terraform	Azure infrastructure provisioning
Azure Kubernetes Service	Container runtime
Azure Container Registry	Container image storage
GitHub Actions	CI/CD automation
Helm	Kubernetes deployment packaging
Argo CD	GitOps deployment
Trivy	Container image vulnerability scanning
Gitleaks	Secret scanning
Checkov	Terraform security scanning
Azure Monitor	Platform telemetry
Log Analytics	Monitoring data store and query layer
Azure Action Groups	Alert notification routing
Azure Budget	FinOps spend guardrails
NGINX	Frontend runtime and reverse proxy
FastAPI	Backend API runtime

Deployment Flow

Developer
  → GitHub
  → GitHub Actions
  → Build and scan images
  → Azure Container Registry
  → Helm values update
  → Argo CD
  → AKS

Runtime traffic follows a separate path:

End user
  → netflix-web LoadBalancer
  → NGINX frontend
  → /api proxy
  → netflix-api ClusterIP service
  → FastAPI
  → TMDB API

Validation

The project has been validated with:

* frontend production build
* FastAPI syntax compilation
* Helm linting
* Terraform validation
* security scanning
* Kubernetes deployment evidence
* monitoring and alerting evidence

Evidence is retained under:

docs/evidence

Current Operating Note

The Azure infrastructure was created, tested, and documented as part of the project. Some Azure resources may not currently be running to avoid ongoing cloud costs.

The repository retains the infrastructure code, deployment configuration, and evidence required to understand and rebuild the platform.