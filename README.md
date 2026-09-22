# KubeSentinel

KubeSentinel is a Kubernetes security and GitOps engineering lab designed to demonstrate practical cloud-native security engineering across **Kubernetes validation, container security, policy as code, CI security gates, observability, and runtime security concepts**.

The project combines automated validation and security tooling into a repeatable workflow that helps identify configuration, image, and policy issues before workloads reach a Kubernetes environment.

Repository: `sentinel-gate`

---

## Overview

KubeSentinel brings together multiple security and platform engineering controls into a single Kubernetes-focused workflow.

The project demonstrates how security checks can be integrated into the software delivery lifecycle rather than treated as a separate manual step.

Core areas include:

- Kubernetes manifest validation
- YAML validation
- Container image security scanning
- Infrastructure and configuration security checks
- Policy as code
- CI security gates
- Kubernetes security practices
- Runtime security concepts
- Metrics and observability
- Centralized logging
- GitOps-oriented workflows

---

## Architecture

```text
                         Developer
                             |
                             v
                       Git Repository
                             |
                             v
                      GitHub Actions
                             |
          +------------------+------------------+
          |                  |                  |
          v                  v                  v
     YAML Validation   Kubernetes Schema    Python Validation
          |              Validation                |
          +------------------+------------------+
                             |
                             v
                       Container Build
                             |
                  +----------+----------+
                  |                     |
                  v                     v
              Trivy Scan          Conftest Policies
                  |                     |
                  +----------+----------+
                             |
                             v
                        Kubernetes
                             |
             +---------------+---------------+
             |               |               |
             v               v               v
        Workloads       Security Controls  Monitoring
                                             |
                                             v
                                           Logging

Technology Stack
Kubernetes and Cloud Native
Kubernetes
Docker
GitOps concepts
YAML
Helm
kind
Security
Trivy
Conftest
Falco
Kubernetes security controls
Policy as code
Container security scanning
CI/CD
GitHub Actions
Automated validation
Security gates
Container build workflows
Observability
Prometheus
Grafana
Loki
Development
Python
Docker
kubectl
Helm
kind
Git and GitHub
Security Engineering Workflow

KubeSentinel implements security checks across several stages of the delivery workflow.

1. YAML Validation

Validates configuration syntax and helps detect malformed YAML before deployment.

2. Kubernetes Manifest Validation

Kubernetes resources are validated against the expected resource schemas before deployment.

3. Python Validation

Python components are checked to ensure the project structure and Python code can be imported successfully.

4. Container Build

Application/container artifacts are built as part of the CI workflow.

5. Container Security Scanning

Trivy is used to identify security issues in container images and configuration.

6. Policy Enforcement

Conftest is used to apply policy-as-code rules to Kubernetes-related configuration.

7. Runtime Security

Falco is included as part of the runtime security architecture for detecting suspicious activity within Kubernetes environments.

Security Controls
Control	Purpose
YAML validation	Detect malformed configuration
Kubernetes schema validation	Validate Kubernetes resources
Trivy	Scan container images and configuration
Conftest	Enforce policy as code
Falco	Runtime security monitoring
GitHub Actions	Automate validation and security gates
CI Pipeline

The GitHub Actions pipeline validates the project through multiple stages:

YAML Validation
      |
      v
Kubernetes Manifest Validation
      |
      v
Python Validation
      |
      v
Docker Image Build
      |
      v
Trivy Security Scanning
      |
      v
Conftest Policy Validation

The CI workflow covers:

YAML syntax validation
Kubernetes manifest validation
Python import validation
Docker image builds
Container security scanning
Configuration security scanning
Policy compliance validation

The objective is to move security and configuration validation earlier in the development lifecycle.

Observability

KubeSentinel includes an observability layer based on:

Prometheus
Grafana
Loki

These components provide a foundation for:

Metrics collection
Dashboards
Operational visibility
Centralized log analysis
Security and infrastructure monitoring

The observability architecture complements the security controls by providing operational context around Kubernetes workloads and platform behavior.

GitOps and Platform Engineering

The project is structured around Git-based configuration and automated validation concepts commonly used in modern platform engineering environments.

A typical workflow is:

Configuration Change
        |
        v
Git Commit / Pull Request
        |
        v
Automated Validation
        |
        +--> Kubernetes Validation
        +--> Security Scanning
        +--> Policy Validation
        |
        v
Approved Configuration
        |
        v
Kubernetes Environment

This approach demonstrates how Kubernetes security, CI/CD, and platform engineering practices can work together.

Local Development

KubeSentinel is designed for local Kubernetes and container-based experimentation.

Typical tools:

docker
kubectl
kind
helm

A local Kubernetes cluster can be created with kind:

kind create cluster

Verify the cluster:

kubectl cluster-info

Verify Kubernetes resources:

kubectl get pods -A

The exact deployment workflow depends on the manifests and components enabled in the repository.

Repository Structure

A typical project layout is:

sentinel-gate/
|
|-- .github/
|   `-- workflows/
|
|-- kubernetes/
|
|-- policies/
|
|-- monitoring/
|
|-- scripts/
|
|-- tests/
|
|-- Dockerfile
|
`-- README.md

Refer to the repository files for the current implementation and deployment configuration.

Security Principles Demonstrated

KubeSentinel focuses on practical security engineering principles such as:

Shift Left Security

Security and validation checks are integrated into CI before deployment.

Policy as Code

Security and configuration requirements can be represented as automated policies.

Continuous Validation

Kubernetes configuration and application artifacts are validated continuously through automation.

Defense in Depth

The project combines multiple security controls rather than relying on a single scanning mechanism.

Observable Operations

Metrics, dashboards, and logs provide visibility into platform behavior and operational events.

What This Project Demonstrates

KubeSentinel demonstrates practical experience across:

Kubernetes security
Container security
GitOps workflows
CI/CD security gates
Policy as code
Kubernetes manifest validation
Security scanning
Runtime security concepts
Observability engineering
Infrastructure validation
Linux and container-based environments
Credentials and Secrets

Credentials are not hard-coded into the repository.

Deployment-specific credentials should be provided through secure configuration mechanisms or Kubernetes secret-management practices appropriate for the target environment.

Never commit passwords, API keys, access tokens, or other sensitive credentials to Git.

Future Enhancements

Potential extensions include:

Expanded Open Policy Agent policies
Additional Kubernetes security controls
SBOM generation
Image signing and verification
Secret scanning
Supply-chain security checks
Runtime alerting
Advanced Prometheus alert rules
Automated GitOps deployment
Kubernetes admission control integration
Author

Franklin Osuji

Cloud Infrastructure and DevOps Engineer

GitHub:
https://github.com/franklinosuji2-afk

Portfolio:
https://fc-dev.netlify.app/

Project Focus

Kubernetes Security | DevSecOps | GitOps | Platform Engineering | Container Security | Policy as Code | Observability
