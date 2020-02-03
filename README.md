# GitOps - Cluster API, Cloud Resources, Canary Releases and Application configuration

> Kubernetes is a platform for building platforms.

Kubernetes is more than a container scheduler; it offers interfaces into a complete range of core infrastructure. In this talk we will with the power of GitOps see how we can utilize Kubernetes not only to run applications, but manage itself and provision cloud resources like databases.

The term "GitOps" term was originally coined by Weaveworks as a way to do operations by pull requests, and apply many of the same ideas behind reconciliation in kubernetes clusters to applications and clusters. This way of operating clusters enforces declarative infrastructure and serves as a source of truth for your systems. Always having the source of truth in Git provides many advantages, two of them are to always have the latest state to recover from in case of a cluster disaster, and secondly, complete audibility of what is going on in the cluster.
