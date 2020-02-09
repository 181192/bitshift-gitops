# GitOps - Cluster API, Cloud Resources, Canary Releases and Application configuration

> Kubernetes is a platform for building platforms.

Kubernetes is more than a container scheduler; it offers interfaces into a complete range of core infrastructure. In this talk we will with the power of GitOps see how we can utilize Kubernetes not only to run applications, but manage itself and provision cloud resources like databases.

The term "GitOps" term was originally coined by Weaveworks as a way to do operations by pull requests, and apply many of the same ideas behind reconciliation in kubernetes clusters to applications and clusters. This way of operating clusters enforces declarative infrastructure and serves as a source of truth for your systems. Always having the source of truth in Git provides many advantages, two of them are to always have the latest state to recover from in case of a cluster disaster, and secondly, complete audibility of what is going on in the cluster.

## Setup a management cluster

Setup environment variables

```
export AZURE_TENANT_ID=7a014d5a-2306-45a7-aca7-bf0288e80188
export AZURE_SUBSCRIPTION_ID=1eefb098-7c6a-4204-9ee9-349f23c63bbf
export AZURE_CLIENT_ID=6185cbdf-5795-4283-b9b2-3ec101f59fde
export AZURE_CLIENT_SECRET=d51fda4f-d649-4cc4-8c4a-60ae23b94ea3

export AZURE_LOCATION=westeurope
export AZURE_RESOURCE_GROUP=bitshift-gitops

export CLUSTER_NAME=bitshift-gitops-k8s
export VNET_NAME=bitshift-gitops-vnet

export OUTPUT_DIR=$(pwd)/manifests-cluster
```

Generate the cluster manifests

```
./bootstrap/generate.sh
```

This should output the following

```
manifests-cluster/
├── cluster.yaml
├── controlplane.yaml
├── machinedeployment.yaml
├── provider-components.yaml
├── sshkey
└── sshkey.pub
```

### Option 1. - Use an existing cluster

```
kubectl apply -f manifests-cluster/
```

### Option 2. - Use `clusterctl` with pivoting

```
clusterctl create cluster -v 4 \
  --bootstrap-type kind \
  --provider azure \
  -m manifests-cluster/machinedeployment.yaml \
  -c manifests-cluster/cluster.yaml \
  -p manifests-cluster/provider-components.yaml \
  -a bootstrap/cluster/addons.yaml
```
