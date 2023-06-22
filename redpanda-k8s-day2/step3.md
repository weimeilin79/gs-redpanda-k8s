Step three logging

```
helm repo add fluent https://fluent.github.io/helm-charts
helm -n monitoring install fluent-bit fluent/fluent-bit 
```{{exec}}


```
helm repo add grafana https://grafana.github.io/helm-charts
helm  -n monitoring  install loki grafana/loki-stack--namespace loki --set grafana.enabled=false
```{{exec}}