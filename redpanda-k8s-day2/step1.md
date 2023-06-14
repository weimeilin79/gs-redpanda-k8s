Redpanda recommends using the Redpanda Helm chart for all new deployments. For detailed information about running Redpanda in Kubernetes, see the [Redpanda documentation](https://docs.redpanda.com/docs/deploy/deployment-option/self-hosted/kubernetes).

Tools in this tutorial:

- Helm: This helps you define, install, and upgrade applications running on Kubernetes.
- `kubectl`: The Kubernetes command-line tool lets you deploy applications, inspect and manage cluster resources, and view logs in Kubernetes cluster. 
- `rpk`: The Redpanda command-line tool lets you manage your entire Redpanda cluster, without the need to run a separate script for each function, as with Apache Kafka. The `rpk` commands handle everything from configuring nodes and low-level tuning to high-level general Redpanda tasks. 

The following diagram shows all components in the cluster. 

![Redpanda in K8s Overview](./images/RPinK8s.png)

First, to install the Redpanda Helm chart repository, run: 

```
helm repo add redpanda https://charts.redpanda.com
```{{exec}}

Note: In a production environment, you need to allocate sufficient numbers of CPU cores. Because this tutorial runs in a restricted environment with very low hardware capacity limits, you'll see warnings about the minimum recommended resource. Redpanda works fine with these limitations.

In the Kubernetes cluster, you'll isolate the Redpanda components in a logical namespace called `redpanda`. 

To create the namespace, run:

```
kubectl create namespace redpanda
```{{exec}}


Next, allocate disk space to the Redpanda broker with a dynamically-provisioned PersistentVolume using StorageClasses. On EKS, GKE, or AKS, it's unlikely that you would need this step. But for this tutorial, you'll predefine local storage in the cluster. 

To allocate disk space, run:

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


To kick off the deployment with Helm, run:

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

This takes a couple minutes to spin up. You'll see the following prompt when Redpanda is successfully installed.

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


To confirm that the broker is up, run:

```
kubectl -n redpanda get pod
```{{exec}}

The following status confirms that a Redpanda broker is running. 
``` 
NAME                           READY   STATUS      RESTARTS   AGE
redpanda-0                     1/1     Running     0          2m50s
```

Redpanda is ready to roll in Kubernetes! 