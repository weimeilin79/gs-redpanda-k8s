
1/ Start Redpanda Broker & Redpanda connector 

```
docker-compose -f docker-compose-rp.yaml up -d 
```{{exec}}

2/ Setup mm2 
```
{
    "connector.class": "org.apache.kafka.connect.mirror.MirrorSourceConnector",
    "name": "mirror-source-connector-redpanda",
    "offset-syncs.topic.replication.factor": "-1",
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

Click [Redpanda Console]({{TRAFFIC_HOST1_8080}}/) to access it in your browser.

3/ Check topic copied

Have fun! 