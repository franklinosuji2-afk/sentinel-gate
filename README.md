# 🛡️ KubeSentinel

> **GitOps-Driven Kubernetes Security & Policy Enforcement Platform**

A production-style, local-first Kubernetes security platform that prevents insecure workloads **before deployment** and detects threats **after runtime** using layered security controls.

KubeSentinel demonstrates how modern platform teams implement **GitOps**, **policy-as-code**, **container vulnerability scanning**, **runtime threat detection**, and **observability** to secure Kubernetes environments end-to-end.

Built with:

* Kubernetes
* Argo CD
* Open Policy Agent Gatekeeper
* Falco
* Trivy
* Prometheus
* Grafana

---

## 🚀 Project Overview

Most Kubernetes security incidents trace back to a small set of preventable misconfigurations:

* Containers running as root
* Missing CPU / memory limits
* Privileged workloads
* Usage of mutable `latest` tags
* Unscanned container images
* Lack of runtime visibility

These issues often surface **after deployment**, when remediation becomes expensive and operationally risky.

**KubeSentinel solves this by implementing defense in depth across the full workload lifecycle:**

### Shift Left (Pre-Deployment)

Catch security issues in CI before workloads reach the cluster.

### Admission Control (Deployment-Time)

Reject unsafe manifests before scheduling.

### Runtime Security (Post-Deployment)

Detect suspicious behavior inside running workloads.

---

# 🎯 What This Project Demonstrates

KubeSentinel is designed as a portfolio artifact showcasing advanced DevOps and platform engineering practices.

It demonstrates:

✅ Reproducible local Kubernetes environments
✅ GitOps-based deployment workflows
✅ Policy-as-code enforcement
✅ CI-integrated vulnerability scanning
✅ Runtime threat detection
✅ Observability-driven security monitoring

---

# 🏗 Architecture

```text
                       ┌──────────────────────────┐
                       │     Developer / CI       │
                       │   git push → GitHub      │
                       └────────────┬─────────────┘
                                    │
              ┌─────────────────────┴─────────────────────┐
              │           GitHub Actions CI               │
              │ lint → test → build → scan → validate    │
              └─────────────────────┬─────────────────────┘
                                    │
                                    ▼
                       ┌──────────────────────────┐
                       │        Argo CD           │
                       │   Sync / Reconcile       │
                       └────────────┬─────────────┘
                                    │
                                    ▼
 ┌─────────────────────────────────────────────────────────────────────┐
 │                 Kubernetes Cluster (Kind)                          │
 │                                                                    │
 │  Demo App ── admission ──► Gatekeeper Policies                     │
 │     │                        - no root                             │
 │     │                        - no latest                           │
 │     │                        - resource limits                     │
 │     │                        - no privileged                       │
 │     ▼                                                              │
 │  Metrics ─────────────► Prometheus / Grafana                       │
 │                                                                    │
 │  Runtime Events ──────► Falco Threat Detection                     │
 └─────────────────────────────────────────────────────────────────────┘
```

---

# ⚡ Quick Start

## Prerequisites

Install:

* Docker
* Kind
* `kubectl`
* Helm
* `make`

---

## Bootstrap Environment

```bash
make cluster
make bootstrap
make deploy
```

---

## Security Testing

Run vulnerability scan:

```bash
make scan
```

Deploy intentionally insecure manifests:

```bash
make violate
```

Monitor dashboards and access instructions:

```bash
make monitor
```

Destroy cluster:

```bash
make destroy
```

---

### Expected Setup Time

~5 minutes on a modern laptop.

---

# 📁 Repository Structure

```bash
kubesentinel/
│
├── apps/demo-app/
│   ├── app/
│   ├── k8s/
│   ├── Dockerfile
│   └── requirements.txt
│
├── argocd/
│   └── demo-app.yaml
│
├── cluster/
│   ├── bootstrap.sh
│   └── kind-config.yaml
│
├── policies/gatekeeper/
│   ├── constraints/
│   └── templates/
│
├── security/
│   ├── trivy/
│   └── falco/
│
├── monitoring/
│   ├── prometheus/
│   └── grafana/dashboards/
│
├── manifests/bad/
│
├── .github/workflows/
│   └── ci.yml
│
├── Makefile
└── README.md
```

---

# 🔄 GitOps Workflow

KubeSentinel follows a GitOps deployment model.

### Step 1 — Developer Pushes Code

A commit to `main` triggers CI.

---

### Step 2 — CI Pipeline Runs

Pipeline stages:

* YAML linting
* Application tests
* Container build
* Vulnerability scanning
* Policy validation

---

### Step 3 — Image & Manifest Validation

CI validates:

* image vulnerabilities
* manifest correctness
* policy compliance

---

### Step 4 — Git Becomes Source of Truth

Approved changes are committed to Git.

No manual deployment.

No direct cluster drift.

---

### Step 5 — Argo CD Sync

Argo CD reconciles cluster state with repository state.

Rollback is simple:

```bash
git revert
```

---

# 🚔 Policy Enforcement (OPA Gatekeeper)

KubeSentinel uses Gatekeeper constraints to block insecure workloads.

| Policy                  | Description                  |
| ----------------------- | ---------------------------- |
| `K8sDisallowRoot`       | Blocks root containers       |
| `K8sRequiredResources`  | Requires CPU/memory limits   |
| `K8sDisallowLatestTag`  | Rejects mutable image tags   |
| `K8sDisallowPrivileged` | Blocks privileged containers |

---

## Example Policy Violation

```bash
kubectl apply -f manifests/bad/root-container.yaml
```

Output:

```text
Error from server:
[K8sDisallowRoot] Container must not run as root
```

Unsafe workloads never reach the scheduler.

---

# 🔍 Security Pipeline

```text
Container Build
      │
      ▼
Trivy Vulnerability Scan
      │
      ▼
Policy Validation
      │
      ▼
Registry / Deployment
      │
      ▼
Runtime Monitoring (Falco)
```

---

## Trivy Scanning

Trivy scans:

* container images
* filesystem
* manifests
* IaC configs

Pipeline fails on:

* CRITICAL CVEs
* policy violations

---

## Falco Runtime Detection

Falco detects suspicious runtime behavior such as:

* shell execution inside containers
* privilege escalation
* writes under `/etc`
* package manager execution
* unexpected outbound network traffic

This adds post-deployment protection.

---

# 📈 Monitoring & Observability

Monitoring stack uses **kube-prometheus-stack**.

Components:

* Prometheus
* Alertmanager
* Node Exporter
* kube-state-metrics
* Grafana

---

## Custom Dashboards

### Cluster Health

Metrics include:

* CPU usage
* Memory utilization
* Pod restarts
* API latency

---

### Security Posture

Metrics include:

* Gatekeeper denials
* Falco alerts by rule
* Vulnerability scan history

---

## Access Grafana

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
```

Grafana credentials are configured by the installed Helm release and should not be hard-coded in documentation.

---

# 🖼 Screenshots

Recommended screenshots for recruiter/demo impact:

* Argo CD application tree
* Security Posture dashboard
* Gatekeeper rejection logs
* Falco runtime alerts

Suggested path:

```text
docs/img/
```

---

# 🧠 Engineering Lessons

KubeSentinel highlights several practical lessons from real-world platform engineering.

---

## Admission Control Beats Audit

Blocking insecure workloads during admission is dramatically cheaper than remediation after deployment.

---

## GitOps Simplifies Incident Response

Rollback becomes deterministic:

```bash
git revert
```

No imperative cluster changes.

---

## Security Requires Multiple Layers

No single tool catches everything.

Effective Kubernetes security requires:

* CI scanning
* policy enforcement
* runtime detection
* observability

---

## Local-First Developer Experience Matters

Using Kind + Make provides every engineer with a reproducible platform on their laptop.

Benefits:

* no shared dev cluster
* no environment drift
* faster iteration

---

# 🔮 Future Enhancements

Planned improvements:

### Supply Chain Security

* [Cosign](https://github.com/sigstore/cosign?) image signing
* SBOM generation via [Syft](https://github.com/anchore/syft?)

### Advanced Policy

* [Kyverno](https://kyverno.io/?) mutation policies

### CI/CD Expansion

* [Tekton](https://tekton.dev/?) pipelines

### Secrets Management

* [HashiCorp Vault](https://www.vaultproject.io/?) integration
* External Secrets Operator

### Multi-Tenancy

* Network Policies
* Namespace hierarchy
* Tenant isolation

---

# 📦 Tech Stack

### Platform

* Kubernetes
* Kind

### GitOps

* Argo CD

### Security

* Open Policy Agent Gatekeeper
* Falco
* Trivy

### Monitoring

* Prometheus
* Grafana

### CI/CD

* [GitHub Actions](https://github.com/features/actions?)

---

# 💡 Why This Project Matters

Many DevOps portfolios demonstrate deployment.

Few demonstrate **secure platform ownership**.

KubeSentinel showcases the ability to think beyond infrastructure provisioning into:

* policy enforcement
* runtime defense
* GitOps operations
* platform governance
* security observability

This reflects the mindset expected from modern **Platform Engineers**, **DevSecOps Engineers**, and **Cloud Security Engineers**.

---

# 👨‍💻 Author

## Franklin Chinonso Osuji

Cloud & DevOps Engineer

AWS | Terraform | Kubernetes | GitOps | DevSecOps | Platform Engineering

> Building secure, scalable infrastructure with automation, policy, and observability at the core.

---

# 📄 License

Licensed under the **MIT License**.

---
