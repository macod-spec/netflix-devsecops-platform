Netflix DevSecOps Platform on Azure

Project Overview:

This project takes an existing Netflix-style web application and builds a secure, cloud-native DevSecOps platform around it on Microsoft Azure.
The focus of this project is not just the application itself. The main engineering work is the platform around it: containerisation, infrastructure as code, CI/CD, GitOps deployment, security scanning, monitoring, alerting, and FinOps guardrails.
The platform demonstrates how an application can be built, scanned, deployed, monitored, and controlled using modern DevSecOps practices.

Business Problem:

A business has an existing video streaming application that needs to be deployed safely to the cloud.
The platform must support:
Repeatable cloud infrastructure provisioning
Secure container image build and release
Automated deployment to Kubernetes
GitOps-based release management
Infrastructure and container security checks
Operational monitoring and alerting
Cost visibility and budget control
Evidence for audit, troubleshooting, and portfolio review


Engineering Goal:

Build a DevSecOps platform on Azure that supports secure and automated delivery of a containerised application into Azure Kubernetes Service.

The engineering goal is to prove the following capabilities:

Provision Azure infrastructure with Terraform
Deploy workloads to AKS
Store container images in Azure Container Registry
Build and scan images through GitHub Actions
Use Argo CD for GitOps deployment
Monitor the platform using Azure Monitor and Log Analytics
Create alert rules and notification routing
Add FinOps budget guardrails
Enforce security scanning through CI/CD gates


Solution Architecture:

The solution follows a layered DevSecOps architecture:
Source Control
Code, infrastructure, Helm charts, and documentation are stored in GitHub.
CI/CD Pipeline
GitHub Actions builds the API and web images, runs security checks, pushes images to ACR, and updates deployment configuration.
Security Pipeline
Gitleaks scans for committed secrets. Checkov scans Terraform infrastructure code. Trivy scans container images before deployment.
Container Registry
Azure Container Registry stores versioned application images.
Infrastructure as Code
Terraform provisions the Azure resource group, networking, AKS, ACR, monitoring, alerting, and FinOps budget controls.
GitOps Deployment
Argo CD watches the Git repository and applies the desired Kubernetes state into AKS.
Kubernetes Runtime
AKS runs the Netflix web frontend and API services inside the netflix-dev namespace.
Observability and Operations
Azure Monitor and Log Analytics collect cluster, pod, and container telemetry. Alert rules detect pod failures and restarts.
FinOps
Azure budget guardrails notify when monthly spend reaches defined thresholds.


How the Platform Was Implemented

The platform was built in phases, starting from a working application and gradually adding the cloud, deployment, security, monitoring, and cost-control layers around it.

1. Application Containerisation
The first step was to package the existing Netflix-style application into containers.
Two container images were built:

netflix-web for the frontend web application
netflix-api for the backend API service
The frontend is served through NGINX, while the backend runs as a FastAPI service. Health checks were added so Kubernetes could understand whether each service was alive and ready to receive traffic.
The frontend image was also hardened with basic HTTP security headers such as:

X-Frame-Options
X-Content-Type-Options
X-XSS-Protection
Referrer-Policy
This gave the platform a clean container runtime foundation before moving into Kubernetes.

2. Azure Infrastructure with Terraform

After the containers were ready, the Azure infrastructure was built with Terraform.
Terraform was used to provision and manage:

Azure Resource Group
Virtual Network
Subnets
Network Security Groups
Azure Container Registry
Azure Kubernetes Service
Log Analytics Workspace
Monitoring alert rules
Action Group notifications
Azure budget guardrail
The infrastructure was split into reusable Terraform modules, including:
resource-group
networking
ACR
AKS
monitoring
finops
This modular structure makes the project easier to extend into separate development and production environments later.

3. Azure Container Registry

Azure Container Registry was introduced to store the application images.
The pipeline builds the frontend and backend containers, tags them with a Git commit SHA, and pushes them into ACR as versioned images.

This allows each deployment to be traceable back to a specific commit.

The registry is connected securely to AKS using Azure-managed identity and ACR Pull permissions, so Kubernetes can pull images without using registry admin credentials.

4. AKS Deployment

Azure Kubernetes Service was used as the runtime platform for the application.
The AKS cluster runs the workloads inside a dedicated namespace:

netflix-dev
The main Kubernetes workloads are:
netflix-web deployment and service
netflix-api deployment and service
The web service is exposed externally through a Kubernetes LoadBalancer, while the API service is kept internal to the cluster.
This separates public access from internal service-to-service communication.

5. Helm Chart Packaging

The deployment originally started with Kubernetes manifests, but was later moved into a Helm chart.
The Helm chart provides a cleaner and more reusable deployment structure.

The chart manages:

Namespace
Web deployment
Web service
API deployment
API service
Image registry
Image tag
Health probes
Environment-specific values
The main benefit of Helm is that the deployment configuration can be parameterised. For example, the image tag can be changed without rewriting the Kubernetes manifests.
The environment-specific configuration is stored in:

charts/netflix-platform/values-dev.yaml
The GitHub Actions pipeline updates this file with the latest image tag, and Argo CD then applies the desired state into AKS.

6. GitHub Actions CI/CD

GitHub Actions was used to automate the build, scan, and release process.
The deployment workflow performs the following steps:

Checks out the repository
Creates an image tag from the Git commit SHA
Logs in to Azure
Logs in to Azure Container Registry
Builds the API image
Builds the web image
Pushes both images to ACR
Runs Trivy image vulnerability scanning
Lints the Helm chart
Updates the Helm values file with the new image tag
Commits the GitOps handoff back to the repository
This creates a clear delivery chain from source code to container image to Kubernetes deployment.
The workflow was also adjusted so application deployment only runs when application or Helm deployment files change. This avoids unnecessary rebuilds when only Terraform, documentation, or security workflow files are updated.

7. GitOps with Argo CD

Argo CD was added to move the platform from direct deployment into a GitOps model.
Instead of GitHub Actions directly applying Kubernetes manifests, GitHub Actions now updates the desired deployment state in Git.

Argo CD watches the Git repository and continuously compares the desired state with the live state in AKS.

Argo CD provides:

Automated synchronisation
Drift detection
Self-healing
Deployment visibility
Git-based release history
This means Git becomes the source of truth for Kubernetes deployments.

8. Security Scanning

Security controls were added into the delivery pipeline.
The security workflow includes:

Gitleaks for secret scanning
Checkov for Terraform security scanning
Trivy for container image vulnerability scanning
Checkov was first introduced in soft-fail mode so findings could be reviewed safely. The findings were then assessed and accepted exceptions were documented directly inside the Terraform resources using Checkov skip comments.
After the accepted exceptions were documented, Checkov was changed to strict mode so future unsuppressed Terraform security issues will fail the pipeline.

Gitleaks was also changed to strict mode so committed secrets will fail the pipeline.

This gives the project a real security gate rather than a passive scan.

9. Monitoring and Alerting

Azure Monitor and Log Analytics were added after the application was running.
Monitoring was first enabled and verified through Azure, then codified back into Terraform to avoid configuration drift.

The platform now collects:

Cluster metrics
Node metrics
Container metrics
Pod status
Pod restart data
Alert rules were created for:
Pods not running
Pod restarts
An Azure Monitor Action Group was then added so alerts can send email notifications.
This turns monitoring from passive visibility into operational alerting.

10. FinOps Guardrails

After monitoring was in place, FinOps controls were added.
A monthly Azure budget was created for the development resource group. Budget notifications were configured for actual and forecasted spend thresholds.

This gives the project a cost-control layer and shows that cloud engineering is not only about deployment, but also about financial governance.

Tooling and How Each Tool Was Used:

Terraform was used to provision and manage the Azure infrastructure as code. This included the resource group, networking, subnets, Network Security Groups, Azure Container Registry, AKS, monitoring, alerting, and FinOps budget controls.

Azure Kubernetes Service was used as the runtime platform for the containerised application. It hosts the frontend and backend workloads inside the netflix-dev namespace and provides the Kubernetes foundation for deployment, scaling, service discovery, and operational visibility.

Azure Container Registry was used to store the versioned container images for the application. The GitHub Actions pipeline builds the netflix-web and netflix-api images, tags them with the Git commit SHA, and pushes them to ACR so each deployment can be traced back to a specific source-code version.
GitHub Actions was used to automate the build, scan, and release workflow. It checks out the code, builds the application images, runs security scans, pushes images to ACR, validates the Helm chart, updates the deployment image tag, and hands the release over to the GitOps process.
Helm was used to package the Kubernetes deployment configuration. Instead of managing separate raw Kubernetes YAML files, the application deployment was moved into a reusable Helm chart with environment-specific values. This made the deployment easier to manage, parameterise, and update through GitOps.

Argo CD was used to implement GitOps deployment. Rather than applying Kubernetes changes manually or directly from the CI/CD pipeline, Argo CD watches the Git repository and applies the desired state into AKS. This makes Git the source of truth and gives the platform better visibility, drift detection, and self-healing.

Trivy was used to scan the container images for vulnerabilities before deployment. This helped add a container security gate into the delivery pipeline, so the images are checked before being released into the Kubernetes environment.
Gitleaks was used to scan the repository for committed secrets. It was first introduced safely and later made strict, so any future secret accidentally committed to the repository will fail the security workflow.
Checkov was used to scan the Terraform code for infrastructure security misconfigurations. The findings were reviewed, acceptable exceptions were documented directly inside the Terraform resources, and the Checkov scan was later made strict so future unsuppressed infrastructure security issues fail the pipeline.

Azure Monitor was used to collect operational telemetry from AKS, including cluster, node, pod, and container metrics. This gave the platform visibility into the health and performance of the Kubernetes environment.
Log Analytics was used to store and query monitoring data from AKS. It provides the data source for alert rules and helps investigate pod status, restarts, logs, and other operational events.
Azure Action Groups were used to route alert notifications to email. This means monitoring is not just passive visibility; the platform can notify someone when a defined operational condition is detected.
Azure Budget was used to add FinOps guardrails. A monthly budget was created for the development resource group, with actual and forecasted cost alerts to help control Azure spend.
NGINX was used to serve the frontend application inside the container. It also applies basic HTTP security headers, giving the frontend a more secure runtime configuration.
FastAPI was used as the backend API runtime. It provides the API service that runs inside AKS and is consumed by the frontend application.

Tooling and How Each Tool Was Used:

Terraform was used to provision and manage the Azure infrastructure as code. This included the resource group, networking, subnets, Network Security Groups, Azure Container Registry, AKS, monitoring, alerting, and FinOps budget controls.

Azure Kubernetes Service was used as the runtime platform for the containerised application. It hosts the frontend and backend workloads inside the netflix-dev namespace and provides the Kubernetes foundation for deployment, scaling, service discovery, and operational visibility.
Azure Container Registry was used to store the versioned container images for the application. The GitHub Actions pipeline builds the netflix-web and netflix-api images, tags them with the Git commit SHA, and pushes them to ACR so each deployment can be traced back to a specific source-code version.
GitHub Actions was used to automate the build, scan, and release workflow. It checks out the code, builds the application images, runs security scans, pushes images to ACR, validates the Helm chart, updates the deployment image tag, and hands the release over to the GitOps process.
Helm was used to package the Kubernetes deployment configuration. Instead of managing separate raw Kubernetes YAML files, the application deployment was moved into a reusable Helm chart with environment-specific values. This made the deployment easier to manage, parameterise, and update through GitOps.

Argo CD was used to implement GitOps deployment. Rather than applying Kubernetes changes manually or directly from the CI/CD pipeline, Argo CD watches the Git repository and applies the desired state into AKS. This makes Git the source of truth and gives the platform better visibility, drift detection, and self-healing.

Trivy was used to scan the container images for vulnerabilities before deployment. This helped add a container security gate into the delivery pipeline, so the images are checked before being released into the Kubernetes environment.
Gitleaks was used to scan the repository for committed secrets. It was first introduced safely and later made strict, so any future secret accidentally committed to the repository will fail the security workflow.
Checkov was used to scan the Terraform code for infrastructure security misconfigurations. The findings were reviewed, acceptable exceptions were documented directly inside the Terraform resources, and the Checkov scan was later made strict so future unsuppressed infrastructure security issues fail the pipeline.

Azure Monitor was used to collect operational telemetry from AKS, including cluster, node, pod, and container metrics. This gave the platform visibility into the health and performance of the Kubernetes environment.
Log Analytics was used to store and query monitoring data from AKS. It provides the data source for alert rules and helps investigate pod status, restarts, logs, and other operational events.

Azure Action Groups were used to route alert notifications to email. This means monitoring is not just passive visibility; the platform can notify someone when a defined operational condition is detected.
Azure Budget was used to add FinOps guardrails. A monthly budget was created for the development resource group, with actual and forecasted cost alerts to help control Azure spend.

NGINX was used to serve the frontend application inside the container. It also applies basic HTTP security headers, giving the frontend a more secure runtime configuration.

FastAPI was used as the backend API runtime. It provides the API service that runs inside AKS and is consumed by the frontend application.


Implementation Sequence:

The project was built in phases. The first step was to containerise the existing frontend and backend application so they could run consistently in a cloud-native environment. Once the containers were working, Terraform modules were created to provision the Azure foundation, including the resource group, virtual network, subnets, Network Security Groups, Azure Container Registry, and AKS cluster.

After the Azure foundation was in place, the application images were pushed to Azure Container Registry and deployed into AKS. The web application was exposed through a Kubernetes LoadBalancer, while the API service remained internal to the cluster. Public access was tested and fixed by adjusting the LoadBalancer and NSG rules so traffic could reach the application correctly.

Once the application was running, health checks were added for Kubernetes readiness and liveness. The deployment was then improved by moving the Kubernetes resources into a Helm chart. This made the deployment easier to manage and allowed the image tag, service configuration, namespace, and probes to be controlled through Helm values.

GitHub Actions was then added to automate the build and release process. The pipeline builds the frontend and backend images, tags them with the Git commit SHA, pushes them to ACR, runs Trivy image scanning, validates the Helm chart, and updates the Helm values file with the latest image tag.
After the CI/CD pipeline was working, Argo CD was introduced to move the platform into a GitOps deployment model. Instead of the pipeline directly applying changes to AKS, the pipeline updates the desired state in Git, and Argo CD applies that state into the cluster. This gave the project better deployment visibility, drift detection, and Git-based release history.

Monitoring was added next. Azure Monitor and Container Insights were enabled to provide visibility into cluster, node, pod, and container health. These monitoring resources were then codified back into Terraform so the platform would not depend on manual portal configuration.
Operational alerting was then added using Azure Monitor scheduled query rules. Alerts were created for pods not running and pod restarts. An Azure Action Group was added so those alerts could route notifications by email.

FinOps controls were added after monitoring. A monthly Azure budget was created for the development resource group, with alert thresholds for actual and forecasted spend. This gave the platform a cost-control layer and made cloud spend part of the engineering design.

Security scanning was added in stages. Gitleaks was introduced for secret scanning, Checkov was introduced for Terraform security scanning, and Trivy was used for container image scanning. Checkov findings were reviewed, accepted exceptions were documented directly inside the Terraform resources, and both Checkov and Gitleaks were later made strict pipeline gates.

Finally, evidence was captured for documentation. Screenshots, security scan outputs, monitoring views, endpoint checks, and architecture diagrams were added so the project can be reviewed as a working DevSecOps platform rather than just a code repository.


Engineering Decisions:

Several decisions were made deliberately because this is a development and portfolio environment, not a fully funded production platform.
The Azure design was kept cost-controlled. Some production-grade controls, such as private AKS, premium ACR, geo-replication, zone redundancy, Defender for Containers, private endpoints, and paid AKS SLA were not enabled yet because they would increase the cost of the environment. These were not ignored; they were documented as future production hardening items.

GitOps was chosen over manual deployment because it creates a cleaner and more auditable release model. With Argo CD, Git becomes the source of truth for what should be running in the cluster, and any drift between Git and AKS can be detected and corrected.

Security scanning was introduced carefully. The scans were first added in a safe mode so findings could be reviewed. After the findings were understood, acceptable exceptions were documented and the security workflows were made strict. This reflects a realistic DevSecOps approach: detect, review, document, then enforce.

Terraform was treated as the source of truth for infrastructure. Where something was first enabled manually, such as monitoring, it was later brought under Terraform management. This reduced drift and made the platform easier to reproduce, extend, and maintain.
Evidence-based documentation was also treated as part of the engineering work. Screenshots, scan outputs, status checks, and architecture diagrams were captured so the project can clearly show what was built, how it works, and what has been validated.


GitOps over manual deployment:

Argo CD was introduced so the live Kubernetes state is controlled by Git rather than manual commands.
This makes deployments more auditable and closer to how modern platform teams operate.

Security scans as release gates:

Security scanning was first introduced safely, then made stricter after findings were reviewed.
This reflects a practical DevSecOps approach: detect, review, document, then enforce.

Terraform as the source of infrastructure truth:

Resources that were initially enabled manually, such as monitoring, were later brought under Terraform management. This reduced drift and ensured the platform can be rebuilt or extended consistently.

Evidence-based documentation:

Screenshots, status outputs, and scan results were captured under the docs/evidence folder so the project can be reviewed and understood without relying only on claims.
