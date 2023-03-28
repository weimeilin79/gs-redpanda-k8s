```
cat <<EOF > value.yaml
console:
  enabled: true
  config: 
    console:
      redpanda:
        adminApi:
          enabled: true
          urls:
          - http://redpanda-0.redpanda.redpanda.svc.cluster.local.:9644
EOF
```{{exec}}





```
helm upgrade --install redpanda redpanda/redpanda \
    --namespace redpanda --create-namespace \
    --values value.yaml --reuse-values

```{{exec}}