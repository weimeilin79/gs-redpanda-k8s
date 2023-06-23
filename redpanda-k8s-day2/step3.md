Step three logging


```
helm repo add grafana https://grafana.github.io/helm-charts
helm -n monitoring  install loki grafana/loki-stack --set grafana.enabled=false
```{{exec}}

```
kubectl -n monitoring get pod
```{{exec}}

```
NAME                                                 READY   STATUS    RESTARTS      AGE
loki-0                                               1/1     Running   0             115s
loki-promtail-p9q5q                                  1/1     Running   0             115s
```

The default installation settings of the loki stack are pretty complete:

the data source is correctly configured in Grafana
promtail is configured to scrape the logs of the pods running on your cluster
This means you can directly head to the Explore menu to check the logs of your pods:

click on the compass on the left;
at the top of the screen, select the loki;
the main field at the top allows to type a LogQL query.

You can try with the following query, that will show you the logs from the pods of the loki namespace:

{namespace="loki"}