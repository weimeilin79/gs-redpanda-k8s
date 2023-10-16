Now that we understand the source and target database structures, let's look at the ETL job.

We have used Python to implement the ETL job.

The script first connects to MySQL and reads the contents in `order_items` and `products` tables. For that, the script uses the `pandas` and `mysql-connector-python` libraries. 


```python
# Define SQL queries to fetch data from the database
orders_query = "SELECT order_id, product_id, quantity FROM order_items;"
products_query = "SELECT product_id, product_name FROM products;"

# Use Pandas to execute the SQL queries and create DataFrames
orders_df = pd.read_sql_query(orders_query, mysql_connection)
products_df = pd.read_sql_query(products_query, mysql_connection)
```

Then, two data frames are merged to calculate the top selling products.

```python
# Merge the DataFrames on 'product_id'
merged_df = pd.merge(orders_df, products_df, on='product_id', how='inner')

# Calculate total quantity sold for each product
top_selling_products = merged_df.groupby('product_name')['quantity'].sum().reset_index()

# Sort the DataFrame by total quantity sold in descending order
top_selling_products = top_selling_products.sort_values(by='quantity', ascending=False)
```

Finally, the resulting data frame is written to Postgres table, `top_selling_products`, using `sqlalchemy` and `psycopg2` Python libraries.

```python
top_selling_products.to_sql('top_selling_products', con=pg_connection, if_exists='replace', index=False)
```

The above script has been containerized and it uses the following `Dockerfile` to satisfy its dependencies.

```
FROM python:3.9

ADD main.py .

RUN pip install mysql-connector-python sqlalchemy pandas psycopg2

ENTRYPOINT ["python", "./main.py"]
```

When you executed the command, `docker-compose up -d` in the Step 1, the ETL container has been built and ran once.

If the it executed successfully, you should see the container `etl` with the exit status 0 as follows.

```
docker-compose ps
```
