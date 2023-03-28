*Redpanda Keeper (rpk)* is a command line interface (CLI) tool to configure, manage, and tune Redpanda clusters. And it also let you manage topics, groups, and access control lists (ACLs).

Every container running Redpanda broker in K8s cluster has the tool installed. It is setup to interact with the Redpanda cluster you installed directly. 

Using the tool, it can retrieve information about the Redpanda cluster running.
```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster metadata
```{{exec}}

Because we have yet to create any topics, you will see information brokers and cluster

```
CLUSTER
=======
redpanda.81b5972f-2ec5-494e-999b-e9c4de2b2d6e

BROKERS
=======
ID    HOST                                             PORT
0*    redpanda-0.redpanda.redpanda.svc.cluster.local.  9093
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


Using the tool to check the cluster again.
```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster metadata
```{{exec}}

And this time you should be able to see the topic along with details like it's partition and replicas. 

```
CLUSTER
=======
redpanda.81b5972f-2ec5-494e-999b-e9c4de2b2d6e

BROKERS
=======
ID    HOST                                             PORT
0*    redpanda-0.redpanda.redpanda.svc.cluster.local.  9093

TOPICS
======
NAME        PARTITIONS  REPLICAS
demo-topic  1           1
```

Click the *+* on the top to open a new terminal, where you will see _Tab2_ appear. In the new tab let's go ahead and start a consumer that consumes from the newly created topic. 
```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic consume demo-topic
```{{exec}}

Click the *+* on the top to open another new terminal, where you will see _Tab3_ appear. In the new tab, this time, we'll use it to produce event to newly created topic. 

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic produce demo-topic
```{{exec}}

Type in following after the producer has started in _Tab3_

```
Hello from Redpanda!!
```{{exec}}

Going back to _Tab2_, you see the following message received and printed via the consumer process.

```
{
  "topic": "demo-topic",
  "value": "Hello from Redpanda!!",
  "timestamp": 1679950096639,
  "partition": 0,
  "offset": 0
}
```

Send few more messages, leave the 2 tabs running, we will need them in the next step. 