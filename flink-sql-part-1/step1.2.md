In order for Flink to communicate with Redpanda, you first need to install the Flink SQL Kafka Connector and any other dependencies you'll need for your application. You can view the list of connectors in <a href="https://nightlies.apache.org/flink/flink-docs-master/docs/connectors/table/overview/" target="_blank">the Flink docs</a>.

To achieve this, you can extend the base Flink image. We've already done this for you by adding the following commands to the `Dockerfile`, which installs the Kafka connector and a library for working with JSON. Here's a look at the Dockerfile.

```
FROM flink:1.16.0-scala_2.12-java11

# Download the connector and dependencies
RUN wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-sql-connector-kafka/1.16.0/flink-sql-connector-kafka-1.16.0.jar; \
    wget -P /opt/sql-client/lib/ https://repo.maven.apache.org/maven2/org/apache/flink/flink-json/1.16.0/flink-json-1.16.0.jar;
```{{}}

When you ran `docker-compose up -d`{{}} in the previous step, the custom image was automatically built from this `Dockerfile`, and is currently being used to run your local Flink cluster.
