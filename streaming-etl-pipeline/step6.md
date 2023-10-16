
Now, we have everything in place to code the streaming ETL logic in Flink. We will begin by defining source and sink tables, followed by an aggregation query that calculates the top-selling products. 

You'll use Flink's highest-level API, Flink SQL, to code the above. Flink SQL allows you to express complex stream and batch processing logic using a concise and familiar language.

The first step to building the application is to start the Flink SQL client. You'll use this client to submit your jobs to the Flink cluster.
To start the client, run the following command:

```
docker-compose run sql-client
```{{exec interrupt}}

You should see a terminal with a giant squirrel in it.

You must register two TABLE objects, `order_items` and `products` to consume from corresponding Redpanda topics, `dbz.masterclass.order_items` and `dbz.masterclass.products`, respectively. These table leverage the Flink Kafka connector for upstream data consumption. 

Run the CREATE TABLE statements below to achieve this.

```
CREATE TABLE order_items(
    payload ROW(
        `order_item_id` INT,
        `order_id` INT,
        `product_id` INT,
        `quantity` INT,
        `order_date` TIMESTAMP,
        `price_per_unit` FLOAT,
        `total_price` FLOAT
    )
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbz.masterclass.order_items',
    'properties.bootstrap.servers' = 'redpanda:9092',
    'properties.group.id' = 'mc',
    'properties.auto.offset.reset' = 'earliest',
    'format' = 'json'
);

CREATE TABLE products(
    payload ROW(
        `product_id` INT,
        `product_name` VARCHAR,
        `category` VARCHAR
    )
) WITH (
    'connector' = 'kafka',
    'topic' = 'dbz.masterclass.products',
    'properties.bootstrap.servers' = 'redpanda:9092',
    'properties.group.id' = 'mc',
    'properties.auto.offset.reset' = 'earliest',
    'format' = 'json'
);

```{{copy}}

Remember to hit <Enter> after each statement you copy and paste inside the SQL shell.

You also need to register the third table, `top_selling_products` to sink the results to Postgres via Flink JDBC connector.

```
CREATE TABLE top_selling_products (
    product_id int,
    product_name varchar,
    total_sales float,
    PRIMARY KEY (product_id) not enforced
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/masterclass',
    'table-name' = 'top_selling_products',
    'username' = 'postgresuser',
    'password' = 'postgrespw'
);
```{{copy}}

Run the following to verify the table creation.

```sql
show tables;
```{{copy}}