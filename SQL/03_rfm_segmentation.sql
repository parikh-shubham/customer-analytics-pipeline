-- ======================================================================
-- Creating Customer RFM Segmentation
-- ======================================================================

IF OBJECT_ID('vw_customer_segments', 'V') IS NOT NULL
DROP VIEW vw_customer_segments;

GO

CREATE VIEW vw_customer_segments AS

WITH RFM_Scores AS (
	SELECT
		customer_id,
		acquisition_channel,
		country,
		days_to_first_purchase,
		recency_days,
		total_transactions,
		total_revenue,
		is_repeat_customer,
		total_discount_received,
		NTILE(5) OVER(ORDER BY recency_days DESC) AS R_Score,
		NTILE(5) OVER(ORDER BY total_transactions ASC) AS F_Score,
		NTILE(5) OVER(ORDER BY total_revenue ASC) AS M_Score
	FROM customer_master
	WHERE total_transactions > 0
)

SELECT
	*,
	CONCAT(R_Score, F_Score, M_Score) AS RFM_Cell,
	CASE
		WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score <= 2 AND M_Score <= 2 THEN 'New Customers'
        WHEN R_Score <= 2 AND F_Score >= 3 AND M_Score >= 3 THEN 'At Risk'
        WHEN R_Score <= 2 AND F_Score <= 2 THEN 'Lost'
        ELSE 'Promising'
	END AS customer_segment
FROM RFM_Scores

GO

-- ======================================================================
-- Analysing Segment Composition
-- ======================================================================

-- 1. Acquisition Channel

SELECT 
	customer_segment, 
	acquisition_channel, 
	COUNT(customer_id) AS users
FROM vw_customer_segments
GROUP BY customer_segment, acquisition_channel
ORDER BY customer_segment, users DESC;

-- 2. Product Category Preference

SELECT 
	v.customer_segment, 
	p.category, 
	COUNT(t.transaction_id) as total_purchases
FROM vw_customer_segments v
JOIN transactions t ON v.customer_id = t.customer_id
JOIN products p ON t.product_id = p.product_id
WHERE t.status = 'completed'
GROUP BY v.customer_segment, p.category
ORDER BY v.customer_segment, total_purchases DESC;

-- 3. Geographic Distribution

SELECT 
	customer_segment, 
	country, 
	COUNT(customer_id) AS users
FROM vw_customer_segments
GROUP BY customer_segment, country
ORDER BY customer_segment, users DESC;

-- 4. Average Discount Dependency

SELECT 
	customer_segment, 
	CAST(AVG(CAST(total_discount_received AS FLOAT)) AS DECIMAL(5,2)) AS avg_discounts_used
FROM vw_customer_segments
GROUP BY customer_segment;


-- ======================================================================
-- Answering Key Business Questions
-- ======================================================================

-- Q1. Which acquisition channels bring the highest-value customers?
-- Ans. Direct is the best acquisition channel having average revenue of 4100.78.

SELECT
	acquisition_channel,
	COUNT(customer_id) AS total_customers,
	SUM(CASE WHEN customer_segment = 'Champions' THEN 1 ELSE 0 END) AS champion_count,
	CAST(AVG(total_revenue) AS DECIMAL(10,2)) AS avg_revenue
FROM vw_customer_segments
GROUP BY acquisition_channel
ORDER BY avg_revenue DESC;

-- Q2. Are discount-acquired customers less loyal?
-- Ans. No, infact they are more loyal with repeat purchase rate of 72.52% compared to 24.09%
-- and their average purchase of 7.27 compared to 1.41 woth customers having No Discount.

SELECT
	CASE WHEN total_discount_received > 0 THEN 'Used Discount' ELSE 'No Discount' END AS discount,
	COUNT(customer_id) AS total_customers,
	CAST(AVG(CAST(is_repeat_customer AS FLOAT)) * 100 AS DECIMAL(5,2)) AS repeat_purchase_rate,
	CAST(AVG(total_transactions * 1.0) AS DECIMAL(5,2)) AS avg_purchase
FROM vw_customer_segments
GROUP BY CASE WHEN total_discount_received > 0 THEN 'Used Discount' ELSE 'No Discount' END;

-- Q3. What's the relationship between first-purchase timing and lifetime value?
-- Ans. If the purchase is made the same day then its average lifetime value is highest with 9585.27
-- but if the purchase is done post 30 days then the average lifetime value stays at 3998.36.

SELECT
	CASE
		WHEN days_to_first_purchase = 0 THEN 'Same Day'
		WHEN days_to_first_purchase = 0 THEN '1st Week'
		WHEN days_to_first_purchase = 0 THEN '1st Month'
		ELSE '30+ Days'
	END AS conversion,
	COUNT(customer_id) AS volume,
	CAST(AVG(total_revenue) AS DECIMAL(10,2)) AS avg_lifetime_value
FROM vw_customer_segments
GROUP BY
	CASE
		WHEN days_to_first_purchase = 0 THEN 'Same Day'
		WHEN days_to_first_purchase = 0 THEN '1st Week'
		WHEN days_to_first_purchase = 0 THEN '1st Month'
		ELSE '30+ Days'
	END
ORDER BY avg_lifetime_value DESC;