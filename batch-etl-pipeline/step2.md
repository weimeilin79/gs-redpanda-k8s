Now that all the services are running let's examine the source and target databases to understand the table structures and required transformations.

For simplicity, we've pre-created MySQL and Postgres databases and seeded MySQL tables with mock data.

Login to MySQL and access the source database, `masterclass` by running the following. Provide `mysqlpw` as the password when prompted.

```
docker-compose exec mysql mysql -u mysqluser -p
```{{exec}}

To see the tables, run:

```sql
use masterclass;
show tables;
```{{copy}}

As we progress, we will perform a join on `order_items` and `products` tables. So, take a closer look at their content by running:

```sql
select * from order_items;
select * from products;
```{{copy}}

Exit the console by typing:

```sql
quit;
```

After running the `docker-compose up -d` command in the previous step, the ETL job should run once, populating the Postgres table with results. Let's have a look at it.

```
docker-compose exec postgres psql -U postgresuser -d masterclass
```{{exec}}

Run the following to see our target table, `top_selling_products`, which should have products against their sales.
```sql
select * from top_selling_products;
```{{copy}}

Exit the console by typing:

```sql
quit;
```


