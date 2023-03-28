

By default, Redpanda clusters are exposed through a NodePort Service. To display the services available: 

```
kubectl -n redpanda get svc
```{{exec}}

It will display a headless service which ping down the broker, which explicitly set ClusterIP to “None”. So it will discovering individual service broker in each pod. The *redpanda-external* is the NodePort service, that allows external access to the Redpanda broker via the external IP bounded to the K8s worker node.
```
NAME                TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                       AGE
redpanda            ClusterIP      None            <none>        <none>                                                        11m
redpanda-external   NodePort       10.105.46.176   <none>        9644:31644/TCP,9094:31092/TCP,8083:30082/TCP,8084:30081/TCP   11m
```

Normally you will use the external IP of the K8s worker node where your broker is hosted on. But due to the nature of Killercoda, the K8s worker node can be access via 0.0.0.0. Here is a table showing how the client can access the broker service both inside and outside of K8s cluster. 

| Listener  | K8s internal IP &Port | External IP & Port |
| -------- | ------- | ------- |
| Admin API | redpanda-0.redpanda.redpanda.svc.cluster.local:9644 |	0.0.0.0:31644 |
| Kafka	| redpanda-0.redpanda.redpanda.svc.cluster.local:9094 |	0.0.0.0:31092 |
| HTTP Proxy | redpanda-0.redpanda.redpanda.svc.cluster.local:8083 | 0.0.0.0:30082 |
| Schema Registry | redpanda-0.redpanda.redpanda.svc.cluster.local:8084 | 0.0.0.0:30081 |




We do not have to use NodePort, Redpanda also support Loadbalancer. 


```
cat <<EOF | kubectl -n redpanda apply -f -
apiVersion: v1
kind: Service
metadata:
  name: lb-redpanda-0
  namespace: redpanda
spec:
  type: LoadBalancer
  ports:
    - name: schemaregistry
      targetPort: 8081
      port: 8081
    - name: http
      targetPort: 8082
      port: 8082
    - name: kafka
      targetPort: 9093
      port: 9093
    - name: admin
      targetPort: 9644
      port: 9644
  selector:
    statefulset.kubernetes.io/pod-name: redpanda-0
EOF
```

Finally [ACCESS]({{TRAFFIC_HOST1_1234}}/hello) the Admin API through Istio <small>(or [select the port here]({{TRAFFIC_SELECTOR}}))</small>.


curl 0.0.0.0:31644/v1/clusters