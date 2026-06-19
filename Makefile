.PHONY: cluster bootstrap deploy scan violate monitor destroy help

CLUSTER_NAME ?= kubesentinel
IMAGE        ?= kubesentinel/demo-app:0.1.0

help:
	@echo "KubeSentinel — make targets"
	@echo "  cluster    Provision local Kind cluster"
	@echo "  bootstrap  Install Argo CD, Gatekeeper, Prometheus, Falco"
	@echo "  deploy     Deploy demo app via Argo CD"
	@echo "  scan       Trivy scan image + manifests"
	@echo "  violate    Apply intentionally insecure manifests (expect rejection)"
	@echo "  monitor    Print Grafana / Argo CD access instructions"
	@echo "  destroy    Delete the Kind cluster"

cluster:
	kind create cluster --name $(CLUSTER_NAME) --config cluster/kind-config.yaml
	kubectl cluster-info --context kind-$(CLUSTER_NAME)

bootstrap:
	bash cluster/bootstrap.sh

deploy:
	docker build -t $(IMAGE) apps/demo-app
	kind load docker-image $(IMAGE) --name $(CLUSTER_NAME)
	kubectl apply -f argocd/demo-app.yaml

scan:
	@echo "▶ Trivy image scan"
	trivy image --severity HIGH,CRITICAL --exit-code 1 $(IMAGE) || true
	@echo "▶ Trivy config scan"
	trivy config --severity HIGH,CRITICAL apps/demo-app/k8s policies manifests

violate:
	@echo "▶ Attempting to deploy insecure manifests — Gatekeeper should reject all of these:"
	-kubectl apply -f manifests/bad/root-container.yaml
	-kubectl apply -f manifests/bad/no-limits.yaml
	-kubectl apply -f manifests/bad/latest-tag.yaml
	-kubectl apply -f manifests/bad/privileged.yaml

monitor:
	@echo "Argo CD:   kubectl -n argocd port-forward svc/argocd-server 8080:443"
	@echo "           user: admin"
	@echo "           pass: kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
	@echo ""
	@echo "Grafana:   kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80"
	@echo "           user: admin / pass: prom-operator"
	@echo ""
	@echo "Falco:     kubectl -n falco logs -l app.kubernetes.io/name=falco -f"

destroy:
	kind delete cluster --name $(CLUSTER_NAME)
