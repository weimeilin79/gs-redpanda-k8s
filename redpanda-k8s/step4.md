Updating and patching a Redpanda cluster is fairly straightforward.


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
helm upgrade --install redpanda redpanda/redpanda \
    --namespace redpanda --create-namespace \
    --values value.yaml --reuse-values

```{{exec}}

```
kubectl -n redpanda get pod
```{{exec}}

```
NAME                                READY   STATUS      RESTARTS   AGE
redpanda-0                          1/1     Running     0          2m29s
redpanda-configuration-w5kj8        0/1     Completed   0          31s
redpanda-console-5d77c44b95-wf6kg   1/1     Running     0          31s
redpanda-post-upgrade-2l5xg         0/1     Completed   0          25s
```

```
kubectl -n redpanda get svc
```{{exec}}


```
kubectl -n redpanda get ingress
```{{exec}}

Go to the [Redpanda Console]({{TRAFFIC_HOST2_80}}) the admin API, [go to the Traffic Port Accessor]({{TRAFFIC_SELECTOR}})).
