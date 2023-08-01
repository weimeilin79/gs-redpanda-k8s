The Apache Flink community maintains an official set of Docker images that allow you to run Flink in a variety ways. In this tutorial, you'll use these images to run Flink in a Docker Compose environment.

Go ahead and start the services by running:

```
docker-compose up -d
```{{exec}}

The `docker-compose.yaml` file defines four services:

- `redpanda-1`{{}} is the name of the Redpanda broker that your Flink application will interact with.

- `jobmanager`{{}} is the Flink job manager, which will coordinate execution of your stream processing applications.

- `taskmanager`{{}} is the Flink task manager, which will actually execute your Flink queries.

- `sql-client`{{}} is the Flink SQL client, where you'll write queries and submit your jobs to the job manager.

If you inspect the `docker-compose.yaml` file, you'll see that all of the Flink services reference a `Dockerfile`.

```
cat docker-compose.yaml | grep -B2 -e image -e build
```{{exec}}

For example:

```yaml
jobmanager:
    build: {context: ., dockerfile: Dockerfile}
```{{}}

We'll look at the Dockerfile next.

