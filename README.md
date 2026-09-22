# KubeSentinel

KubeSentinel is a Kubernetes security and GitOps engineering lab focused on manifest validation, container security, policy enforcement, observability, and operational controls.

Repository: sentinel-gate

Architecture
Developer
   |
   v
Git Repository
   |
   v
GitHub Actions
   |
   +-- YAML validation
   +-- Kubernetes manifest validation
   +-- Python validation
   +-- Container build
   +-- Trivy security scanning
   `-- Conftest policy validation
   |
   v
Kubernetes
   |
   +-- Application workloads
   +-- Security controls
   +-- Monitoring
   `-- Logging
Technology Stack
Kubernetes
Docker
GitHub Actions
GitOps concepts
YAML
Python
Trivy
Falco
Conftest
Prometheus
Grafana
Loki
Security Controls

The project demonstrates several layers of Kubernetes security validation:

ControlPurpose
YAML validationDetect malformed configuration
Kubernetes schema validationValidate Kubernetes resources
TrivyScan container images and configuration
ConftestEnforce policy rules
FalcoRuntime security monitoring
GitHub ActionsAutomate security checks
CI Pipeline

The CI pipeline validates:

YAML syntax
Kubernetes manifests
Python imports
Docker image builds
Container security with Trivy
Configuration security with Trivy
Policy compliance with Conftest

The goal is to move security and validation checks earlier in the delivery lifecycle.

Monitoring

The lab integrates an observability stack based on:

Prometheus
Grafana
Loki

These components support metrics, dashboards, and centralized log analysis.

Credentials

Credentials are not hard-coded into the repository. Deployment-specific credentials should be supplied through secure configuration or secret-management mechanisms.

Local Development

The project is designed for local Kubernetes and container-based experimentation.

Typical tooling includes:

docker
kubectl
kind
helm
Security Engineering Focus

KubeSentinel demonstrates practical experience with:

Kubernetes security
Container security
GitOps workflows
Policy as code
CI security gates
Runtime security concepts
Observability
Infrastructure validation
Author

Franklin Osuji

Cloud Infrastructure and DevOps Engineer

GitHub: https://github.com/franklinosuji2-afk
Portfolio: https://fc-dev.netlify.app/
