Now, we have finished building our streaming ETL pipeline. Let's verify it.

If the aggregation continues to run without errors, you should see the `top_selling_products` table populated in Postgres, which used to be an empty table when we began the scenario.

Now, switch to the tab where you connected to the Postgres database and run this query.

```sql
select * from top_selling_products;
```{{exec}}

You should see that `Product 4` has got the highest sales.

However, those results were calculated from the data that already existed in source tables. Let's insert a record into the `order_items` table and see whether the aggregation result changes.

Exit the Postgres terminal and run the following. Provide `mysqlpw` when prompted for a password.

```
docker-compose exec mysql mysql -u mysqluser -p
```{{exec}}

Then insert the following record:

```sql
use masterclass;
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price) VALUES (1, 1, 4, 50.00, 200.00);
```{{exec}}


Then check back the Postgres table. You should see that `Product 1` has become the latest top-selling product.

