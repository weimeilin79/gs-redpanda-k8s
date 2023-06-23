Install cert manger
```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```{{exec}}

```
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.12.0 \
  --set installCRDs=true
```{{exec}}

```
cat <<EOF > security.yaml
tls:
  enabled: true
EOF
```{{exec}}


```
helm upgrade --install redpanda redpanda/redpanda -n redpanda --create-namespace \
  --set force=true \
  --values security.yaml \
  --reuse-values 
```{{exec}}



rpk topic create demo-topic  --brokers 0.0.0.0:31092


```
kubectl -n redpanda patch certificate redpanda-external-cert -p '[{"op": "add", "path": "/spec/dnsNames" , "value":["localhost"]}]' --type='json'
kubectl -n redpanda delete secret redpanda-external-cert
```{{exec}}

```
kubectl -n redpanda get secret redpanda-external-cert -o go-template='{{ index .data "ca.crt" | base64decode }}' > cae.crt
```{{exec}}


```
rpk cluster info  --brokers localhost:31092 
```{{exec}}

```
rpk cluster info  --brokers localhost:31092 --tls-truststore cae.crt
```{{exec}}

```
rpk topic create test-topic  --brokers localhost:31092 --tls-truststore cae.crt
```{{exec}}

```
kubectl get nodes -o yaml
```{{exec}}

