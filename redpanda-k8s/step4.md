```
cat <<EOF > value.yaml
console:
  enabled: true
  ingress:
    enabled: true
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



```
cat <<EOF | kubectl -n redpanda apply -f -
apiVersion: v1
kind: Service
metadata:
  name: lb-redpanda-console
  namespace: redpanda
spec:
  type: LoadBalancer
  ports:
    - name: console
      targetPort: 8080
      port: 8080
  selector:
    statefulset.kubernetes.io/pod-name: redpanda-0
EOF
```{{exec}}