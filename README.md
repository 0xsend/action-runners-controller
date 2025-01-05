# Action Runner Controller

Following the [Action Runner Controller](https://github.com/actions-runner-controller/actions-runner-controller) documentation.
See the quickstart guide [here](https://docs.github.com/en/actions/hosting-your-own-runners/managing-self-hosted-runners-with-actions-runner-controller/quickstart-for-actions-runner-controller).

See the [Makefile](./Makefile) for a quick way to build and push the image to the GitHub Container Registry.

## Prerequisite

You need a kubernetes cluster. You can use [k3d](https://k3d.io/) or [k3s](https://k3s.io/).

### Installing k3s

```shell
curl -sfL https://get.k3s.io | sh - --cluster-init
```

### Installing k3s with a cluster using zerotier

```shell
curl -sfL https://get.k3s.io | sh -s - \
  --bind-address=0.0.0.0 \
  --flannel-iface=zt1234557 \
  --node-ip=10.0.0.2 \
  --cluster-init
```

## Installing Action Runner Controller

```shell
NAMESPACE="arc-systems"
helm install arc \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```

```shell
NAMESPACE="arc-systems"
helm upgrade --install arc \
    --namespace "${NAMESPACE}" \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller
```

### Authentiate ARC with GitHub

Obtain a Github App ID, Installation ID and Private Key from the [GitHub Apps](https://github.com/settings/apps/new) page.

```shell
kubectl create namespace arc-runners # if it doesn't exist
kubectl create secret generic pre-defined-secret \
   --namespace=arc-runners \
   --from-literal=github_app_id=123456 \
   --from-literal=github_app_installation_id=654321 \
   --from-literal=github_app_private_key='-----BEGIN RSA PRIVATE KEY-----********'
```

## Installing Action Runner Set

```shell
INSTALLATION_NAME="arc-runner-set"
NAMESPACE="arc-runners"
helm install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --create-namespace \
    -f ./runner-scale-set-values.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

To change or upgrade the installation, you can use the following command:

```shell
INSTALLATION_NAME="arc-runner-set"
NAMESPACE="arc-runners"
helm upgrade --install "${INSTALLATION_NAME}" \
    --namespace "${NAMESPACE}" \
    --values ./runner-scale-set-values.yaml \
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set
```

> [!TIP]
> You likely need to upgrade both the controller and the runner set to use the latest version of the runner.
