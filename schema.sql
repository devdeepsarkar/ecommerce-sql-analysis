-- Create the database
CREATE DATABASE ecommerce_analysis;
USE ecommerce_analysis;

-- Table 1: Customers
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(10)
);

-- Table 2: Orders
CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(30),
    order_purchase_date DATETIME,
    order_approved_date DATETIME,
    order_delivered_date DATETIME,
    order_estimated_delivery DATETIME,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Table 3: Order Items
CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- Table 4: Products
CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    category_name VARCHAR(100),
    product_weight_g INT,
    product_length_cm INT
);