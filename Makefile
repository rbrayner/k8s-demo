##@ Target
help:  ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install-kind-macos: ## Install kind on MacOS
	@brew install kind

install-kind-linux: ## Install kind on Ubuntu
	@curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
	@chmod +x ./kind
	@sudo mv ./kind /usr/local/bin/kind

start: ## Create the kind cluster
	@kind create cluster --config kind/cluster.yaml --name demo

stop: ## Destroy the kind cluster
	@kind delete cluster --name demo

list: ## List the available clusters
	@kind get clusters

1-pods: ## Run example-1
	@kubectl apply -f example-1-pods

2-services: ## Run example-2
	@kubectl apply -f example-2-services

3-deployments: ## Run example-3
	@kubectl apply -f example-3-deployments

4-replicas: ## Run example-4
	@kubectl apply -f example-4-replicas

5-updates-recreate: ## Run example-5 with recreate strategy
	@kubectl apply -f example-5-updates/svc.yaml
	@kubectl apply -f example-5-updates/recreate

5-updates-rolling: ## Run example-5 with rolling update strategy
	@kubectl apply -f example-5-updates/svc.yaml
	@kubectl apply -f example-5-updates/rolling-update

6-install-nginx:
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller	--timeout=180s

6-ingress-hostname: ## Run example-6 (by hostname example)
	@$(MAKE) 6-install-nginx
	@kubectl apply -f example-6-ingress/hostname

6-ingress-path: ## Run example-6 (by path example)
	@$(MAKE) 6-install-nginx
	@kubectl apply -f example-6-ingress/path

cleanup-examples: ## Cleanup all examples
	@kubectl delete deploy hello || true
	@kubectl delete pods hello bar-app foo-app || true
	@kubectl delete svc hello bar-service foo-service || true
	@kubectl delete ingress example-ingress hello || true

