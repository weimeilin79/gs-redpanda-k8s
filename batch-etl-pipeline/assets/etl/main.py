import pandas as pd
from sqlalchemy import create_engine

# Connection establishment to source and target databases
MYSQL_CONNECTION_STRING = "mysql+mysqlconnector://debezium:dbz@mysql:3306/masterclass" 
PG_CONNECTION_STRING = "postgresql+psycopg2://postgresuser:postgrespw@postgres:5432/masterclass"

mysql_engine = create_engine(MYSQL_CONNECTION_STRING, echo=False)
mysql_connection = mysql_engine.connect()

pg_engine = create_engine(PG_CONNECTION_STRING, echo=True) 
pg_connection = pg_engine.connect()

# Define SQL queries to fetch data from the database
orders_query = "SELECT order_id, product_id, quantity FROM order_items;"
products_query = "SELECT product_id, product_name FROM products;"

# Use Pandas to execute the SQL queries and create DataFrames
orders_df = pd.read_sql_query(orders_query, mysql_connection)
products_df = pd.read_sql_query(products_query, mysql_connection)

# Close the database connection
mysql_connection.close()

# Merge the DataFrames on 'product_id'
merged_df = pd.merge(orders_df, products_df, on='product_id', how='inner')

# Calculate total quantity sold for each product
top_selling_products = merged_df.groupby('product_name')['quantity'].sum().reset_index()

# Sort the DataFrame by total quantity sold in descending order
top_selling_products = top_selling_products.sort_values(by='quantity', ascending=False)

# Write the TSP DataFrame to Postgres
top_selling_products.to_sql('top_selling_products', con=pg_connection, if_exists='replace', index=False)

pg_connection.close()

print("The ETL job completed successfully.")