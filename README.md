# local-horusec-cluster

A fully functional local Kubernetes cluster to develop and test your Horusec cluster offline!

## Requirements

* `Docker`
* `Terraform`

> **NOTE:** This installation does not require `kubectl`, but you will not be able to perform some of the examples in our
> docs without it. To install `kubectl` check
> the [installation docs](https://kubernetes.io/docs/tasks/tools/install-kubectl/).

## Running

Creating a Kubernetes cluster with a Horusec installation is as simple as:

```sh
make up
```

Deleting is equally simple:

```sh
make down
```
