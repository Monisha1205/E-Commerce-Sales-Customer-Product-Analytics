-- 1. Creating database 
CREATE DATABASE olist_ecommerce;

-- Work in the new created database
USE olist_ecommerce;

-- verify the database
SELECT DATABASE();				

-- 2. Creating the tables 
-- Table : 1 Customers
CREATE TABLE customers (
customer_id VARCHAR(50) PRIMARY KEY,
customer_unique_id VARCHAR(50),
customer_zip_code_prefix INT,
customer_city VARCHAR(100),
customer_state VARCHAR(10)
);

-- Table : 2 Orders
CREATE TABLE orders (
order_id VARCHAR(50) PRIMARY KEY,
customer_id VARCHAR(50),
order_status VARCHAR(30),
order_purchase_timestamp DATETIME,
order_approved_at DATETIME,
order_delivered_carrier_date DATETIME,
order_delivered_customer_date DATETIME,
order_estimated_delivery_date DATETIME,
FOREIGN KEY (customer_id) REFERENCES customers(customer_id));

-- Table : 3 Order_items
CREATE TABLE order_items(
order_id VARCHAR(50), 
order_item_id INT, 
product_id VARCHAR(50),
seller_id VARCHAR(50),
shipping_limit_date DATETIME,
price DECIMAL(10,2),
freight_value DECIMAL(10,2),
PRIMARY KEY (order_id, order_item_id));

-- Table : 4 Products
CREATE TABLE products(
product_id VARCHAR(50) PRIMARY KEY,
product_category_name VARCHAR(100),
product_name_length INT,
product_description_length INT,
product_photos_qty INT,
product_weight_g INT,
product_length_cm INT,
product_height_cm INT, 
product_weight_cm INT);

-- Table : 5 Sellers

CREATE TABLE sellers (
sellers_id VARCHAR(50) PRIMARY KEY,
sellers_zip_code_prefix INT,
sellers_city VARCHAR(100),
sellers_state VARCHAR(10)
);

-- Table : 6 Payments
CREATE TABLE order_payments(
order_id VARCHAR(50),
payment_sequential INT,
payment_type VARCHAR(30),
payment_installments INT,
payment_value DECIMAL(10,2));

-- Table : 7 Reviews

CREATE TABLE order_reviews(
review_id VARCHAR(50), 
order_id VARCHAR(50), 
review_score INT, 
review_comment_title TEXT,
review_comment_message TEXT,
review_creation_date DATETIME,
review_answer_timestamp DATETIME);

-- Table : 8 Geolocation
CREATE TABLE geolocation(
geolocation_zip_code_prefix INT,
geolocation_lat DECIMAL(10,7),
geolocation_lng DECIMAL(10,7),
geolocation_city VARCHAR(100), 
geolocation_state VARCHAR(10)
);

-- Table : 9 Category Translation
CREATE TABLE category_translation(
product_category_name VARCHAR(100),
product_category_name_english VARCHAR(100)
);

-- Checking all tables created
SHOW TABLES;

-- Truncate the table if foreign key is present
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE order_items;
TRUNCATE TABLE order_payments;
TRUNCATE TABLE order_reviews;
TRUNCATE TABLE orders;
TRUNCATE TABLE customers;
TRUNCATE TABLE products;
TRUNCATE TABLE sellers;
TRUNCATE TABLE geolocation;
TRUNCATE TABLE category_translation;

SET FOREIGN_KEY_CHECKS = 1;


-- importing the data if it has more then 1000 rows

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_geolocation_dataset.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_order_items_dataset.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_order_payments_dataset.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_order_reviews_dataset.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SHOW WARNINGS;

SELECT count(*) FROM order_reviews;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_products_dataset.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT count(*) FROM products;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/product_category_name_translation.csv'
INTO TABLE category_translation
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT count(*) FROM category_translation;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_orders_dataset.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT count(*) FROM orders;
SELECT count(*) FROM sellers;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_sellers_dataset.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE 'C:/Users/ELCOT/Downloads/MY SQL files/All sql files/Brazilian E-Commerce Public Dataset by Olist/olist_customers_dataset.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Validate data and table structures;

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_orders FROM orders;

SELECT COUNT(*) AS total_order_items FROM order_items;

SELECT COUNT(*) AS total_payments FROM order_payments;

SELECT COUNT(*) AS total_reviews FROM order_reviews;

SELECT COUNT(*) AS total_products FROM products;

SELECT COUNT(*) AS total_sellers FROM sellers;

SELECT COUNT(*) AS total_geolocation FROM geolocation;

SELECT COUNT(*) AS total_categories FROM category_translation;

-- Check the table columns
DESCRIBE customers;
DESCRIBE orders;
DESCRIBE order_items;
DESCRIBE order_payments;
DESCRIBE order_reviews;
DESCRIBE products;
DESCRIBE sellers;
DESCRIBE geolocation;
DESCRIBE category_translation;

-- * checking missing values of customers tables_3.

SELECT
    COUNT(*) AS total_customers,
    SUM(customer_unique_id IS NULL) AS missing_unique_id,
    SUM(customer_zip_code_prefix IS NULL) AS missing_zip_code,
    SUM(customer_city IS NULL) AS missing_city,
    SUM(customer_state IS NULL) AS missing_state
FROM customers;


--  * Check duplicate customer records
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- * find unique customers purchased muiltple times

SELECT
    COUNT(*) AS customer_records,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

-- some customers appear in multiple records. This is why 99,441 customer records correspond to 96,096 unique customers.
-- This means your primary key is unique, as expected. The difference between customer records and unique customers is not a duplicate customer_id issue.

-- * checking missing values of orders tables_2 .

SELECT 
count(*) AS TOTAL_ORDERS,
SUM(customer_id IS NULL) AS missing_customer_id,
SUM(order_status IS NULL) AS missing_order_status,
SUM(order_purchase_timestamp IS NULL) AS missing_purchase_timestamp,
SUM(order_delivered_customer_date IS NULL) AS missing_delivered_date
FROM orders;

-- * Check total orders and order status.

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT order_id) AS unique_orders
FROM orders;

-- * Understand order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- * Check delivery performance
SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        order_delivered_customer_date >
        order_estimated_delivery_date
    ) AS late_deliveries
FROM orders
WHERE order_status = 'delivered';

-- * Check the order_items data quality.

SELECT
    COUNT(*) AS total_items,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(shipping_limit_date IS NULL) AS missing_shipping_date,
    SUM(price IS NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight
FROM order_items;

SELECT
    order_id,
    order_item_id,
    COUNT(*) AS duplicate_count
FROM order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_items
FROM order_items;

SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        order_delivered_customer_date >
        order_estimated_delivery_date
    ) AS late_deliveries
FROM orders
WHERE order_status = 'delivered';

SELECT
    COUNT(*) AS delivered_orders,
    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_deliveries
FROM orders
WHERE order_status = 'delivered';


SELECT COUNT(*) AS total_reviews
FROM order_reviews;

SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

-- * 1. First check all table relationships.

-- Orders → Customers

SELECT COUNT(*) AS unmatched_orders
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Order Items → Orders

SELECT COUNT(*) AS unmatched_order_items
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Order Items → Products

SELECT COUNT(*) AS unmatched_products
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Order Items → Sellers

SELECT COUNT(*) AS unmatched_sellers
FROM order_items oi
LEFT JOIN sellers s
ON oi.seller_id = s.sellers_id
WHERE s.sellers_id IS NULL;

-- Payments → Orders

SELECT COUNT(*) AS unmatched_payments
FROM order_payments op
LEFT JOIN orders o
ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Reviews → Orders

SELECT COUNT(*) AS unmatched_reviews
FROM order_reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


-- 2. Check important NULL values.

-- Products

SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height
FROM products;

-- Payments

SELECT
    COUNT(*) AS total_payments,
    SUM(payment_type IS NULL) AS missing_payment_type,
    SUM(payment_value IS NULL) AS missing_payment_value,
    SUM(payment_installments IS NULL) AS missing_installments
FROM order_payments;

-- Reviews

SELECT
    COUNT(*) AS total_reviews,
    SUM(review_score IS NULL) AS missing_score,
    SUM(review_creation_date IS NULL) AS missing_creation_date
FROM order_reviews;

-- Sellers

SELECT
    COUNT(*) AS total_sellers,
    SUM(sellers_zip_code_prefix IS NULL) AS missing_zip,
    SUM(sellers_city IS NULL) AS missing_city,
    SUM(sellers_state IS NULL) AS missing_state
FROM sellers;

-- 3. Check duplicate records

-- Products

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Sellers

SELECT
    sellers_id,
    COUNT(*) AS duplicate_count
FROM sellers
GROUP BY sellers_id
HAVING COUNT(*) > 1;

-- Payments
-- Payments can legitimately have multiple rows per order.

SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS duplicate_count
FROM order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- 4. Check review scores

SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;

SELECT *
FROM order_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

SELECT COUNT(*) AS total_reviews
FROM order_reviews;

SELECT
    review_id,
    COUNT(*) AS duplicate_count
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews
WHERE review_id = 'c444278834184f72b1484dfe47de7f97';

SELECT order_id, review_id, review_score,
       review_creation_date, review_answer_timestamp,
       COUNT(*) AS duplicate_count
FROM order_reviews
GROUP BY order_id, review_id, review_score,
         review_creation_date, review_answer_timestamp
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_rows
FROM order_reviews;

SELECT
    order_id,
    review_id,
    review_score,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS duplicate_count
FROM order_reviews
GROUP BY
    order_id,
    review_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1;

SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT *
FROM order_reviews
WHERE review_id IN (
    SELECT review_id
    FROM (
        SELECT review_id
        FROM order_reviews
        GROUP BY review_id
        HAVING COUNT(*) > 1
    ) AS duplicates
)
ORDER BY review_id, order_id;

SELECT *
FROM order_reviews
WHERE order_id = 'c444278834184f72b1484dfe47de7f97'
ORDER BY review_id;

-- Total rows
SELECT COUNT(*) AS total_rows
FROM order_reviews;

-- Unique review IDs
SELECT COUNT(DISTINCT review_id) AS unique_review_ids
FROM order_reviews;

-- Unique orders with reviews
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM order_reviews;

SELECT
    review_id,
    COUNT(*) AS occurrences
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

SELECT *
FROM order_reviews
WHERE review_id = 'c444278834184f72b1484dfe47de7f97';

SELECT
    COUNT(*) AS repeated_review_id_groups,
    SUM(occurrences) AS rows_with_repeated_ids,
    SUM(occurrences - 1) AS extra_occurrences
FROM (
    SELECT review_id, COUNT(*) AS occurrences
    FROM order_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS repeated;

SHOW COLUMNS FROM order_reviews;

SELECT *
FROM order_reviews
WHERE order_id = 'c444278834184f72b1484dfe47de7f97';

SELECT *
FROM order_reviews
WHERE review_id = '8ARNMqo7uXgU5NTweEmWn46Hvewjcp1PtqfXTKDZTj29'
   OR order_id = '8ARNMqo7uXgU5NTweEmWn46Hvewjcp1PtqfXTKDZTj29';
   
   SELECT
    review_id,
    order_id,
    review_score,
    review_creation_date,
    review_answer_timestamp
FROM order_reviews
WHERE review_id = 'c444278834184f72b1484dfe47de7f97'
   OR order_id = 'c444278834184f72b1484dfe47de7f97';
   
   
   SELECT
    review_id,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS different_orders
FROM order_reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY total_rows DESC;

SELECT
    COUNT(*) AS total_rows,
    SUM(review_id IS NULL OR TRIM(review_id) = '') AS missing_review_ids,
    SUM(order_id IS NULL OR TRIM(order_id) = '') AS missing_order_ids,
    SUM(review_score IS NULL) AS missing_review_scores,
    SUM(review_creation_date IS NULL) AS missing_creation_dates,
    SUM(review_answer_timestamp IS NULL) AS missing_answer_timestamps
FROM order_reviews;


SELECT review_score, COUNT(*) AS total_reviews
FROM order_reviews
GROUP BY review_score
ORDER BY review_score;


-- 5. Check product prices

SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    AVG(price) AS average_price
FROM order_items;

SELECT *
FROM order_items
WHERE price <= 0;

SELECT
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight,
    AVG(freight_value) AS average_freight
FROM order_items;

-- 5. Check dates

SELECT COUNT(*) AS invalid_delivery_dates
FROM orders
WHERE order_delivered_customer_date < order_purchase_timestamp;

SELECT COUNT(*) AS invalid_estimated_dates
FROM orders
WHERE order_estimated_delivery_date < order_purchase_timestamp;

SELECT COUNT(*) AS invalid_approval_dates
FROM orders
WHERE order_approved_at < order_purchase_timestamp;

SELECT
    order_id,
    order_purchase_timestamp,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date
      < order_purchase_timestamp;
      
SELECT COUNT(*) AS invalid_approval_delivery
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_approved_at;
  
SELECT COUNT(*) AS invalid_carrier_delivery
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;
  
SELECT COUNT(*) AS invalid_carrier_delivery
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;
  
SELECT COUNT(*) AS invalid_shipping_dates
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;
	
-- Check payment values
SELECT
    MIN(payment_value) AS min_payment,
    MAX(payment_value) AS max_payment,
    AVG(payment_value) AS avg_payment
FROM order_payments;

SELECT *
FROM order_payments
WHERE payment_value <= 0;

SELECT
    MIN(payment_installments) AS min_installments,
    MAX(payment_installments) AS max_installments
FROM order_payments;

-- Check product dimensions
DESCRIBE products;

-- Check categorical values
SELECT
    payment_type,
    COUNT(*) AS total
FROM order_payments
GROUP BY payment_type
ORDER BY total DESC;

SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_state
ORDER BY total_customers DESC;

SELECT
    sellers_state,
    COUNT(*) AS total_sellers
FROM sellers
GROUP BY sellers_state
ORDER BY total_sellers DESC;


-- 6. Data cleaning
-- a. Fix the product column name
DESCRIBE products;

ALTER TABLE products
RENAME COLUMN product_weight_cm TO product_width_cm;

-- b. Handle NULL values

SELECT
    p.product_id,
    COALESCE(r.total_reviews, 0) AS total_reviews
FROM products p
LEFT JOIN (
    SELECT
        product_id,
        COUNT(*) AS total_reviews
    FROM order_items oi
    JOIN order_reviews r
        ON oi.order_id = r.order_id
    GROUP BY product_id
) r
    ON p.product_id = r.product_id;
    
    SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_weight_g IS NULL) AS missing_weight,
    SUM(product_length_cm IS NULL) AS missing_length,
    SUM(product_height_cm IS NULL) AS missing_height
FROM products;

SELECT *
FROM products
WHERE product_weight_g <= 0
   OR product_length_cm <= 0
   OR product_height_cm <= 0
   OR product_width_cm <= 0;
   
   
   SELECT
    COUNT(*) AS total_invalid_products,
    SUM(product_weight_g = 0) AS zero_weight,
    SUM(product_length_cm = 0) AS zero_length,
    SUM(product_height_cm = 0) AS zero_height,
    SUM(product_width_cm = 0) AS zero_width
FROM products
WHERE product_weight_g = 0
   OR product_length_cm = 0
   OR product_height_cm = 0
   OR product_width_cm = 0;


SELECT *
FROM order_items
WHERE price <= 0
   OR freight_value < 0;
   
-- payment values.
SELECT *
FROM order_payments
WHERE payment_value <= 0
   OR payment_installments <= 0;
   
   
SELECT
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    o.order_status
FROM order_payments p
LEFT JOIN orders o
    ON p.order_id = o.order_id
WHERE p.payment_value <= 0
   OR p.payment_installments <= 0
ORDER BY p.order_id, p.payment_sequential;

SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM order_payments
WHERE order_id IN (
    '45ed6e85398a87c253db47c2d9f48216',
    '6ccb433e00daae1283ccc956189c82ae',
    '8bcbe01d44d147f901cd3192671144db',
    'b23878b3e8eb4d25a158f57d96331b18',
    'fa65dad1b0e818e3ccc5cb0e39231352'
)
ORDER BY order_id, payment_sequential;


SELECT
    order_id,
    COUNT(*) AS payment_records,
    SUM(payment_value) AS total_payment_value,
    SUM(payment_value = 0) AS zero_value_records,
    SUM(payment_installments = 0) AS zero_installment_records
FROM order_payments
GROUP BY order_id
HAVING SUM(payment_value = 0) > 0
    OR SUM(payment_installments = 0) > 0
ORDER BY order_id;


SELECT
    payment_type,
    COUNT(*) AS total_records,
    SUM(payment_value = 0) AS zero_value_records,
    SUM(payment_installments = 0) AS zero_installment_records,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY payment_type
ORDER BY total_records DESC;


-- Credit cards account for the largest number of payment records and the highest total payment value.
-- Six voucher records have a payment value of zero, but these appear alongside other positive payment entries.
-- All three not_defined records have a zero payment value.
-- Two credit-card records have zero installments and need to be documented as data-quality observations.

-- My recommendation: Preserve the original tables and perform any justified corrections in separate cleaned tables or views. That way, your analysis is reproducible and you can explain every decision in an interview.

-- * Validate order dates.

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at
FROM orders
WHERE order_approved_at < order_purchase_timestamp;

-- Count zero-date approval records

SELECT
    COUNT(*) AS total_orders,
    SUM(CAST(order_approved_at AS CHAR) LIKE '0000-00-00%')
        AS zero_approval_dates,
    SUM(order_approved_at IS NULL)
        AS null_approval_dates
FROM orders;

-- Check the order status of these 160 orders
SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
WHERE CAST(order_approved_at AS CHAR) LIKE '0000-00-00%'
GROUP BY order_status
ORDER BY order_count DESC;

-- Inspect the 14 delivered orders
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE CAST(order_approved_at AS CHAR) LIKE '0000-00-00%'
  AND order_status = 'delivered';
  
  
-- These 14 orders have a clear data-quality issue: they are marked delivered and have valid delivery timestamps, but their approval timestamps are zero dates.
-- For example, order c1d4211b3dae76144deccd6c74144a88 was purchased on January 19, handed to the carrier on January 25, and delivered on January 30, 2017, but its approval date is missing.

-- * Check purchase and approval timestamp order

SELECT
    COUNT(*) AS invalid_approval_order_count
FROM orders
WHERE CAST(order_approved_at AS CHAR) NOT LIKE '0000-00-00%'
  AND order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;


/* Validation summary so far
 Check	Result	Status
Total orders	99,441	Verified
Zero approval dates	160	Issue identified
NULL approval dates	0	No NULLs found
Valid approval before purchase	0	Passed
Delivered orders with zero approval dates	14	Needs documentation
*/

-- Check delivery dates before purchase dates

SELECT
    COUNT(*) AS invalid_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_delivered_customer_date < order_purchase_timestamp;
  
  /* 
  The result is 0 invalid delivery dates. That means no valid customer delivery timestamps occur before the purchase timestamps in this check.
Updated order timestamp validation
Validation	Result	Status
Total orders	99,441	Verified
Zero approval dates	160	Issue identified
NULL approval dates	0	Passed
Approval before purchase	0	Passed
Customer delivery before purchase	0	Passed
*/

-- Check whether the carrier received orders before they were purchased

SELECT
    COUNT(*) AS invalid_carrier_dates
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND CAST(order_delivered_carrier_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_delivered_carrier_date < order_purchase_timestamp;
  
  -- We found 166 orders where the carrier delivery timestamp is earlier than the purchase timestamp. This is a potential data-quality issue, so let's inspect the records before deciding how to handle them.
  
  -- View the 166 affected orders
  
  SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND CAST(order_delivered_carrier_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_delivered_carrier_date < order_purchase_timestamp
ORDER BY order_purchase_timestamp;


/*
You did the right thing by checking the actual records. 😊 Looking at your results, we can see that the 166 orders need a closer look, but not all of them are necessarily serious errors.
For example:
- Order fd58bdbb6cc5d7519e063c3ceb7e951b: purchased at 13:02:26, approved at 13:15:26, but the carrier timestamp is 12:36:00 — about 26 minutes before purchase.
- Order 7c48bb55e8e4f7e56d412e9653db37bc: purchased on July 16, 2018, but the carrier timestamp is January 26, 2018 — a much larger discrepancy.
The second example is a stronger candidate for a data-quality error. We should quantify the discrepancies before deciding how to handle them.
*/

-- Group the 166 orders by status

SELECT
    order_status,
    COUNT(*) AS affected_orders
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND CAST(order_delivered_carrier_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_delivered_carrier_date < order_purchase_timestamp
GROUP BY order_status
ORDER BY affected_orders DESC;

/*
These 166 records have a date inconsistency: the carrier delivery timestamp is earlier than the purchase timestamp. Most are delivered orders, so the dates may reflect source-data inconsistencies or timestamp issues.
*/
			

-- Check the zero dates in carrier timestamps

SELECT
    COUNT(*) AS total_orders,
    SUM(
        CAST(order_delivered_carrier_date AS CHAR)
        LIKE '0000-00-00%'
    ) AS zero_carrier_dates,
    SUM(order_delivered_carrier_date IS NULL)
        AS null_carrier_dates
FROM orders;

/* 
Validation	Count
Total orders	99,441
Zero carrier delivery dates	1,783
NULL carrier delivery dates	0
*/

/*
The order_delivered_carrier_date column contains 1,783 zero dates (0000-00-00 00:00:00), rather than actual delivery timestamps or NULL values.
This doesn't automatically mean the data is wrong. Some orders may not have reached the carrier yet, while others may have missing timestamps. We'll check the order statuses before deciding how to document them.
*/

SELECT
    order_status,
    COUNT(*) AS zero_carrier_date_count
FROM orders
WHERE CAST(order_delivered_carrier_date AS CHAR)
      LIKE '0000-00-00%'
GROUP BY order_status
ORDER BY zero_carrier_date_count DESC;

/* Most zero dates are associated with orders that were canceled, unavailable, or not yet shipped. The two delivered orders are unusual because delivered orders would normally have a carrier timestamp. We'll flag them rather than changing the data.*/

-- Inspect the two delivered orders
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
WHERE order_status = 'delivered'
  AND CAST(order_delivered_carrier_date AS CHAR)
      LIKE '0000-00-00%';
      
      
-- Conclusion: Both records are inconsistent with their delivered status. Keep them in the original dataset and document them as data-quality exceptions. Don't fill in missing dates using estimates.


-- Validate estimated delivery dates

SELECT
    COUNT(*) AS late_delivered_orders
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_estimated_delivery_date IS NOT NULL
  AND CAST(order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_delivered_customer_date > order_estimated_delivery_date;
  
  /*
  Record your validation result
Check	Result	Interpretation
Late-delivered orders	7,826	Delivered after the estimated date
Delivered orders with zero carrier date	2	Data-quality exceptions
Delivered orders with zero customer delivery date	1 identified so far	Missing delivery timestamp
*/

-- Check customer delivery dates that are zero

SELECT
    order_status,
    COUNT(*) AS zero_customer_delivery_dates
FROM orders
WHERE CAST(order_delivered_customer_date AS CHAR)
      LIKE '0000-00-00%'
GROUP BY order_status
ORDER BY zero_customer_delivery_dates DESC;

/*
We found 2,965 orders with zero customer delivery dates. Let's understand the status breakdown.
Order status	Zero customer delivery dates	Interpretation
Shipped	1,107	Usually expected; delivery may not be completed
Canceled	619	Generally expected
Unavailable	609	Generally expected
Invoiced	314	Likely not yet delivered
Processing	301	Likely not yet delivered
Delivered	8	Needs investigation
Created	5	Likely not yet progressed
Approved	2	Likely awaiting further processing
Total	2,965	
The eight orders marked delivered are the main exceptions. We should inspect them, but keep the original data unchanged.
*/

-- Inspect the eight delivered orders

SELECT
    order_id,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM orders
WHERE order_status = 'delivered'
  AND CAST(order_delivered_customer_date AS CHAR)
      LIKE '0000-00-00%';
      

/*
inding	Number of orders
Delivered orders with zero customer delivery date	8
Of these, with a valid carrier timestamp	7
With both carrier and customer delivery dates missing	1
*/

/*
The seven orders have valid carrier timestamps, but their customer delivery timestamps are missing. The remaining order, 2d858f451373b04fb5c984a1cc2defaf, has both timestamps missing.
Conclusion: These eight records are data-quality exceptions. We cannot determine the actual delivery dates from the available fields, so keep them unchanged and document them.
*/

-- Check estimated delivery dates

SELECT
    COUNT(*) AS invalid_estimated_delivery_dates
FROM orders
WHERE order_estimated_delivery_date IS NOT NULL
  AND CAST(order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND order_estimated_delivery_date < order_purchase_timestamp;
  
  
  /*
  his means every non-zero estimated delivery date checked is on or after the order's purchase timestamp. That's a good validation result.
Orders table — validation summary so far
Validation check	Result	Status
Total orders	99,441	Verified
Zero approval dates	160	Flagged
Approval date before purchase	0	Passed
Customer delivery date before purchase	0	Passed
Carrier date before purchase	166	Flagged
Zero carrier dates	1,783	Flagged
Zero customer delivery dates	2,965	Flagged
Late-delivered orders	7,826	Business finding
Estimated delivery before purchase	0	Passed
Note: Some missing or zero timestamps are expected for orders that haven't been delivered or were canceled.
*/

-- Check for duplicate order IDs

SELECT
    order_id,
    COUNT(*) AS id_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- An empty result means there are no duplicate order_id values in your orders table. Each order ID is unique, as expected.

-- Check for missing order IDs

SELECT
    SUM(order_id IS NULL) AS null_order_ids,
    SUM(TRIM(order_id) = '') AS blank_order_ids
FROM orders;

/*
Validation	Result	Status
NULL order IDs	0	Passed
Blank order IDs	0	Passed
Duplicate order IDs	0	Passed
*/

-- Check missing customer IDs

SELECT
    SUM(customer_id IS NULL) AS null_customer_ids,
    SUM(TRIM(customer_id) = '') AS blank_customer_ids
FROM orders;

-- no NULL customer IDs in your orders

-- Check whether every order's customer exists in the customers table

SELECT COUNT(*) AS unmatched_customer_orders
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Validate the order status values

SELECT
    order_status,
    COUNT(*) AS order_count
FROM orders
GROUP BY order_status
ORDER BY order_count DESC;


/* 
Order status validation results
Order status	Orders	Interpretation
Delivered	96,478	Completed orders
Shipped	1,107	In transit or awaiting delivery confirmation
Canceled	625	Canceled orders
Unavailable	609	Orders marked unavailable
Invoiced	314	Invoiced orders
Processing	301	Orders being processed
Created	5	Newly created orders
Approved	2	Approved orders
Total	99,441	Matches total orders
All eight status values are consistent with the expected Olist order-status categories. No obvious misspelled or unexpected status appears.
*/

-- Where we are: We've validated order IDs, customer relationships, order statuses, and several timestamp issues. We also identified 7,826 late-delivered orders and documented missing or inconsistent timestamps.

-- Business Analysis — Step 1: Overall KPIs

/*
First, calculate the basic business KPIs:
- Total orders
- Total customers
- Total sellers
- Total products
- Total revenue
- Average Order Value (AOV)
*/

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(DISTINCT oi.seller_id) AS total_sellers,
    COUNT(DISTINCT oi.product_id) AS total_products,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id;


/*
KPI	Result
Total Orders with Items	98,666
Customers with Orders	98,666
Sellers	3,095
Products	32,951
Total Product Revenue	13,591,643.70
Average Order Value	137.75


Important observation
You have 99,441 orders in the orders table, but only 98,666 orders appear in order_items.
That's a difference of:
99,441 − 98,666 = 775 orders
This is worth documenting because your revenue calculation naturally includes only orders that have order-item records.
Also, total_customers = 98,666 here means customers associated with orders that have order items, not necessarily all unique customers in the customers table.
*/


-- step - 2 Monthly Revenue Trend
-- how revenue changed month by month.

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;



/*
Key findings
- Highest revenue month: November 2017 — 1,010,271.37
- Highest number of orders: November 2017 — 7,451
- Revenue grew strongly through 2017 and remained high throughout 2018.
- The very small values in Sep 2016, Dec 2016, and Sep 2018 are genuine dataset periods with very few orders, so don't remove them.
- Your analysis period effectively runs from September 2016 to September 2018.

*/


-- Step 3 — Top 10 product categories by revenue

-- which product categories generate the most revenue.

SELECT
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.order_item_id) AS total_items
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY COALESCE(ct.product_category_name_english,
                  p.product_category_name)
ORDER BY total_revenue DESC
LIMIT 10;

-- Health & Beauty is the top revenue-generating category, followed closely by Watches & Gifts.
-- An interesting point is Bed, Bath & Table: it has the highest number of orders among these top 10, but Health & Beauty generates more revenue. This suggests that order volume and revenue aren't necessarily the same.


-- Step 4 — Top 10 individual products by revenue

-- find the specific products generating the most revenue.

SELECT
    oi.product_id,
    COALESCE(ct.product_category_name_english,
             p.product_category_name) AS category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.order_item_id) AS total_items,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY
    oi.product_id,
    COALESCE(ct.product_category_name_english,
             p.product_category_name)
ORDER BY total_revenue DESC
LIMIT 10;

/*
Interesting insight
The top-revenue product generated 63,885, despite having only 187 orders. Meanwhile, some products have substantially more orders but lower revenue.
This is useful for your report because it shows:
High order volume does not necessarily mean high revenue.

Also, notice the computers product with only 35 orders generating 48,899.34. That's a particularly high-value product.
*/

-- Step 5 — Top 10 customers by spending

SELECT
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_spending
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.customer_id
ORDER BY total_spending DESC
LIMIT 10;

/*
Business insight
The highest-spending customer spent 13,440.00 in a single order. All 10 customers have one order in this result, which suggests these high spenders made high-value purchases rather than placing many orders.
Important distinction: This query groups by customer_id, which identifies an order-specific customer record in the Olist dataset. For repeat-customer analysis, use customer_unique_id from the customers table instead.

*/

-- Step 6 — Revenue by payment type

SELECT
    op.payment_type,
    COUNT(DISTINCT op.order_id) AS total_orders,
    ROUND(SUM(op.payment_value), 2) AS total_payment_value,
    ROUND(AVG(op.payment_value), 2) AS avg_payment_record_value
FROM order_payments op
GROUP BY op.payment_type
ORDER BY total_payment_value DESC;

/*

Business insights
- Credit cards dominate: They account for approximately 78% of the total recorded payment value across all payment types.
- Boleto is second: It contributes approximately 18% of recorded payment value.
- Voucher payments have the lowest average payment-record value: 65.70.
- Three not_defined records have zero payment value: These match the zero-value records you identified during data validation.

*/

-- Step 7 — Order status and revenue

SELECT
    o.order_status,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COALESCE(SUM(oi.price), 0), 2) AS total_product_revenue
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_status
ORDER BY total_product_revenue DESC; 

/*
Key business insights
- Delivered orders dominate: 96,478 orders, approximately 97% of all orders.
- Delivered product revenue: R$13.22 million, representing the majority of product sales in the dataset.
- Canceled orders have product value: R$95,235.27 is associated with canceled orders. This is item-price value, not necessarily lost or refunded revenue.
- Shipped orders: R$150,727.44 is associated with orders that had not reached the delivered status.
- Unavailable orders: Although there are 609 unavailable orders, their associated product value is only R$2,007.69.

*/


-- Step 8: Analyze repeat customers

SELECT
    customer_order_count,
    COUNT(*) AS total_customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS customer_order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS customer_summary
GROUP BY customer_order_count
ORDER BY customer_order_count;

/*
Total unique customers in this analysis
96,096

One-time customers
96.88%

Repeat customers
3.12%



Business insights
- Most customers purchased only once: 93,099 customers placed a single order.
- Repeat purchasing is relatively low: 2,997 customers placed two or more orders.
- Opportunity for customer retention: The business could explore loyalty rewards, personalized recommendations, and follow-up campaigns to encourage repeat purchases.
- One customer placed 17 orders, which could be examined as a high-frequency purchasing pattern.
These percentages are based on the customers represented in your customers and orders tables; they don't establish why customers did or didn't return.

*/

-- Step 9: Analyze delivery performance

SELECT
    ROUND(AVG(
        DATEDIFF(
            order_delivered_customer_date,
            order_purchase_timestamp
        )
    ), 2) AS avg_delivery_days,

    ROUND(AVG(
        DATEDIFF(
            order_estimated_delivery_date,
            order_purchase_timestamp
        )
    ), 2) AS avg_estimated_days,

    SUM(
        CASE
            WHEN order_delivered_customer_date >
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    SUM(
        CASE
            WHEN order_delivered_customer_date <=
                 order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_or_early_orders

FROM orders
WHERE order_status = 'delivered'
  AND CAST(order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%';
      
      
/*
Average actual delivery
12.50 days


Average estimated delivery
24.37 days


Late deliveries
7,826
8.11% of valid delivered orders


On-time or early deliveries
88,644
91.89% of valid delivered orders



Business insights
- Delivery performance is generally strong: Approximately 91.89% of the included delivered orders arrived on or before their estimated dates.
- Actual delivery was faster than the estimate: Average delivery took 12.50 days, compared with an estimated 24.37 days from purchase to delivery.
- Late deliveries need attention: 7,826 orders arrived after the estimated date. Investigating the sellers, product categories, and customer locations associated with these orders could help identify causes.
The difference between average estimated and actual delivery is about 11.87 days. This compares two averages; it does not mean every order arrived 11.87 days early.

*/

-- Step 10: Analyze customer review scores

SELECT
    CASE
        WHEN o.order_delivered_customer_date >
             o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time or Early'
    END AS delivery_performance,

    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    SUM(CASE WHEN r.review_score = 1 THEN 1 ELSE 0 END)
        AS one_star_reviews,
    SUM(CASE WHEN r.review_score = 5 THEN 1 ELSE 0 END)
        AS five_star_reviews

FROM orders o
JOIN order_reviews r
    ON o.order_id = r.order_id

WHERE o.order_status = 'delivered'
  AND CAST(o.order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND CAST(o.order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%'

GROUP BY delivery_performance;

/*

Late deliveries
2.57 / 5
Average review score

1-star reviews: 3,554
5-star reviews: 1,711


On-time or early
4.29 / 5
Average review score

1-star reviews: 5,851
5-star reviews: 55,347



Key business insights
- Late deliveries are associated with lower satisfaction. The average review score is 2.57 for late deliveries versus 4.29 for on-time or early deliveries.
- The gap is 1.72 points on a five-point review scale.
- One-star reviews are much more common among late-delivery orders. About 46.4% of late-delivery orders in your result have a one-star review, compared with about 6.6% of on-time or early orders.
- Five-star reviews are more common for on-time or early orders. About 62.8% of those orders have a five-star review, compared with about 22.3% of late orders.
These percentages use the order counts in your query as denominators. Since an order can have multiple review records, they are approximate order-level comparisons, not necessarily percentages of all individual reviews.
Business recommendation: Investigate late deliveries by seller, destination state, and product category. Improving delivery reliability may help improve customer satisfaction, although this analysis shows an association rather than proving causation.

*/


-- Revenue by customer state

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Top sellers by revenue

SELECT
    oi.seller_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS total_items,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price
FROM order_items oi
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;


-- Seller delivery performance

SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS total_orders,

    SUM(
        CASE
            WHEN o.order_delivered_customer_date >
                 o.order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_orders,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN o.order_delivered_customer_date >
                     o.order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        )
        / COUNT(DISTINCT o.order_id),
        2
    ) AS late_delivery_percentage

FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id

WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY oi.seller_id
HAVING COUNT(DISTINCT o.order_id) >= 20
ORDER BY late_delivery_percentage DESC;

-- Category performance

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    COUNT(DISTINCT oi.order_id) AS total_orders,

    COUNT(*) AS total_items,

    ROUND(SUM(oi.price), 2) AS total_revenue,

    ROUND(AVG(oi.price), 2) AS avg_item_price

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )

ORDER BY total_revenue DESC
LIMIT 15;

-- Review score by category

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    COUNT(DISTINCT r.order_id) AS reviewed_orders,

    ROUND(AVG(r.review_score), 2) AS average_review_score,

    SUM(CASE
        WHEN r.review_score = 1 THEN 1
        ELSE 0
    END) AS one_star_reviews,

    SUM(CASE
        WHEN r.review_score = 5 THEN 1
        ELSE 0
    END) AS five_star_reviews

FROM order_reviews r

JOIN order_items oi
    ON r.order_id = oi.order_id

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )

ORDER BY average_review_score DESC;

SELECT
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    ) AS category,

    ROUND(SUM(oi.price), 2) AS product_revenue,

    ROUND(SUM(oi.freight_value), 2) AS freight_value,

    ROUND(
        100 * SUM(oi.freight_value) / SUM(oi.price),
        2
    ) AS freight_percentage

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

GROUP BY
    COALESCE(
        ct.product_category_name_english,
        p.product_category_name
    )

ORDER BY freight_percentage DESC;

-- Create your FINAL SQL business report

