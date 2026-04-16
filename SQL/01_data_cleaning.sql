-- ===========================================================
-- 1. Cleaning & Inserting Customers Table
-- ===========================================================

IF OBJECT_ID('customers', 'U') IS NOT NULL
DROP TABLE customers;

SELECT
	TRIM(customer_id) AS customer_id,
	LOWER(TRIM(email)) AS email,
	TRIM(first_name) AS first_name,
	TRIM(last_name) AS last_name,
	TRIM(phone) AS phone,
	TRIM(country) AS country,
	TRIM(city) AS city,
	CASE 
        WHEN LOWER(TRIM(acquisition_channel)) IN ('fb_ads', 'facebook ads', 'facebook_ads') THEN 'facebook_ads'
        ELSE LOWER(TRIM(acquisition_channel))
    END AS acquisition_channel,
	LOWER(TRIM(segment)) AS segment,
	CASE
		WHEN TRY_CAST(registration_date AS DATETIME) > '2024-03-31' THEN NULL
		ELSE TRY_CAST(registration_date AS DATETIME)
	END AS signup_date,
	TRIM(cohort_month) AS cohort_month,
	TRY_CAST(is_churned AS BIT) AS is_churned,
	TRY_CAST(churn_date AS DATETIME) AS churn_date,
	TRY_CAST(loyalty_points AS INT) AS loyalty_points,
	TRY_CAST(lifetime_value_usd AS DECIMAL(10,2)) AS lifetime_value_usd
INTO customers
FROM imported_customers
WHERE customer_id IS NOT NULL AND customer_id <> 'customer_id';

-- ===========================================================
-- 2. Cleaning & Inserting Transactions Table
-- ===========================================================

IF OBJECT_ID('transactions', 'U') IS NOT NULL
DROP TABLE transactions;

SELECT
	TRIM(transaction_id) AS transaction_id,
	TRIM(customer_id) AS customer_id,
	TRIM(product_id) AS product_id,
	TRY_CAST(quantity AS INT) AS quantity,
	TRY_CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
	TRY_CAST(total_amount AS DECIMAL(10,2)) AS total_amount,
	TRIM(currency) AS currency,
	LOWER(TRIM(payment_method)) AS payment_method,
	CASE
		WHEN TRY_CAST(unit_price AS DECIMAL(10,2)) = 0 THEN 'failed'
		ELSE LOWER(TRIM(status))
	END AS status,
	TRIM(discount_code) AS discount_code,
	TRY_CAST(transaction_date AS DATETIME) AS transaction_date,
	LOWER(TRIM(device)) AS device,
	LOWER(TRIM(platform)) AS platform
INTO transactions
FROM imported_transactions
WHERE transaction_id IS NOT NULL AND transaction_id <> 'transaction_id';

-- ===========================================================
-- 3. Cleaning & Inserting Products Table
-- ===========================================================

IF OBJECT_ID('products', 'U') IS NOT NULL 
DROP TABLE products;

SELECT 
    TRIM(product_id) AS product_id,
    TRIM(name) AS name,
    TRIM(category) AS category,
    TRIM(brand) AS brand,
    TRY_CAST(price AS DECIMAL(10,2)) AS price,
    TRIM(currency) AS currency,
    TRY_CAST(cost AS DECIMAL(10,2)) AS cost,
    TRY_CAST(rating AS DECIMAL(3,1)) AS rating,
    TRY_CAST(review_count AS INT) AS review_count,
    TRY_CAST(stock_qty AS INT) AS stock_qty,
    TRY_CAST(is_active AS BIT) AS is_active, 
    TRIM(description) AS description,
    TRY_CAST(created_at AS DATETIME) AS created_at
INTO products
FROM imported_products
WHERE product_id IS NOT NULL AND product_id <> 'product_id';

-- ===========================================================
-- 4. Cleaning & Inserting Recommendation Exposure Table
-- ===========================================================

IF OBJECT_ID('recommendation_exposure', 'U') IS NOT NULL 
DROP TABLE recommendation_exposure;

SELECT 
    TRIM(exposure_id) AS exposure_id,
    TRIM(customer_id) AS customer_id,
    TRIM(product_id) AS product_id,
    TRIM(recommendation_id) AS recommendation_id,
    LOWER(TRIM(algorithm)) AS algorithm,
    CASE 
        WHEN LOWER(TRIM(algorithm)) IN ('collaborative_filtering', 'content_based', 'hybrid') THEN 'treatment'
        ELSE 'control' 
    END AS variant, -- for the A/B test
    TRY_CAST(position AS INT) AS position,
    LOWER(TRIM(page_context)) AS page_context,
    TRY_CAST(clicked AS BIT) AS clicked,
    TRY_CAST(purchased AS BIT) AS purchased,
    TRY_CAST(exposure_date AS DATETIME) AS exposure_date,
    TRIM(session_id) AS session_id
INTO recommendation_exposure
FROM imported_recommendation_exposure
WHERE exposure_id IS NOT NULL AND exposure_id <> 'exposure_id';