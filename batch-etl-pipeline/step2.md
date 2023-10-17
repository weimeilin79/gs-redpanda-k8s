Now that the source and target databases are running, let's examine their table structures and required transformations.

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

Let's also examine the content of the target database, Postgres, where we will run analytics. Execute the following to log in to `psql` client.

```
docker-compose exec postgres psql -U postgresuser -d masterclass
```{{exec}}

Run the following to see our target table, `top_selling_products`, which is an empty table at the moment.
```sql
select * from top_selling_products;
```{{exec}}

Exit the console by typing:

```sql
quit;
```{{exec}}


