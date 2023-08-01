You're now ready to complete the greetings application.

To create a greeting, you can use the `CONCAT`{{}} to concatenate a short greeting to each name.

However, if you were to just use a `SELECT CONCAT('Hello, ', name) ...`{{}} statement, then the results wouldn't be saved to the `greetings` topic. To persist the results, use a `CREATE TABLE AS`{{}} statement with the `kafka` connector, as shown below.

```sql
CREATE TABLE greetings WITH (
    'connector' = 'kafka',
    'topic' = 'greetings',
    'properties.bootstrap.servers' = 'redpanda-1:29092',
    'format' = 'json'
) AS
SELECT
    CONCAT('Hello, ', name) as greeting,
    PROCTIME() as processing_time
FROM
    names;
```{{copy}}

After copying the above statement into the shell and pressing `<Enter>`, type `QUIT;` into the shell to return to the bash shell.

```
QUIT;
```{{copy}}