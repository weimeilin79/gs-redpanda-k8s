Step three logging

```
helm repo add fluent https://fluent.github.io/helm-charts
helm -n monitoring  install fluent-bit fluent/fluent-bit 
```{{exec}}