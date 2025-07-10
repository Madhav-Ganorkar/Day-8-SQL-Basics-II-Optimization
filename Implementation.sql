# 1. Normalize a sample denormalized table into 3NF
  -- Goal: Remove redundancy and split into related tables.
  -- Denormalized Table:

CREATE TABLE orders (
  order_id INT,
  customer_name VARCHAR(100),
  customer_address VARCHAR(200),
  product_name VARCHAR(100),
  product_price DECIMAL(10,2));

#  3NF Normalized Tables:
-- Customer Table products 
CREATE TABLE customers (
  customer_id INT PRIMARY KEY,
  name VARCHAR(100),
  address VARCHAR(200));

-- Product Table
CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100),
  price DECIMAL(10,2));

-- Orders Table (references customer + product)
CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  product_id INT,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id));




# 2. Create and query a Materialized View
  -- Goal: Store result of a query physically (faster reads).
  -- In MySQL, use CREATE TABLE AS to simulate materialized view.

-- Simulated Materialized View: Top 5 selling products
CREATE TABLE top_products AS
SELECT product_id, COUNT(*) AS total_sales
FROM orders
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 5;

-- Query the materialized view
SELECT * FROM top_products;




# 3. Write a Stored Procedure for a common operation
  -- Goal: Automate insert logic using a procedure.

DELIMITER //

CREATE PROCEDURE AddCustomer(
  IN cname VARCHAR(100), 
  IN caddress VARCHAR(200)
)
BEGIN
  INSERT INTO customers(name, address)
  VALUES (cname, caddress);
END //

DELIMITER ;

-- Call the procedure
CALL AddCustomer('Madhav', 'Pune');




# 4. Analyze an EXPLAIN plan and add appropriate indexes
  -- Goal: Understand slow queries and improve with indexes.

-- Slow query
EXPLAIN SELECT * FROM orders WHERE customer_id = 5;

-- Add index to improve
CREATE INDEX idx_customer_id ON orders(customer_id);

-- Recheck
EXPLAIN SELECT * FROM orders WHERE customer_id = 5;
-- You’ll now see type: ref or range instead of ALL → means index is used.



# 5. Partition a large table by RANGE or HASH
  -- Goal: Improve large table performance by splitting it.
  -- RANGE Partitioning on order_date

CREATE TABLE sales (
  id INT,
  order_date DATE,
  amount DECIMAL(10,2))
  
PARTITION BY RANGE (YEAR(order_date)) (
  PARTITION p2022 VALUES LESS THAN (2023),
  PARTITION p2023 VALUES LESS THAN (2024),
  PARTITION pmax  VALUES LESS THAN MAXVALUE);
  
  
 -- HASH Partitioning by id
CREATE TABLE logs (
  id INT, message TEXT)
PARTITION BY HASH(id) PARTITIONS 4;