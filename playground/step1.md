Wait until installation is done, you will be prompted with:
```
REDPANDA PLAYGROUND READY!!!!!
```

A Redpanda cluster with one broker will be up and running for you on this single node Kubernetes environment.
![Redpanda Playground Overview](./images/overview.png)

Tools available in the playground:

- Helm: This helps you define, install, and upgrade applications running on Kubernetes.
- `kubectl`: The Kubernetes command-line tool lets you deploy applications, inspect and manage cluster resources, and view logs in Kubernetes cluster. 
- `rpk`: The Redpanda command-line tool lets you manage your entire Redpanda cluster, without the need to run a separate script for each function, as with Apache Kafka. The `rpk` commands handle everything from configuring nodes and low-level tuning to high-level general Redpanda tasks. 


You may connect to the cluster with RPK tools access externally (Outside K8s):
```
rpk cluster info \
  --brokers localhost:31092
```{{exec}}

Or internally 
```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster info
```{{exec}}


Click [Redpanda Console]({{TRAFFIC_HOST1_80}}/) to access it in your browser.

Have fun! 