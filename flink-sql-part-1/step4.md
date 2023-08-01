Now, let's run a simple Flink pipeline to confirm everything is working as expected.

Note: due to some limitations of this environment, you'll need to copy and paste each statement into the Flink SQL shell on the right, and then press `<Enter>` to actually execute the statement.

First, let's set some configurations for our environment. You can set a configuration using the `SET <key> = <value>`{{}} statement.

Run the following statements, one by one, inside of the SQL shell. Be sure to press `<ENTER>`{{}} after each statement.

```sql
-- adjust the output format to improve readability
SET 'sql-client.execution.result-mode' = 'tableau';
```{{copy}}

```sql
-- set the name of our Flink job
SET 'pipeline.name' = 'Hello, World';
```{{copy}}

Additional configurations can be founded in <a href="https://nightlies.apache.org/flink/flink-docs-master/docs/dev/table/sqlclient/#sql-client-configuration" target="_blank">the official Flink docs</a>, but now you're ready to proceed with the rest of the tutorial.