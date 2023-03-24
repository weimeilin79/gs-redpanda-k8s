Run to create the namespace `kubectl create namespace redpanda `


Create local PVC 

```
cat <<EOF | kubectl -n redpanda apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: datadir-redpanda-0
  annotations:
    volumeType: local
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-path
  resources:
    requests:
      storage: 1Gi
EOF
```


Install Redpanda via Helm

```
helm install redpanda redpanda/redpanda -n redpanda \
 --set "statefulset.replicas=1" \
 --set "auth.sasl.enabled=false" \
 --set "tls.enabled=false" \
 --set "resources.memory.container.max=1Gi" \
 --set "resources.memory.container.min=1Gi" \
 --set "resources.memory.redpanda.memory=512M" \
 --set "resources.memory.redpanda.reserveMemory=512M" \
 --set "resource.cpu.overprovisioned=true" \
 --set "resource.cpu.cores=650m" \
 --set "console.enabled=false" \
 --set "storage.persistentVolume.size=1Gi"
```