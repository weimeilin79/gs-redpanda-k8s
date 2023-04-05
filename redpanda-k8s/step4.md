Updating and patching a Redpanda cluster is fairly straightforward with Helm.
You can use the parameter, like how you deployed the cluster in step one, or you can create a YAML file with the new settings.

In this step, you add and spin up the **Redpanda Console**. Redpanda Console is a developer-friendly UI for managing your workloads. In this setting, you can see that you've enabled the console to deploy as well as set up an ingress endpoint, so you can access the console externally.  

![Redpanda console overview](./images/step-4-overview.png)

```
cat <<EOF > value.yaml
console:
  enabled: true
  ingress:
    enabled: true
    hosts:
    - paths:
        - path: /
          pathType: ImplementationSpecific
EOF
```{{exec}}


To kick start Helm and upgrade a release with the new changes in setting, run:

```
helm upgrade --install redpanda redpanda/redpanda \
    --namespace redpanda --create-namespace \
    --values value.yaml --reuse-values

```{{exec}}


Give it a minute or two, and your console should be deployed and ready. 

```
kubectl -n redpanda get pod
```{{exec}}


You see the redpanda-console Pod running. 

```
NAME                                READY   STATUS      RESTARTS   AGE
redpanda-0                          1/1     Running     0          2m29s
redpanda-configuration-w5kj8        0/1     Completed   0          31s
redpanda-console-5d77c44b95-wf6kg   1/1     Running     0          31s
redpanda-post-upgrade-2l5xg         0/1     Completed   0          25s
```


To see an ingress endpoint installed, run:

```
kubectl -n redpanda get ingress
```{{exec}}


It should be bound to port 80.

```
NAME               CLASS    HOSTS   ADDRESS     PORTS   AGE
redpanda-console   <none>   *       localhost   80      26m
```


Give it a couple of minutes to start. (Refresh it if you see 503 Service Temporarily Unavailable. This is a very limited cluster.)

Click [Redpanda Console]({{TRAFFIC_HOST1_80}}/) to access it in your browser.

You'll see the _demo-topic_ you created in Step 2.

![Redpanda console topic view](./images/step-4-topic.png)

Click into the topic to see all event streaming displayed.

![Redpanda console topic view](./images/step-4-topic-detail.png)

Congratulations on completing this tutorial with all components installed.

![Redpanda in K8s Overview](./images/RPinK8s.png)

Happy Streaming!