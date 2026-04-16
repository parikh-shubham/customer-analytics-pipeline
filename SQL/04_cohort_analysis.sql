-- ===================================================================
-- Creating Cohort Analysis
-- ===================================================================

WITH CohortBase AS (
    SELECT 
        FORMAT(signup_date, 'yyyy-MM') AS cohort_month,
        COUNT(DISTINCT customer_id) AS initial_customers
    FROM customers
    WHERE signup_date IS NOT NULL 
    GROUP BY FORMAT(signup_date, 'yyyy-MM')
),

UserActivity AS (
    SELECT 
        c.customer_id,
        FORMAT(c.signup_date, 'yyyy-MM') AS cohort_month,
        DATEDIFF(DAY, c.signup_date, t.transaction_date) AS days_since_signup
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    WHERE t.status = 'completed' AND c.signup_date IS NOT NULL
),

Retention AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT CASE WHEN days_since_signup BETWEEN 0 AND 30 THEN customer_id END) AS retained_30d,
        COUNT(DISTINCT CASE WHEN days_since_signup BETWEEN 31 AND 60 THEN customer_id END) AS retained_60d,
        COUNT(DISTINCT CASE WHEN days_since_signup BETWEEN 61 AND 90 THEN customer_id END) AS retained_90d,
        COUNT(DISTINCT CASE WHEN days_since_signup BETWEEN 91 AND 120 THEN customer_id END) AS retained_120d,
        COUNT(DISTINCT CASE WHEN days_since_signup BETWEEN 121 AND 150 THEN customer_id END) AS retained_150d,
        COUNT(DISTINCT CASE WHEN days_since_signup BETWEEN 151 AND 180 THEN customer_id END) AS retained_180d
    FROM UserActivity
    GROUP BY cohort_month
)

SELECT 
    cb.cohort_month,
    cb.initial_customers,
    CAST((r.retained_30d * 100.0) / cb.initial_customers AS DECIMAL(5,2)) AS pct_30d,
    CAST((r.retained_60d * 100.0) / cb.initial_customers AS DECIMAL(5,2)) AS pct_60d,
    CAST((r.retained_90d * 100.0) / cb.initial_customers AS DECIMAL(5,2)) AS pct_90d,
    CAST((r.retained_120d * 100.0) / cb.initial_customers AS DECIMAL(5,2)) AS pct_120d,
    CAST((r.retained_150d * 100.0) / cb.initial_customers AS DECIMAL(5,2)) AS pct_150d,
    CAST((r.retained_180d * 100.0) / cb.initial_customers AS DECIMAL(5,2)) AS pct_180d
FROM CohortBase cb
LEFT JOIN Retention r ON cb.cohort_month = r.cohort_month
ORDER BY cb.cohort_month;