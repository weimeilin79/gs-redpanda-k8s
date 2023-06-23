Install cert manger


echo 'admin:admin:SCRAM-SHA-256' >> superusers.txt

kubectl create secret generic redpanda-superusers -n redpanda --from-file=superusers.txt

helm upgrade --install redpanda redpanda/redpanda -n redpanda --create-namespace \
  --set auth.sasl.enabled=true \
  --set auth.sasl.secretRef=redpanda-superusers
  --set auth.sasl.users=null




rpk topic create demo-topic  --brokers 0.0.0.0:31092


```
rpk cluster info \
  --user admin \
  --password admin \
  --sasl-mechanism SCRAM-SHA-256 \
  --tls-enabled \
  --tls-truststore cae.crt \
  --brokers localhost:31092
```{{exec}}

rpk topic create test-topic  --brokers localhost:31092 --tls-truststore cae.crt

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
kubectl -n redpanda get secret redpanda-external-cert -o go-template='{{ index .data "ca.crt" | base64decode }}' > cea.crt
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