-- ============================================================
-- THE UNLOX ACADEMY - Weekly Assessment 3 - SQL Foundations
-- Name: Shoyal Halder
-- Dataset: flipcart.products
-- Date : 08-07-2026
-- ============================================================


-- ============================================================
-- SECTION A - THEORY (write answer letter a/b/c/d)
-- ============================================================

-- A1. Schema vs database relationship in MySQL
-- Answer: c)  Schema and database are the same thing in MySQL 

-- A2. TRUNCATE TABLE belongs to which command family
-- Answer: b)  DDL (Data Definition Language) 

-- A3. Best data type for storing prices (e.g. 299.50, 79999.00)
-- Answer: b) DECIMAL

-- A4. INSERT with non-existent customer_id under FK constraint
-- Answer:  c) The INSERT fails with a foreign key constraint error

-- A5. WHERE vs HAVING
-- Answer: b) WHERE filters individual rows before aggregation; HAVING filters groups after aggregation

-- A6. SELECT * FROM products WHERE avg_rating = NULL;
-- Answer: c) Returns 0 rows

-- A7. COUNT(*) vs COUNT(column_name)
-- Answer:  b) COUNT(*) counts all rows; COUNT(column_name) counts only non-NULL values in that column

-- A8. Command that drops table structure + data, no ROLLBACK
-- Answer:  c) DROP TABLE table_name


-- ============================================================
-- SECTION B - OUTPUT PREDICTION (describe row count / values)
-- ============================================================

-- B1. SELECT COUNT(*) FROM products WHERE category = 'Electronics';
-- Answer: Returns a single row with a single column name count(*), value = 8.

-- B2. SELECT * FROM products WHERE price BETWEEN 1000 AND 3000;
-- Answer: Returns 11 rows, all 10 columns, where price is between ₹1000 and ₹3000 inclusive.

-- B3. SELECT product_name FROM products WHERE category = 'Books' AND price < 400 ORDER BY price DESC LIMIT 1;
-- Answer: Returns 1 row — product_name = 'The Silent Patient' (the most expensive Book under ₹400).

-- B4. SELECT * FROM products WHERE avg_rating IS NULL;
-- Answer: Returns 3 rows, all 10 columns, where avg_rating IS NULL.

-- B5. SELECT MAX(price) FROM products WHERE category = 'Books';
-- Answer: Returns a single value = 499.00 (the highest price among Books).

-- B6. SELECT category, COUNT(*) FROM products WHERE is_active = TRUE GROUP BY category HAVING COUNT(*) > 4;
-- Answer: Returns 3 rows — Electronics (7), Apparel (6), Home (5) — categories with more than 4 active products.

-- B7. CASE WHEN price < 500 THEN 'Budget' ... query on Beauty category
-- Answer:Returns 4 rows (all Beauty products), each with product_name and a computed tier column: Nykaa Matte Lipstick → Mid, Lakme Eye Liner → Budget, Mamaearth Face Wash → Budget, WOW Skin Vitamin C Serum → Mid.

-- B8. SELECT product_name, COALESCE(avg_rating, 0) AS rating FROM products WHERE stock_quantity = 0;
-- Answer: Returns 2 rows — JBL Flip 6 Speaker (4.30) and WOW Skin Vitamin C Serum (4.50) — both out-of-stock products, neither has a NULL rating so COALESCE had nothing to substitute.

-- ============================================================
-- SECTION C - APPLIED SQL (write actual query, format properly)
-- ============================================================

-- --- C1: Basic SELECT + WHERE + ORDER BY ---

-- C1. Display all products, all columns.
SELECT * FROM products;

-- C2. product_name and price of all Books.
SELECT product_name, price FROM products WHERE category = 'Books';

-- C3. Products priced above 10,000, sorted highest to lowest.
SELECT * FROM products WHERE price > 10000.00 ORDER BY price DESC;

-- C4. Top 5 most expensive Electronics products (name + price).
SELECT product_name, price FROM products WHERE category = 'Electronics' ORDER BY price DESC LIMIT 5; 

-- --- C2: Filtering Variations (IN, BETWEEN, LIKE) ---

-- C5. Products in Electronics or Apparel. Use IN.
SELECT * FROM products WHERE category IN ('Electronics', 'Apparel');

-- C6. Products priced between 500 and 2000 (inclusive).
SELECT * FROM products WHERE price BETWEEN 500 AND 2000;

-- C7. Products whose name contains 'Watch'.
SELECT * FROM products WHERE product_name LIKE '%Watch%';

-- C8. Products whose brand starts with 'S'.
SELECT * FROM products WHERE brand LIKE 'S%';

-- --- C3: DISTINCT + Aggregate Functions ---

-- C9. List unique categories.
SELECT DISTINCT category FROM products;

-- C10. Total number of products in catalogue.
SELECT COUNT(*) AS total_no_products FROM products;

-- C11. Average price of all Books.
SELECT AVG(price) AS avg_book_price FROM products WHERE category = 'Books';

-- C12. Max and min price across all products, single query.
SELECT MAX(price) , MIN(price) FROM products;

-- --- C4: GROUP BY ---

-- C13. Count of products per category.
SELECT category, COUNT(*) AS product_count FROM products GROUP BY category;

-- C14. Total stock quantity per category.
SELECT category, SUM(stock_quantity) AS total_stock FROM products GROUP BY category;

-- C15. Average price per category, sorted highest to lowest.
SELECT category, AVG(price) AS avg_price FROM products GROUP BY category ORDER BY avg_price DESC;

-- C16. Count of products + avg price per brand, only brands with more than 1 product.
SELECT brand, COUNT(*) AS product_count , AVG(price) AS avg_price FROM products GROUP BY brand HAVING COUNT(*) > 1;
-- returns 0 rows, no brand has more than 1 product in this dataset

-- --- C5: HAVING + LIMIT ---

-- C17. Categories with more than 4 active products.
SELECT category, COUNT(*) AS no_active_products FROM products WHERE is_active = TRUE GROUP BY category HAVING COUNT(*) > 4;

-- C18. Top 3 most expensive products overall.
SELECT * FROM products ORDER BY price DESC LIMIT 3;

-- C19. Categories where average price is above 2,000.
SELECT category , AVG(price) AS avg_price FROM products GROUP BY category HAVING AVG(price) > 2000;

-- --- C6: NULL Handling ---

-- C20. Products where avg_rating is missing.
SELECT * FROM products WHERE avg_rating IS NULL;

-- C21. product_name and rating; show 'New Launch' if avg_rating is NULL.
SELECT product_name,COALESCE(avg_rating, 'New Launch') AS rating  FROM products;

-- --- C7: CASE WHEN ---

-- C22. price_tier column: Budget (<1000), Mid (<10000), Premium (>=10000).
SELECT 
    product_id,
    product_name,
    category,
    brand,
    price,
    CASE
        WHEN price < 1000 THEN 'Budget'
        WHEN price < 10000 THEN 'Mid'
        ELSE 'Premium'
    END AS price_tier
FROM
    products;

-- C23. Per category: total product count + count of Premium products (>=10000), using SUM(CASE WHEN...).
SELECT
    category,
    COUNT(*) AS total_product_count,
    SUM(CASE WHEN price >= 10000 THEN 1 ELSE 0 END) AS premium_product_count
FROM
    products
GROUP BY category;

-- C24. Per category (only categories with >=3 products): total count, active count,
--      avg price, category_tier (Cheap <1500, Standard <10000, Luxury >=10000).
--      Sort by avg price descending.

SELECT 
    category,
    COUNT(*) AS product_count,
    SUM(CASE
        WHEN is_active = TRUE THEN 1
        ELSE 0
    END) AS no_of_active_product,
    AVG(price) AS avg_price,
    CASE
        WHEN AVG(price) < 1500 THEN 'Cheap'
        WHEN AVG(price) < 10000 THEN 'Standard'
        ELSE 'Luxury'
    END AS category_tier
FROM
    products
GROUP BY category
HAVING COUNT(*) >= 3
ORDER BY AVG(price) DESC;