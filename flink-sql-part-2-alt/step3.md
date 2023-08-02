
In the previous tutorial, you ran a Flink pipeline by typing in the individual queries inside the interactive SQL prompt. This time, we have saved the queries that implement the sentiment strategy inside of a file. Therefore, the SQL client has been configured to run the file directly, as you can see below (see the `-f /etc/sql/strategy.sql`{{}} lines).

```yaml
  sql-client:
    container_name: sql-client
    build:
      context: .
      dockerfile: Dockerfile
    command:
      - /opt/flink/bin/sql-client.sh
      - embedded
      - -l
      - /opt/sql-client/lib
      # run the queries from a file
      - -f
      - /etc/sql/strategy.sql
```

Since the topics weren't created when you initially started the client, go ahead and restart it for safe measure to ensure the job is running.

```
docker-compose -f docker-compose-kc-alt.yaml restart sql-client
```{{exec}}

