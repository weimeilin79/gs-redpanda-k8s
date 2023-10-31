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



Error: UPGRADE FAILED: values don't meet the specifications of the schema(s) in the following chart(s):
redpanda:
- auth.sasl.users: Invalid type. Expected: array, given: null


```
rm -rf value.yaml
cat <<EOF > value.yaml
console:
  enabled: true
  ingress:
    enabled: true
    hosts:
    - paths:
        - path: /
          pathType: ImplementationSpecific
auth:
  sasl:
    users:
    - name: admin
      password: admin
      mechanism: SCRAM-SHA-512
EOF
```{{exec}}