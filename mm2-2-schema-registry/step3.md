
### Migrating producer and consumers


We are now have the producer and consumer point to the new Redpanda cluster, to do this, we need to update the broker location.  For producer, navigate to the editor tab. In the left explorer panel, drill down to the directory path _quarkus-apps/avro-schema-producer/src/main/resources_ and open the **application.properties** file. 

- Replace the old broker from `kafka.bootstrap.servers=PLAINTEXT://localhost:29094` to `kafka.bootstrap.servers=PLAINTEXT://localhost:19092`
- Replace the old registry from `mp.messaging.connector.smallrye-kafka.schema.registry.url=http://localhost:8081` to `mp.messaging.connector.smallrye-kafka.schema.registry.url=http://localhost:18081`

And apply the same change to consumer, by updating the **application.properties** file under directory _quarkus-apps/avro-schema-consumer/src/main/resources_.

Update pom.xml

We'll need a consumer, our consumer will be grabbing the latest schema from the registry. Stay in _tab 3_, and build the consumer:
```
cd /root/quarkus-apps/avro-schema-consumer/
./mvnw process-resources install quarkus:run -Dquarkus.http.port=9091
```{{exec}}



```
cd /root/quarkus-apps/avro-schema-producer/
./mvnw generate-resources install quarkus:run -Dquarkus.http.port=9090
```{{exec}}


Congratulation, you have completed migrating from Kafka to Redpanda cluster.
