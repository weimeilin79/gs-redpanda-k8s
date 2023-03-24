## Deploy a Redpanda Cluster

Not all Kubernetes are equal, please do refer back to our product [documentation](https://docs.redpanda.com/docs/deploy/deployment-option/self-hosted/kubernetes) for more specific details.

Redpanda recommends the Helm chart for all new deployments. Therefore we will be using Redpanda's Helm chart to deploy and customize the configuration. 

Tools you will be using in this tutorial:

- *kubectl*: allows you to deploy applications, inspect and manage cluster resources, and view logs in Kubernetes cluster. 
- *helm*: help you define, install, and upgrade applications running on Kubernetes.
- *rpk*: allow you to configure and manage Redpanda clusters, tune them for better performance, manage topics and groups, manage access control lists (ACLs). 

First, we'll need to add the Redpanda Helm chart repository 
```
helm repo add redpanda https://charts.redpanda.com
```{{exec}}

In production environment, we will need to allocate sufficient numbers of CPU cores, since this tutorial runs on a tiny environment with very low hardware capacity limits, we will need to bypass the CPU limit check.

```
helm pull redpanda/redpanda --untar
rm redpanda/values.schema.json
```{{exec}}

In Kubernetes cluster, we'll isolate the Redpanda components in a logical namespace call _redpanda_, and let's create the namespace
```
kubectl create namespace redpanda
```{{exec}}


We'll allocate disk space to our Redpanda broker. It is recommended to use a dynamically provisioned using StorageClasses, if you are using EKS, GKE or AKS, it is unlike that you need this step. But for the purpose of this tutorial, we'll need to pre-define local storage in the cluster.

```
cat <<EOF | kubectl -n redpanda apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: datadir-redpanda-0
  annotations:
    volumeType: local
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 1Gi
EOF
```{{exec}}


And we are ready to kick of the deployment of Redpanda via Helm:

```
helm install -n redpanda redpanda ./redpanda \
--set statefulset.replicas=1 \
--set auth.sasl.enabled=false \
--set tls.enabled=false \
--set resource.cpu.overprovisioned=true \
--set resources.cpu.cores=300m \
--set storage.persistendVolume.size=1.2Gi \
--set resources.memory.container.max=1025Mi \
--set resources.memory.redpanda.reserveMemory=1Mi \
--set "console.enabled=false" \
--set resources.memory.redpanda.memory=1Gi
```


Print out Pod status

```
kubectl -n redpanda describe pod redpanda-0
```{{exec}}