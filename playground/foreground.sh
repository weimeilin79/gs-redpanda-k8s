#! /bin/bash

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
helm install redpanda redpanda/redpanda -n redpanda  --values values.yaml

while ! kubectl -n redpanda get pod -l app.kubernetes.io/instance=redpanda | grep -w "Running"; do
  echo  -n ".."
  sleep 1;
done

helm upgrade --install redpanda redpanda/redpanda \
    --namespace redpanda --create-namespace \
    --values console.yaml --reuse-values

while [ ! "$(curl -s -o /dev/null -w '%{http_code}' http://localhost)" == '200' ] ; do
  echo  -n ".."
  sleep 1;
done 

echo "REDPANDA PLAYGROUND READY.."