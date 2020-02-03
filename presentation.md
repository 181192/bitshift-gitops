---
marp: true
theme: gitops
---

# GitOps -

---

# What is GitOps?

>A way of implementing Continuous Deployment for cloud native applications. It focuses on a developer-centric experience when operating infrastructure.

<!--
The core idea of GitOps is having a Git repository that always contains declarative descriptions of the infrastructure currently desired in the production environment and an automated process to make the production environment match the described state in the repository.

If you want to deploy a new application or update an existing one, you only need to update the repository
-->
---

# Okay, why should I use GitOps?

- Deploy faster more often
- Easy and fast error recovery - `git revert`
- Easier Credential Managment
- Self-documenting deployments

<!--
- __Deploy faster more often -__ Fast deployment, no switching tools `git push`

- __Easy and fast error recovery -__ Complete change history via git. Easy roll-back with `git revert`.
- __Easier Credential Managment -___ Manage deployments completely from inside your environment. Only need acces to your repository and image registry. You don't have to give your developers direct access to the environment
- __Self-documenting deployments -__
-->
---
# How does GitOps work?

__Environment Configuration as Git repository__ - There are at least two repositories: the application repository and the environment configuration repository. The application repository contains the source code of the application and the deployment manifests to deploy the application. The environment configuration repository contains all deployment manifests of the currently desired infrastructure of an deployment environment. It describes what applications and infrastructural services (message broker, service mesh, monitoring tool, …) should run with what configuration and version in the deployment environment.

---

# Push-based vs Pull-based Deployments

<!-- Two ways to implement the deployment strategy for GitOps: Push vs Pull -->

---

# Push-based deployments
![push-based deployments](./images/push.png)

---

# Pull-based deployments
![pull-based deployments](./images/pull.png)

---

# How does GitOps handle Dev to Prod propagation?

GitOps doesn’t provide a solution to propagating changes from one stage to the next one. We recommend using only a single environment and avoid stage propagation altogether. But if you need multiple stages (e.g., DEV, QA, PROD, etc.) with an environment for each, you need to handle the propagation outside of the GitOps scope, for example by some CI/CD pipeline.

---

# We are already doing DevOps. What's the difference to GitOps?

<!--
DevOps is all about the cultural change in an organization to make people work better together. GitOps is a technique to implement Continuous Delivery. While DevOps and GitOps share principles like automation and self-serviced infrastructure, it doesn’t really make sense to compare them. However, these shared principles certainly make it easier to adopt a GitOps workflow when you are already actively employing DevOps techniques.
-->

---

# So, is GitOps basically NoOps?

<!-- You can use GitOps to implement NoOps, but it doesn’t automatically make all operations tasks obsolete. If you are using cloud resources anyway, GitOps can be used to automate those. Typically, however, some part of the infrastructure like the network configuration or the Kubernetes cluster you use isn’t managed by yourself decentrally but rather managed centrally by some operations team. So operations never really goes away.
-->

---

# Weaveworks Flux - The GitOps Kubernetes operator

---

# The Flux Operator

![flux-cd-diagram](./images/flux-cd-diagram.png)

---

# The Flux Helm Operator, for declarative Helming

![fluxcd-helm-operator-diagram](./images/fluxcd-helm-operator-diagram.png)

---

# HelmRelease

```yaml
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: nginx-ingress
  namespace: ingress-nginx
  annotations:
    fluxcd.io/ignore: "false"
spec:
  releaseName: nginx-ingress
  chart:
    repository: https://kubernetes-charts.storage.googleapis.com/
    name: nginx-ingress
    version: 1.25.0
  values:
    controller:
      service:
        type: LoadBalancer
      metrics:
        enabled: true
```

---

# Example workflow

```shell
git add -A && \
git commit -m "install ingress" && \
git push origin master && \
fluxctl sync
```

---

# Automated upgrade

```yaml
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  annotations:
    fluxcd.io/automated: "true"
    fluxcd.io/tag.chart-image: semver:~3.0
```
---

# Canary releases

```yaml
apiVersion: flagger.app/v1alpha3
kind: Canary
metadata:
  name: podinfo
  namespace: prod
  annotations:
    fluxcd.io/ignore: "false"
spec:
  targetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: podinfo
  service:
    port: 9898
  canaryAnalysis:
    interval: 10s
    stepWeight: 5
    threshold: 5
    metrics:
    - name: request-success-rate
      threshold: 99
      interval: 1m
    - name: request-duration
      threshold: 500
      interval: 1m
    webhooks:
      - name: load-test
        url: http://load-tester.prod/
        metadata:
          cmd: "hey -z 2m -q 10 -c 2 http://podinfo:9898/"
```
