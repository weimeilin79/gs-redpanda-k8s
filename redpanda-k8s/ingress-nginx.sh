kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl -n ingress-nginx patch deployment ingress-nginx-controller -p '{"spec":{"template":{"spec":{"nodeSelector":{"kubernetes.io/hostname":"controlplane"}}}}}'


while ! kubectl -n ingress-nginx get pod -l app.kubernetes.io/component=controller | grep -w "Running"; do
  echo "Waiting for Nginx ingress to get ready......"
  sleep 1;
done