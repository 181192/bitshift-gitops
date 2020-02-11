install-flux-management:
	kubectl apply -f manifests-flux/namespace.yaml
	kubectl apply -f manifests-common/flux-helm-release-crd.yaml
	helm3 upgrade --namespace flux-system --install flux  manifests-flux/flux --values manifests-flux/bitshift-gitops-management-k8s-flux-values.yaml
	helm3 upgrade --namespace flux-system --install helm-operator  manifests-flux/helm-operator --values manifests-flux/bitshift-gitops-management-k8s-helm-operator-values.yaml

install-flux:
	kubectl apply -f manifests-flux/namespace.yaml
	kubectl apply -f manifests-common/flux-helm-release-crd.yaml
	helm3 upgrade --namespace flux-system --install flux  manifests-flux/flux --values manifests-flux/bitshift-gitops-k8s-flux-values.yaml
	helm3 upgrade --namespace flux-system --install helm-operator  manifests-flux/helm-operator --values manifests-flux/bitshift-gitops-k8s-helm-operator-values.yaml
