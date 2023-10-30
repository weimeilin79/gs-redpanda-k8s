Every container running Redpanda brokers in a Kubernetes cluster has `rpk` installed. It's set up to directly interact with the Redpanda cluster you installed. 

Use `rpk` to retrieve information about the Redpanda cluster:

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster metadata
```{{exec}}

Because you haven't yet created any topics, you'll see information about the cluster and brokers:

```
CLUSTER
=======
redpanda.81b5972f-2ec5-494e-999b-e9c4de2b2d6e

BROKERS
=======
ID    HOST                                             PORT
0*    redpanda-0.redpanda.redpanda.svc.cluster.local.  9093
```

To create a topic named `demo-topic`, run:

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic create demo-topic
```{{exec}}

You'll see the topic has been successfully created. 

```
TOPIC       STATUS
demo-topic  OK
```

Use `rpk` to check the cluster again:

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk cluster metadata
```{{exec}}

This time, you see the topic along with details, like its partition and replicas. 

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

Now you'll start producing and consuming events. 

Click **+** on the top of the terminal to open a new terminal. You'll see **Tab2** appear. 

Click **Tab2** to enter that terminal.

On **Tab2**, start a consumer that consumes from the newly created topic:

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic consume demo-topic
```{{exec}}

Click **+** again to open **Tab3**, and click **Tab3** to enter that terminal.

On **Tab3**, produce an event to the newly-created topic:

```
kubectl -n redpanda exec -ti redpanda-0 -c redpanda -- rpk topic produce demo-topic
```{{exec}}

On **Tab3**, enter the following message after the producer has started:

```
Hello from Redpanda!!
```{{exec}}


Return to **Tab2**. You see the following message received and printed via the consumer process.

```
{
  "topic": "demo-topic",
  "value": "Hello from Redpanda!!",
  "timestamp": 1679950096639,
  "partition": 0,
  "offset": 0
}
```

Send a few more messages. Leave the two tabs running, because you'll need them in the next step. 