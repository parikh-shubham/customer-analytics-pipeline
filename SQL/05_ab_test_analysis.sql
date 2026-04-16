-- ==============================================================================
-- A/B Test Analysis
-- ==============================================================================

SELECT 
    variant,
    COUNT(exposure_id) AS total_exposures,
    SUM(CAST(clicked AS INT)) AS total_clicks,
    SUM(CAST(purchased AS INT)) AS total_purchases
FROM recommendation_exposure
GROUP BY variant;