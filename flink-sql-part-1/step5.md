
In order to consume data from the `names` Redpanda topic, you need to register a `TABLE` object. Run the `CREATE TABLE` statement below to achieve this.

```sql
CREATE TABLE names (name VARCHAR, website VARCHAR) WITH (
    'connector' = 'kafka',
    'topic' = 'names',
    'properties.bootstrap.servers' = 'redpanda-1:29092',
    'properties.group.id' = 'test-group',
    'properties.auto.offset.reset' = 'earliest',
    'format' = 'json'
);
```{{copy}}

Remember to hit `<Enter>` after each statement that you copy and paste inside the SQL shell.

You can check out the full grammar for the `CREATE TABLE`{{}} statement in <a href="https://nightlies.apache.org/flink/flink-docs-master/docs/dev/table/sql/create/#create-table" target="_blank">the Flink docs</a>, but to summarize:

- The record schema is described using column definitions: `(name VARCHAR, website VARCHAR)`{{}} 
- The `WITH` clause, and the properties within that clause, establish a connection to the Redpanda cluster using the `kafka` connector.

Each connector supports it's own set of properties, so you'll always need to reference the connector documentation when using different data sources. The Redpanda-compatible Kafka connector's documentation can be found <a href="https://nightlies.apache.org/flink/flink-docs-master/docs/connectors/table/kafka/" target="_blank">here</a>, so be sure to bookmark that for future reference.
