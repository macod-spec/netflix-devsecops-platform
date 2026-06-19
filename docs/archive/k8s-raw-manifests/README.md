Archived Raw Kubernetes Manifests

These manifests are retained for historical reference only.

The active Kubernetes deployment source of truth is now the Helm chart in:

charts/netflix-platform

Argo CD deploys the platform from the Helm chart using:

argocd/netflix-platform-dev.yaml

These raw manifests should not be used for active deployment because they do not include the latest Helm-managed configuration, including backend TMDB secret injection, resource requests and limits, readiness configuration, and container hardening.