Tools in this tutorial:

- `helm`: This helps you define, install, and upgrade applications running on Kubernetes.
- `kubectl`: The Kubernetes command-line tool lets you deploy applications, inspect and manage cluster resources, and view logs in Kubernetes cluster. 
- `rpk`: The Redpanda command-line tool lets you manage your entire Redpanda cluster, without the need to run a separate script for each function, as with Apache Kafka. The `rpk` commands handle everything from configuring nodes and low-level tuning to high-level general Redpanda tasks. 

Assume you have already deploy the Redpanda cluster in Kubernetes, and everything is running smoothly, so what next? Let's take a look around, a Redpanda cluster with one broker has already installed for you on this single node Kubernetes environment.


Run 

```
kubectl get all --namespace redpanda
```{{exec}}

you'll see a working Redpanda cluster in the _redpanda_ namespace

![Initial State](./images/step-1-initial-state.png)


Monitoring Redpanda after installation is crucial for ensuring the health, performance, and stability of your cluster. By monitoring Kafka, you gain valuable insights into its resource utilization, message throughput, and overall system behavior. 

![Overview](./images/step-1-overview.png)


To install Prometheus with helm chart, add the Prometheus repository

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts  
helm repo update
```{{exec}}


Since this tutorial environment has limited capacity, we will adjust the storage from default 8GB to 2 GB. 

```
cat <<EOF > value.yaml
server:
  name: server
  persistentVolume:
    enabled: true
    accessModes:
      - ReadWriteOnce
    size: 2Gi
EOF
```{{exec}}

Install Prometheus in the monitoring namespace

```
helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace --values value.yaml
```{{exec}}


```
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/instance=prometheus, app.kubernetes.io/component=server" -o jsonpath="{.items[0].metadata.name}")
```{{exec}}

```
kubectl get svc --namespace monitoring 
```{{exec}}

```
sed 's/PORT/80/g' /etc/killercoda/host
```{{exec}}

```
cat <<EOF | kubectl -n monitoring apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prometheus-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
    rules:
    - http:
        paths:
        - backend:
            service:
              name: prometheus-server 
              port:
                number: 80
          path: /
          pathType: Prefix
EOF
```{{exec}}


```
helm upgrade --install redpanda redpanda/redpanda \
  --namespace redpanda \
  --create-namespace \
  --set-string statefulset.annotations."prometheus\.io/scrape"="true",statefulset.annotations."prometheus\.io/path"=public_metrics,statefulset.annotations."prometheus\.io/port"="9644" \
  --reuse-values 
```{{exec}}

  Wait until all Pods are running:

```
kubectl -n redpanda rollout status statefulset redpanda --watch
```{{exec}}



Play with Prometheus


redpanda_cluster_topics

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create demo-topic
```{{exec}}


