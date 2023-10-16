Since we are building a streaming ETL pipeline, capturing the changes made to the source database and propagating them to downstream systems in real time is important.

We do that by creating a MySQL connector in Debezium as follows.

```
docker-compose exec debezium curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '
 {
  "name": "mysql-connector",
  "config": {
    "connector.class": "io.debezium.connector.mysql.MySqlConnector",
    "tasks.max": "1",
    "database.hostname": "mysql",
    "database.port": "3306",
    "database.user": "debezium",
    "database.password": "dbz",
    "database.server.id": "184054",
    "topic.prefix": "dbz",
    "database.include.list": "masterclass",
    "schema.history.internal.kafka.bootstrap.servers": "redpanda:9092",
    "schema.history.internal.kafka.topic": "schemahistory.inventory",
    "transforms":"unwrap",
    "transforms.unwrap.type":"io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones":false,
    "transforms.unwrap.delete.handling.mode":"rewrite"
  }
}'
```{{exec}}

Notice the `database.*` configurations specify connectivity details to the `mysql` container. The parameter, `schema.history.internal.kafka.bootstrap.servers` points to the `redpanda` broker the connector uses to write and recover DDL statements to the database schema history topic.

Wait a minute or two until the connector gets deployed inside Debezium and creates the initial snapshot in Redpanda.

Next, check the list of topics in `redpanda` by running:

```
docker-compose exec redpanda rpk topic list
```{{exec}}

You will see three topics with the prefix `dbz.*` specified in the connector configuration. These topics hold the snapshots of change events streamed from MySQL tables.

Finally, you can see the shape of change events by consuming any change feed topic.

```
docker-compose exec redpanda rpk topic consume dbz.masterclass.order_items 
```{{exec}}

Press `Ctrl+C` to terminate the `rpk` session and return to the normal prompt.

