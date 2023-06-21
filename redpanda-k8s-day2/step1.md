Step one 
 Add one more broker (Operator)

 Add Tooic (operator)

kubectl create namespace prometheus

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts


helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="local-path",server.persistentVolume.storageClass="local-path"


#OR

helm install prometheus prometheus-community/prometheus --namespace monitoring --create-namespace


export POD_NAME=$(kubectl get pods --namespace prometheus -l "app.kubernetes.io/instance=prometheus,app.kubernetes.io/component=server" -o jsonpath="{.items[0].metadata.name}")




helm upgrade --install redpanda redpanda/redpanda \
  --namespace redpanda \
  --create-namespace \
  --set-string statefulset.annotations."prometheus\.io/scrape"="true",statefulset.annotations."prometheus\.io/path"=public_metrics,statefulset.annotations."prometheus\.io/port"="<admin-api-port>"