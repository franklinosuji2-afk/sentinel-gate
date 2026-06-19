# 🛡️ KubeSentinel

> **GitOps Security & Policy Enforcement Platform for Kubernetes.**
> A production-style local Kubernetes platform that rejects unsafe workloads *before* they deploy and detects threats *after* they run.

[![CI](https://github.com/USER/kubesentinel/actions/workflows/ci.yml/badge.svg)](https://github.com/USER/kubesentinel/actions)
![Kubernetes](https://img.shields.io/badge/Kubernetes-1.29-326CE5?logo=kubernetes&logoColor=white)
![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-EF7B4D?logo=argo&logoColor=white)
![OPA](https://img.shields.io/badge/Policy-OPA%20Gatekeeper-7B68EE?logo=openpolicyagent&logoColor=white)
![Falco](https://img.shields.io/badge/Runtime-Falco-00B1B0)
![Trivy](https://img.shields.io/badge/Scanner-Trivy-1904DA)

---

## 📌 Problem Statement

Most Kubernetes clusters fail security review for the same reasons: containers running as root, missing resource limits, `:latest` tags, privileged pods, unscanned images, and no runtime visibility. Fixing these reactively is expensive. **KubeSentinel** shifts security left (policy-as-code in CI + admission control) *and* right (runtime detection with Falco), wired together with a GitOps workflow so Git — not `kubectl` — is the source of truth.

## 🎯 What it demonstrates

- **Platform engineering** — reproducible local Kubernetes via Kind, one-command bootstrap.
- **GitOps** — Argo CD reconciles cluster state from this repo. No manual production `kubectl apply`.
- **Policy-as-Code** — OPA Gatekeeper rejects non-compliant workloads at admission time.
- **DevSecOps** — Trivy scans images, manifests, and configs in CI; pipeline fails on CRITICAL CVEs.
- **Runtime security** — Falco detects shell-in-container, privilege escalation, suspicious exec.
- **Observability** — Prometheus + Grafana for cluster, app, and policy-violation metrics.

---

## 🏗️ Architecture

```text
                        ┌──────────────────────────┐
                        │     Developer / CI       │
                        │   git push  →  GitHub    │
                        └────────────┬─────────────┘
                                     │
                ┌────────────────────┴────────────────────┐
                │           GitHub Actions (CI)           │
                │  lint → test → build → Trivy → policies │
                └────────────────────┬────────────────────┘
                                     │ image + manifests
                                     ▼
                        ┌──────────────────────────┐
                        │        Argo CD           │  ← source of truth: Git
                        │   sync → reconcile       │
                        └────────────┬─────────────┘
                                     ▼
   ┌─────────────────────────────────────────────────────────────────┐
   │                     Kubernetes (Kind cluster)                   │
   │                                                                 │
   │   ┌──────────────────┐   admission   ┌───────────────────────┐  │
   │   │  Demo App (API)  │ ◄──────────── │  OPA Gatekeeper       │  │
   │   │  /health /metrics│   reject if   │  no-root, no-latest,  │  │
   │   └────────┬─────────┘   unsafe      │  limits, no-privileged│  │
   │            │ metrics                 └───────────────────────┘  │
   │            ▼                                                    │
   │   ┌──────────────────┐    alerts     ┌───────────────────────┐  │
   │   │   Prometheus     │ ◄──────────── │        Falco          │  │
   │   │     Grafana      │               │  runtime threat feed  │  │
   │   └──────────────────┘               └───────────────────────┘  │
   └─────────────────────────────────────────────────────────────────┘
```

---

## ⚡ Quick Start

Requires: Docker, `kind`, `kubectl`, `helm`, `make`.

```bash
make cluster      # provision multi-node Kind cluster
make bootstrap    # install Argo CD, Gatekeeper, Prometheus, Falco
make deploy       # deploy demo app via GitOps
make scan         # run Trivy against image + manifests
make violate      # try to deploy intentionally insecure manifests (should be rejected)
make monitor      # print Grafana / Argo CD access instructions
make destroy      # tear it all down
```

Total bootstrap time on a laptop: ~5 minutes.

---

## 🧱 Repository Layout

```
kubesentinel/
├── apps/demo-app/             FastAPI service + Dockerfile + k8s manifests
├── argocd/                    Argo CD Application definitions
├── cluster/                   Kind config + bootstrap script
├── policies/gatekeeper/       ConstraintTemplates + Constraints
├── security/
│   ├── trivy/                 Trivy config + ignore policy
│   └── falco/                 Falco rules + values
├── monitoring/
│   ├── prometheus/            kube-prometheus-stack values
│   └── grafana/dashboards/    Custom dashboards (JSON)
├── manifests/bad/             Intentionally insecure manifests for `make violate`
├── .github/workflows/ci.yml   Lint → test → build → Trivy → policy validate
├── Makefile
└── README.md
```

---

## 🔄 GitOps Workflow

1. Developer pushes to `main`.
2. **CI** lints YAML, tests the app, builds the image, runs Trivy, and `kubectl --dry-run`s manifests through Gatekeeper policies.
3. On green, the image tag in `apps/demo-app/k8s/deployment.yaml` is bumped.
4. **Argo CD** detects the Git change and syncs the cluster automatically.
5. Gatekeeper enforces policies at admission. Anything non-compliant never reaches the kubelet.

No human runs `kubectl apply` in production. Rollback = `git revert`.

---

## 🚔 Policies (OPA Gatekeeper)

| Policy | Rejects when… |
|---|---|
| `K8sDisallowRoot` | `securityContext.runAsUser == 0` or `runAsNonRoot` missing |
| `K8sRequiredResources` | container has no `resources.limits.cpu` / `memory` |
| `K8sDisallowLatestTag` | image tag is `latest` or omitted |
| `K8sDisallowPrivileged` | `securityContext.privileged: true` |

Try it:

```bash
kubectl apply -f manifests/bad/root-container.yaml
# Error from server ([K8sDisallowRoot] Container must not run as root)
```

---

## 🔍 Security Workflow

```
Image build ──► Trivy (CRITICAL = fail) ──► Push registry
Manifest PR ──► kubeconform + Gatekeeper dry-run
Runtime    ──► Falco rules → stdout/JSON → Prometheus alert
```

Falco ships with rule overrides for: shell-in-container, write below `/etc`, package-manager exec inside a running pod, outbound connections to non-allow-listed CIDRs.

---

## 📈 Monitoring

`kube-prometheus-stack` (Prometheus, Alertmanager, Grafana, node-exporter, kube-state-metrics) plus two custom dashboards:

- **Cluster Health** — node CPU/mem, pod restarts, API latency.
- **Security Posture** — Gatekeeper denials over time, Falco alerts by rule, image scan results.

Access:

```bash
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80
# admin / prom-operator
```

---

## 🖼️ Screenshots

> _Add screenshots after running locally:_
> - `docs/img/argocd.png` — Argo CD app tree
> - `docs/img/grafana-security.png` — Security Posture dashboard
> - `docs/img/gatekeeper-deny.png` — `kubectl` rejection message
> - `docs/img/falco-alert.png` — Falco shell-in-container alert

---

## 🧠 Engineering Lessons

- **Admission control beats audit.** Catching a violation at `kubectl apply` is 100× cheaper than discovering it in a CVE report two sprints later.
- **GitOps makes rollback trivial.** `git revert` is the incident response runbook.
- **Defense in depth is not optional.** CI scanning, admission policies, and runtime detection each catch what the others miss.
- **Local-first developer loop.** Kind + Make gives every engineer the full platform on a laptop — no shared dev cluster, no drift.

## 🛣️ Future Improvements

- Sign images with **Cosign** and enforce signature verification in Gatekeeper.
- Generate **SBOMs** with Syft and gate releases on SBOM diff.
- Add **Kyverno** alongside Gatekeeper for mutation policies (auto-inject `runAsNonRoot`).
- **Tekton** pipelines for in-cluster CI.
- **External Secrets Operator** + HashiCorp Vault for secret management.
- Multi-tenant namespaces with **Network Policies** and **Hierarchical Namespace Controller**.

---

## 📜 License

MIT — see [LICENSE](LICENSE).
