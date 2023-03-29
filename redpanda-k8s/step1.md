Not all Kubernetes are equal, please do refer back to our product [documentation](https://docs.redpanda.com/docs/deploy/deployment-option/self-hosted/kubernetes) for more specific details.

Redpanda recommends the Helm chart for all new deployments. Therefore we will be using Redpanda's Helm chart to deploy and customize the configuration. 

Tools you will be using in this tutorial:

- *kubectl*: allows you to deploy applications, inspect and manage cluster resources, and view logs in Kubernetes cluster. 
- *helm*: help you define, install, and upgrade applications running on Kubernetes.
- *rpk*: allow you to configure and manage Redpanda clusters, tune them for better performance, manage topics and groups, manage access control lists (ACLs). 

Here is a quick diagram showing all components in the cluster. 
![Redpanda in K8s Overview](./images/RPinK8s.png)

First, we'll need to add the Redpanda Helm chart repository 
```
helm repo add redpanda https://charts.redpanda.com
```{{exec}}

In production environment, we will need to allocate sufficient numbers of CPU cores, since this tutorial runs on a tiny restricted environment with very low hardware capacity limits, you'll see warning on the minimum recommended resource, fear not, Redpanda will still work under this extreme limits.


In Kubernetes cluster, we'll isolate the Redpanda components in a logical namespace call _redpanda_, and let's create the namespace
```
kubectl create namespace redpanda
```{{exec}}


We'll allocate disk space to our Redpanda broker. It is recommended to use a dynamically provisioned using StorageClasses, if you are using EKS, GKE or AKS, it is unlikely that you need this step. But for the purpose of this tutorial, we'll need to pre-define local storage in the cluster.

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


And we are ready to kick off the deployment via Helm:

```
helm install redpanda redpanda/redpanda -n redpanda  \
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
```{{exec}}

It will take a couple of minutes to spin up, you will see the following prompting that Redpanda is successfully installed.

```
NAME: redpanda
LAST DEPLOYED: Mon Mar 27 20:11:47 2023
NAMESPACE: redpanda
STATUS: deployed
REVISION: 1
NOTES:
---

**Warning**: 1024 is below the minimum recommended value for Redpanda
**Warning**: 300m is below the minimum recommended CPU value for Redpanda

---

Congratulations on installing redpanda!
```


Check if you see the broker is running.
```
kubectl -n redpanda get pod
```{{exec}}

The following status will prompt showing a Redpanda broker is running. 
``` 
NAME                           READY   STATUS      RESTARTS   AGE
redpanda-0                     1/1     Running     0          2m50s
```

And your Redpanda is ready to roll in K8s! 