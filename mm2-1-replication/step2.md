
There are several ways to set up Redpanda; in this guide, we'll focus on using the Docker images. You can quickly get Redpanda clusters up and running with Docker Compose or Kubernetes.

Take a peek at the docker-compose-rp.yaml file to see the services you'll be deploying:

Inside, you'll find three services:

*redpanda-0*: This is the broker's name. In this lab, because of limited resources, we're just spinning up a single broker. But remember, in a real-world setup, you'd have multiple brokers for high availability, fault tolerance, and better scaling.
*redpanda-console*: This links to the Redpanda Console, which is the official UI for Redpanda.
*connector*: This Docker image is used to set up managed connectors for Redpanda.

Alright, it's time to get these services going. Kick them off with the following command:
```
docker-compose -f docker-compose-rp.yaml up -d 
```{{exec}}

Please be patient for a moment. You'll know it's done when you see:

```
Creating redpanda-0 ... done
Creating redpanda-console ... done
Creating connector ... done
```


MirrorMaker 2.0 (MM2) brings in the idea of connectors to make mirroring data and setups between Kafka clusters a breeze.

Here are the big three connectors that MM2 boasts of:
- MirrorSourceConnector 
- MirrorCheckpointConnector 
- MirrorHeartbeatConnector 

Click on [Redpanda Console]({{TRAFFIC_HOST1_8080}}/) and access it via your browser. On the left menu, tap on [connector]({{TRAFFIC_HOST1_8080}}/connect-clusters/rp-connector). Ready to set up your first connector? Click the *Create Connector* button at the top of the page and pick "import data from Kafka cluster topics" on the next screen. This will lead you to configure the *MirrorSourceConnector*.

The *MirrorSourceConnector* is your go-to for copying data from your source Kafka cluster to the Redpanda cluster. It consumes records from source topics on the source cluster and then produces them to the corresponding mirrored topics on the target cluster. It also takes care of offset translation between source and target topics so that it can provide exactly-once delivery semantics.

Move past the configuration page, and hit *Next*. In the *Connector Properties* section, overwrite the existing content with the following:

```
{
    "connector.class": "org.apache.kafka.connect.mirror.MirrorSourceConnector",
    "name": "mirror-source-connector-redpanda",
    "offset-syncs.topic.replication.factor": "-1",
    "key.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "replication.factor": "-1",
    "replication.policy.class": "org.apache.kafka.connect.mirror.IdentityReplicationPolicy",
    "security.protocol": "PLAINTEXT",
    "source.cluster.alias": "source",
    "source.cluster.bootstrap.servers": "kafka:9094",
    "source.cluster.sasl.mechanism": "PLAIN",
    "source.cluster.security.protocol": "PLAINTEXT",
    "source.cluster.ssl.keystore.type": "PEM",
    "source.cluster.ssl.truststore.type": "PEM",
    "sync.topic.acls.enabled": "false",
    "sync.topic.configs.enabled": "true",
    "target.cluster.bootstrap.servers": "redpanda-0:9092",
    "topics.exclude": ".*[\\-\\.]internal,.*\\.replica,__consumer_offsets,_redpanda_e2e_probe,__redpanda.cloud.sla_verification,_internal_connectors.*,_schemas"
}
```{{copy}}



*MirrorCheckpointConnector*  manages checkpoints, it periodically consumes from all internal MM2 topics on the target cluster (like mm2-offsets.<source-cluster>, mm2-configs.<source-cluster>, and so on) and emits checkpoints to the mm2-offset-checkpoints.<target-cluster> topic. These checkpoints are essential to translating offsets between source and target clusters, which is essential for failover.

```
{
    "connector.class": "org.apache.kafka.connect.mirror.MirrorCheckpointConnector",
    "name": "mirror-checkpoint-redpanda",
    "key.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "source.cluster.alias": "source",
    "source.cluster.bootstrap.servers": "kafka:9094",
    "target.cluster.alias": "target",
    "target.cluster.bootstrap.servers": "redpanda-0:9092"
}
```{{copy}}

*MirrorHeartbeatConnector* like it's name, it produces heartbeats to predefined topics on the source cluster. These heartbeats are replicated to the target cluster like regular data and can be used to measure replication latency and ensure that the replication is alive and well. 

```
{
    "connector.class": "org.apache.kafka.connect.mirror.MirrorHeartbeatConnector",
    "name": "mirror-heartbeat-redpanda",
    "key.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "source.cluster.alias": "source",
    "source.cluster.bootstrap.servers": "kafka:9094",
    "target.cluster.alias": "target",
    "target.cluster.bootstrap.servers": "redpanda-0:9092"
}
```{{copy}}




3/ Check topic copied

A. Check if Topic is replicated to Redpanda
B. In Tab2 push few more message in the producer and see if they were replicated in Redpanda cluster.


Have fun! 