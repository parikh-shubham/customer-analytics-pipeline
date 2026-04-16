-- ==============================================================================
-- Creating Customer Master Table
-- ==============================================================================

IF OBJECT_ID('customer_master', 'U') IS NOT NULL 
DROP TABLE customer_master;

WITH CustomerAggregates AS (
    -- Grouping all successful transactions by customer
    SELECT 
        customer_id,
        MIN(transaction_date) AS first_purchase_date,
        MAX(transaction_date) AS last_purchase_date,
        COUNT(DISTINCT transaction_id) AS total_transactions,
        SUM(total_amount) AS total_revenue,
        SUM(CASE WHEN discount_code IS NOT NULL AND discount_code <> '' THEN 1 ELSE 0 END) AS total_discount_received
    FROM transactions
    WHERE status = 'completed'
    GROUP BY customer_id
)

SELECT 
    c.customer_id,
    c.signup_date,
    c.acquisition_channel,
    c.country,
    a.first_purchase_date,
    a.last_purchase_date,
    DATEDIFF(DAY, c.signup_date, a.first_purchase_date) AS days_to_first_purchase,
    COALESCE(a.total_transactions, 0) AS total_transactions,
    COALESCE(a.total_revenue, 0) AS total_revenue,
    COALESCE(a.total_discount_received, 0) AS total_discount_received,
    CASE 
        WHEN a.total_transactions > 0 THEN a.total_revenue / a.total_transactions 
        ELSE 0 
    END AS avg_order_value,
    CASE 
        WHEN a.total_transactions > 1 THEN 1 
        ELSE 0 
    END AS is_repeat_customer,
    DATEDIFF(DAY, c.signup_date, a.last_purchase_date) AS customer_lifetime_days,
    DATEDIFF(DAY, a.last_purchase_date, (SELECT MAX(transaction_date) FROM transactions)) AS recency_days
INTO customer_master
FROM customers c
LEFT JOIN CustomerAggregates a ON c.customer_id = a.customer_id;