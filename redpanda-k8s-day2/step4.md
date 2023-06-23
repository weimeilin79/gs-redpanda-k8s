Install cert manger
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```{{exec}}

```
cat <<EOF > security.yaml
tls:
  enabled: true
EOF
```{{exec}}



```
auth:
  sasl:
    enabled: true
    secretRef: redpanda-superusers
    users:
      - name: admin
        password: admin
```


rpk topic create demo-topic  --brokers 0.0.0.0:31092


```
helm upgrade --install redpanda redpanda/redpanda -n redpanda --create-namespace \
  --set force=true \
  --values security.yaml \
  --reuse-values 
```{{exec}}

```
kubectl get nodes -o yaml
```{{exec}}

```
kubectl -n redpanda get secret redpanda-default-root-certificate -o go-template='{{ index .data "ca.crt" | base64decode }}' > ca.crt
```{{exec}}

```
cat <<EOF > value.yaml
console:
  enabled: true
  ingress:
    enabled: true
    hosts:
    - paths:
        - path: /
          pathType: ImplementationSpecific
EOF
```{{exec}}




```
cat <<EOF > value.yaml
console:
  enabled: true
  ingress:
    enabled: true
    hosts:
    - paths:
        - path: /
          pathType: ImplementationSpecific
EOF
```{{exec}}


To kick start Helm and upgrade a release with the new changes in setting, run:

```
helm upgrade --install redpanda redpanda/redpanda \
    --namespace redpanda --create-namespace \
    --values value.yaml --reuse-values

```{{exec}}


Get the api status:
```
 kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster info --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093 --tls-enabled --tls-truststore /etc/tls/certs/default/ca.crt 
```{{exec}}

Create a topic"
```
  kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create test-topic --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093 --tls-enabled --tls-truststore /etc/tls/certs/default/ca.crt 
```{{exec}}
Describe the topic:
```
  kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic describe test-topic --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093 --tls-enabled --tls-truststore /etc/tls/certs/default/ca.crt 
```{{exec}}
Delete the topic:
```
  kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic delete test-topic --brokers redpanda-0.redpanda.redpanda.svc.cluster.local.:9093 --tls-enabled --tls-truststore /etc/tls/certs/default/ca.crt
```{{exec}}