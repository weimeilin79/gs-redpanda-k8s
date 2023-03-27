*Redpanda Keeper (rpk)* is a command line interface (CLI) tool to configure, manage, and tune Redpanda clusters. And it also let you manage topics, groups, and access control lists (ACLs).

Every container running Redpanda broker in K8s cluster has the tool installed. It is setup to interact with the Redpanda cluster you installed directly. 

Using the tool, it can retrieve information about brokers, topics, and the cluster.
```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster metadata
```

We'll use create a topic named _demo-topic_. 

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create demo-topic
```{{exec}}

You'll see the topic has been successfully created. 
```
TOPIC       STATUS
demo-topic  OK
```

Click the _+_ on the top to open a new terminal, where you will see _tab2_ appear. In the new tab let's go ahead and start a consumer that consumes from the newly created topic. 


```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic consume demo-topic
```{{exec}}

Click the _+_ on the top to open another new terminal, where you will see tab3 appear. In the new tab, this time, we'll use it to produce event to newly created topic. 

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic produce demo-topic
```{{exec}}

Type in following after the producer has started in Tab3

```
Hello from Redpanda!!
```{{exec}}

Going back to Tab2, you see the following message received and printed via the consumer process.

```
{
  "topic": "demo-topic",
  "value": "Hello from Redpanda!!",
  "timestamp": 1679950096639,
  "partition": 0,
  "offset": 0
}
```

Send few more messages, and in both Tab2 & Tab3, use ctl+C to terminate both processes. 