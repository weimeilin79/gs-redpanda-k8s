So far, we have verified that the change data streams from MySQL are reaching respective Redpanda topics. What remains is to join two change streams, `order_items` and `products`, to calculate the top-selling products.

The join and aggregation must happen in real-time, and the results should be written to Postgres immediately. To achieve that, we will define the necessary tables in Flink, write a continuous query, and deploy.

The Flink cluster in the pipeline consists of three containers:
- `jobmanager` is the Flink job manager, coordinating the execution of your stream processing applications.
- `taskmanager` is the Flink task manager, executing your Flink queries.
- `sql-client` is the Flink SQL client, where you'll write queries and submit your jobs to the job manager.

If you inspect the `docker-compose.yaml` file, you'll see that all of the Flink services reference a `Dockerfile`.

```
cat docker-compose.yml | grep -B2 -e image -e build
```{{exec}}

For example:

```yaml
jobmanager:
    build: {context: ., dockerfile: Dockerfile}
```{{}}

We'll look at the Dockerfile next.