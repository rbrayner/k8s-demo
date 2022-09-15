VARIABLES_FILE := ./.env

ifneq (,$(wildcard $(VARIABLES_FILE)))
    include ${VARIABLES_FILE}
    export
endif

# Default shell
SHELL = /bin/bash

.PHONY: example-1

##@ Target
help:  ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

install-kind-macos: ## Install kind on MacOS
	@brew install kind

install-kind-linux: ## Install kind on Ubuntu
	@curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.15.0/kind-linux-amd64
	@chmod +x ./kind
	@sudo mv ./kind /usr/local/bin/kind

create-cluster: ## Create the kind cluster
	@kind create cluster --config kind/cluster.yaml --name demo

destroy-cluster: ## Destroy the kind cluster
	@kind delete cluster --name demo

list-clusters: ## List the available clusters
	@kind get clusters

example-1: ## Run example-1
	@kubectl apply -f example-1

destroy-examples: ## Destroy all examples
	@kubectl delete -f example-1 || true

