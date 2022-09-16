# k8s-demo


- [k8s-demo](#k8s-demo)
  - [1. Objective](#1-objective)
  - [2. Requirements](#2-requirements)
  - [3. Examples](#3-examples)
    - [3.1. Create a single pod](#31-create-a-single-pod)
    - [3.2. Create a service to the pod](#32-create-a-service-to-the-pod)
    - [3.3. Create a deployment](#33-create-a-deployment)
    - [3.4. Scale the application](#34-scale-the-application)
    - [3.5. Update with recreate strategy](#35-update-with-recreate-strategy)
    - [3.6. Update with rollingUpdate strategy](#36-update-with-rollingupdate-strategy)
  - [4. Cleanup](#4-cleanup)
  - [5. Sources](#5-sources)

## 1. Objective

This repository aims to help kubernetes beginners to learn the basics with very simple examples obtained from many sources. I have created a `Makefile` to simplify the example's execution.


## 2. Requirements
- Linux or MacOS
- docker
- kubectl
- curl
- make
- kind ([kind.io](https://kind.sigs.k8s.io/))

Install kind and execute the following command to start a kubernetes cluster:

```shell
make start
make list
```

## 3. Examples

### 3.1. Create a single pod

```shell
make 1-pods
kubectl get pods
kubectl delete pod hello
kubectl get pods
```

### 3.2. Create a service to the pod

```shell
make 2-services
kubectl get pods,svc
curl localhost:31000
kubectl delete pod hello
curl localhost:31000
kubectl delete svc hello
```

### 3.3. Create a deployment

```shell
make 3-deployments
kubectl get pods,svc
curl localhost:31000
kubectl delete pods -l app=hello
curl localhost:31000
kubectl delete svc hello
kubectl delete deploy hello
```

### 3.4. Scale the application

```shell
make 4-replicas
kubectl get pods,svc
curl localhost:31000
kubectl delete svc hello
kubectl delete deploy hello
```

### 3.5. Update with recreate strategy

```shell
make 5-updates-recreate
kubectl get pods,svc
curl localhost:31000
kubectl set image deployment/hello hello-from=pbitty/hello-from:error
kubectl get pods
kubectl get replicasets
curl localhost:31000
kubectl rollout status deployment/hello
kubectl rollout history deploy/hello
kubectl rollout history deploy/hello --revision=2
kubectl rollout history deploy/hello --revision=1
kubectl rollout undo deployment/hello --to-revision 1
kubectl rollout status deployment/hello
curl localhost:31000
kubectl delete svc hello
kubectl delete deploy hello
```

### 3.6. Update with rollingUpdate strategy

```shell
make 5-updates-rolling
kubectl get pods,svc
curl localhost:31000
kubectl set image deployment/hello hello-from=pbitty/hello-from:error
kubectl get pods
kubectl get replicasets
curl localhost:31000
kubectl rollout status deployment/hello
kubectl rollout history deploy/hello
kubectl rollout history deploy/hello --revision=2
kubectl rollout history deploy/hello --revision=1
kubectl rollout undo deployment/hello --to-revision 1
kubectl rollout status deployment/hello
curl localhost:31000
kubectl delete svc hello
kubectl delete deploy hello
```


## 4. Cleanup

The following command deletes the cluster:

```shell
make stop
```
## 5. Sources

https://kubernetes.io/

https://minikube.sigs.k8s.io/docs/tutorials/multi_node/

https://kind.sigs.k8s.io/docs/user/ingress/#ingress-nginx
