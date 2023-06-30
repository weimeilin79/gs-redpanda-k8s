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

#Install redpanda
helm install redpanda redpanda/redpanda -n redpanda  \
--set statefulset.replicas=1 \
--set auth.sasl.enabled=false \
--set tls.enabled=false \
--set resource.cpu.overprovisioned=true \
--set resources.cpu.cores=300m \
--set storage.persistentVolume.size=3Gi \
--set resources.memory.container.max=1025Mi \
--set resources.memory.redpanda.reserveMemory=1Mi \
--set "console.enabled=false" \
--set resources.memory.redpanda.memory=1Gi \
--set external.domain='' \
--set external.addresses={'localhost'} \
--set config.cluster.auto_create_topics_enabled=true 