Now, we have finished building our streaming ETL pipeline. Let's verify it.

If the aggregation continues to run without errors, you should see the `top_selling_products` table populated in Postgres, which used to be an empty table when we began the scenario.

Now, switch to the tab where you connected to the Postgres database and run this query.

```sql
select * from top_selling_products order by total_sales desc;
```{{exec}}

You should see that `Product 4` has got the highest sales.

However, those results were calculated from the data that already existed in source tables. Let's insert a record into the `order_items` table and see whether the aggregation result changes.

Open a separate tab and run the following to connect to MySQL again. Provide `mysqlpw` when prompted for a password.

```
docker-compose exec mysql mysql -u mysqluser -p
```{{exec}}

Then insert the following record:

```sql
use masterclass;
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price) VALUES (1, 1, 4, 50.00, 200.00);
```{{exec}}

Then switch to the Postgres tab and run the same query to see the updated results.

```sql
select * from top_selling_products order by total_sales desc;
```{{exec}}

You should see that `Product 1` has become the latest top-selling product.

```
product_id | product_name | total_sales 
------------+--------------+-------------
          1 | Product 1    |         275
          4 | Product 4    |         100
          2 | Product 2    |          45
          3 | Product 3    |          30
(4 rows)
```

