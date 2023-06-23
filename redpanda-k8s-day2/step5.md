Install cert manger


echo 'admin:admin:SCRAM-SHA-256' >> superusers.txt

kubectl create secret generic redpanda-superusers -n redpanda --from-file=superusers.txt

helm upgrade --install redpanda redpanda/redpanda -n redpanda --create-namespace \
  --set auth.sasl.enabled=true \
  --set auth.sasl.secretRef=redpanda-superusers \
  --set auth.sasl.users=null \
  --reuse-values 




rpk topic create demo-topic  --brokers 0.0.0.0:31092

```
rpk cluster info \
  --tls-enabled \
  --tls-truststore cae.crt \
  --brokers localhost:31092
```{{exec}}

unable to request metadata: broker closed the connection immediately after a request was issued, which happens when SASL is required but not provided: is SASL missing?


```
rpk cluster info \
  --user admin \
  --password admin \
  --sasl-mechanism SCRAM-SHA-256 \
  --tls-enabled \
  --tls-truststore cae.crt \
  --brokers localhost:31092
```{{exec}}

