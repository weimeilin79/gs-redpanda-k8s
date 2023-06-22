
```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts  
helm repo update
```{{exec}}


```
cat <<EOF > value.yaml
server:
  name: server
  ingress:
    enabled: true
    ingressClassName: nginx
    path: /prometheus
    ingressPathType: ImplementationSpecific
    extraPaths: 
    - path: /*
      backend:
        serviceName: prometheus-server 
        servicePort: 80
  persistentVolume:
    enabled: true
    accessModes:
      - ReadWriteOnce
    size: 2Gi
EOF
```{{exec}}


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
          pathType: ImplementationSpecific
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


