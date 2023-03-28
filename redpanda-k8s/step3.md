

By default, Redpanda clusters are exposed through a NodePort Service. To display the services available, go back to *Tab1* and run:

![Node Port](./images/step-3-np.png)

```
kubectl -n redpanda get svc
```{{exec}}

It will display a headless service which ping down the broker, which explicitly set ClusterIP to “None”. So it will discovering individual service broker in each pod. The *redpanda-external* is the NodePort service, that allows external access to the Redpanda broker via the external IP bounded to the K8s worker node.
```
NAME                TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                       AGE
redpanda            ClusterIP      None            <none>        <none>                                                        20m
redpanda-external   NodePort       10.99.142.230    <none>        9644:31644/TCP,9094:31092/TCP,8083:30082/TCP,8084:30081/TCP   20m
```

Normally you will use the external IP of the K8s worker node where your broker is hosted on. But due to the nature of Killercoda, the K8s worker node can be access via 0.0.0.0. Here is a table showing how the client can access the broker service both inside and outside of K8s cluster. 

| Listener  | K8s internal IP &Port | External IP & Port |
| -------- | ------- | ------- |
| Admin API | redpanda-0.redpanda.redpanda.svc.cluster.local:9644 |	0.0.0.0:31644 |
| Kafka	| redpanda-0.redpanda.redpanda.svc.cluster.local:9094 |	0.0.0.0:31092 |
| HTTP Proxy | redpanda-0.redpanda.redpanda.svc.cluster.local:8083 | 0.0.0.0:30082 |
| Schema Registry | redpanda-0.redpanda.redpanda.svc.cluster.local:8084 | 0.0.0.0:30081 |


We can try using the internal address for HTTP proxy to publish an event
```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- curl -s \
  -X POST \
  "http://redpanda-0.redpanda.redpanda.svc.cluster.local:8083/topics/demo-topic" \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  -d '{
    "records": [
        { 
            "value": "Hello world!"
        }
    ]
}'
```{{exec}}

Go to *Tab2* where you had the consumer open, and you should be able to see the event

```
{
  "topic": "demo-topic",
  "value": "\"Hello world!\"",
  "timestamp": 1679971100372,
  "partition": 0,
  "offset": 1
}
```

Now, let's try connecting externally through the NodePort endpoint, go back to *Tab1* and run:

```
curl -s \
  -X POST \
  "http://0.0.0.0:30082/topics/demo-topic" \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  -d '{
    "records": [
        { 
            "value": "Hello Universe!"
        }
    ]
}'
```{{exec}}

In *Tab2* where you had the consumer open, and you should be able to see the event
```
{
  "topic": "demo-topic",
  "value": "\"Hello Universe!\"",
  "timestamp": 1679971457079,
  "partition": 0,
  "offset": 4
}
```

We do not have to use NodePort, Redpanda also support _Loadbalancer_. 

![Load Balancer](./images/step-3-lb.png)

In *Tab1* run the following to install the Loadbalancer service.
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
```{{exec}}

There should be an addition Loadbalancer service,  it will now bind your Redpanda service to your default K8s host and domain.  
```
kubectl -n redpanda get svc
```{{exec}}

But due to the nature of Killercoda, the K8s host and domain is also bind to 0.0.0.0 (Normally your Worker Node IP & K8s domain should be completely different). 

```
NAME                TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                       AGE
lb-redpanda-0       LoadBalancer   10.104.112.167   <pending>     8081:30533/TCP,8082:30376/TCP,9093:31748/TCP,9644:31103/TCP   6s
redpanda            ClusterIP      None             <none>        <none>                                                        22m
redpanda-external   NodePort       10.99.142.230    <none>        9644:31644/TCP,9094:31092/TCP,8083:30082/TCP,8084:30081/TCP   22m
```


Here is a table showing how the client can access the broker service outside of K8s cluster. 
*(Your external bounded port will be different!!!)* 

| Listener  | K8s internal IP &Port | External IP & Port |
| -------- | ------- | ------- |
| Admin API | redpanda-0.redpanda.redpanda.svc.cluster.local:9644 |	0.0.0.0:31103 |
| Kafka	| redpanda-0.redpanda.redpanda.svc.cluster.local:9093 |	0.0.0.0:31748 |
| HTTP Proxy | redpanda-0.redpanda.redpanda.svc.cluster.local:8082 | 0.0.0.0:30376 |
| Schema Registry | redpanda-0.redpanda.redpanda.svc.cluster.local:8081 | 0.0.0.0:30533 |

Try connecting externally through the NodePort endpoint, go back to *Tab1* and run:
(Your external bounded port can be different, make sure you change that accordingly)

```
curl -s \
  -X POST \
  "http://0.0.0.0:{{YOUR HTTP Proxy External Port}}/topics/demo-topic" \
  -H "Content-Type: application/vnd.kafka.json.v2+json" \
  -d '{
    "records": [
        { 
            "value": "Hello Milky Way!"
        }
    ]
}'
```


In *Tab2* where you had the consumer open, and you should be able to see the event
```
{
  "topic": "demo-topic",
  "value": "\"Hello Milky Way!\"",
  "timestamp": 1679972709426,
  "partition": 0,
  "offset": 5
}
```

Finally, try accessing the Kakfa Admin API  [select the port here]({{TRAFFIC_SELECTOR}})).
Under _Host 1_ type in your Admin API external port, (in my case, it is 31103, yours will be different), and click the access button.
A new browser window/tab will open up, prompting:

```
{"message": "Not found", "code": 404}
```

Don't worry it's not an error, let's try get the broker configuration by adding *v1/node_config* to the URL and refresh the page.
![Node Config](./images/step-3-node-config.png)

In both _Tab2_ and _Tab3_ use *ctl+C* to terminate the consumer & producer processes. Feel free to also close the tabs, we will not be needing them from this point onwards. 

