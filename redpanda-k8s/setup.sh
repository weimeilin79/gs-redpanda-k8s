kubectl create namespace redpanda 

kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml


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



wget https://get.helm.sh/helm-v3.9.3-linux-amd64.tar.gz 
tar xvf helm-v3.9.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin
helm repo add redpanda https://charts.redpanda.com 




  