
If the ETL job completed without errors, you should see the `top_selling_products` table populated in Postgres, which used to be an empty table when we began the scenario.

Run the following to verify that.

```
docker-compose exec postgres psql -U postgresuser -d masterclass
```{{exec}}

```sql
select * from top_selling_products;
```{{exec}}

You should see that the table has been populated already, "Product 4" is having the highest sales volume.

However, those results were calculated from the data that already existed in source tables. Let's insert a record into the `order_items` table and see whether the aggregation result changes.

Open a new tab and run the following. Provide `mysqlpw` when prompted for a password.

```
docker-compose exec mysql mysql -u mysqluser -p
```{{exec}}

Then insert the following record:

```sql
use masterclass;
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price) VALUES (1, 1, 4, 50.00, 200.00);
```{{exec}}

Open another tab and run the ETL job again to see the new results in Postgress.

```
docker-compose run etl
```{{exec}}

Then go back to the first tab where you connected to Postgres and check the contents of the `top_selling_products` table. You should see that `Product 1` has become the latest top-selling product.

