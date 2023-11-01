# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
alias helm=/usr/local/bin/helm

# Install Nginx Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx patch deployment ingress-nginx-controller -p '{"spec":{"template":{"spec":{"nodeSelector":null}}}}'

echo -n "Waiting for Nginx ingress to get ready...."
while ! kubectl -n ingress-nginx get pod -l app.kubernetes.io/component=controller | grep -w "Running"; do
  echo  -n ".."
  sleep 1;
done

source ~/.bashrc

#Install Helm
helm repo add redpanda https://charts.redpanda.com
kubectl create namespace redpanda

#Setup PersistentVolumeClaim
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


kubectl kustomize https://github.com/redpanda-data/redpanda//src/go/k8s/config/crd | kubectl apply -f -

helm upgrade --install redpanda-controller redpanda/operator \
  --namespace redpanda \
  --set image.repository=docker.redpanda.com/redpandadata/redpanda-operator \
  --set image.tag=v2.0.0 \
  --create-namespace \
  --timeout 10m


while ! kubectl get pod -n redpanda -l app.kubernetes.io/name=operator | grep -w "Running"; do
  echo  -n ".."
  sleep 1;
done

cat <<EOF | kubectl -n redpanda apply -f -
apiVersion: cluster.redpanda.com/v1alpha1
kind: Redpanda
metadata:
  name: redpanda
spec:
  chartRef: {}
  clusterSpec:
    external:
      domain: localhost
    statefulset:
      replicas: 1
    tls:
      enabled: false
    resources:
      cpu:
        overprovisioned: true
        cores: 300m
      memory:
        container:
          max: 1025Mi
        redpanda:
          reserveMemory: 1Mi
          memory: 1Gi
    auth:
      sasl:
        enabled: false
    storage:
      persistentVolume:
        enabled: true
        size: 2Gi
    console:
      enabled: false
EOF