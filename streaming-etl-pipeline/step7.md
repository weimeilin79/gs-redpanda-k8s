With the source and sink tables, what remains is to write a aggregation query that joins the `order_items` table `products` and aggregate the total.

Execute the following `insert into` query that does the above.

```sql
insert into top_selling_products
select i.payload.product_id as product_id, p.payload.product_name as product_name, sum(i.payload.total_price) as total_sales
from order_items i
inner join products p
on i.product_id=p.product_id
group by i.payload.product_id, p.payload.product_name;
```

Exit the `sql-client` by pressing `Ctrl+C`, followed by typing `quit;`.

When you run this query, the `sql-client` submits it to the `jobmanager`, resulting in a Flink job to be scheduled and run in the Flink cluster.

Apache Flink has a UI that provides an overview of the Flink cluster, enabling you to track the status of jobs and tasks, view cluster logs, and more.

When you started the Flink job manager at the beginning of this tutorial, you also started the UI. It's available at port `8081` by default.

Since this scenario is running on a dynamically provisioned machine, you'll need to get the URL of the Flink UI instance by running this command.

```
sed 's/PORT/8081/g' /etc/killercoda/host
```{{exec}}

Click the link that gets printed to the terminal. The UI will open in a separate tab. If you get a `Bad Gateway` error, wait a few seconds and try again since the service may still be starting.

If the job is healthy and running, you will see a screen like this.