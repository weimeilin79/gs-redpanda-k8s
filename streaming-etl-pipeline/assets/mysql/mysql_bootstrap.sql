CREATE DATABASE IF NOT EXISTS masterclass;
USE masterclass;

GRANT ALL PRIVILEGES ON masterclass.* TO 'mysqluser';
GRANT FILE on *.* to 'mysqluser';

CREATE USER 'debezium' IDENTIFIED WITH mysql_native_password BY 'dbz';

GRANT SELECT, RELOAD, SHOW DATABASES, REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'debezium';

FLUSH PRIVILEGES;

-- Create the orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    total FLOAT,
    created_at DATETIME DEFAULT NOW()
);

-- Create the order_items table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit float,
    total_price FLOAT 
);

-- Create the products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255),
    category VARCHAR(255)
);

-- Populate the 'products' table
INSERT INTO products (product_name, category) VALUES
    ('Product 1', 'Category A'),
    ('Product 2', 'Category B'),
    ('Product 3', 'Category A'),
    ('Product 4', 'Category C');

-- Populate the 'orders' table
INSERT INTO orders (customer_id, total) VALUES
    (1, 100.50),
    (2, 75.25),
    (1, 50.75),
    (3, 120.00);

-- Populate the 'order_items' table
INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price) VALUES
    (1, 1, 2, 25.00, 50.00),
    (1, 3, 1, 30.00, 30.00),
    (2, 2, 3, 15.00, 45.00),
    (3, 1, 1, 25.00, 25.00),
    (4, 4, 2, 50.00, 100.00);

-- INSERT INTO order_items (order_id, product_id, quantity, price_per_unit, total_price) VALUES (1, 1, 4, 50.00, 200.00);