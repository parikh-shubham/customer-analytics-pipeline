# Data Quality & ETL Notes

## 1. Schema Differences
A comparison of the raw CSV files against the original documentation revealed a few differences:
* **Transactions:** The documentation mentioned negative quantities and zero-price rows, but none were found in the actual data.
* **Recommendations:** The column called `variant` in the documentation was named `algorithm` in the file.
* **Customers:** The `first_purchase_date` column was missing and had to be calculated using the transactions data.

## 2. Missing Data
* `phone`: Missing for about 3% of users.
* `churn_date`: Missing for about 81% of users. This is normal and indicates users who have not churned.
* `loyalty_points`: No missing values.
* `discount_code`: Missing in about 66% of transactions, which is expected since most people buy at full price.

## 3. Major Data Issues
* **Future Signup Dates:** 131,555 records in the customers table had signup dates after the dataset cutoff of March 31, 2024. 

## 4. How the Data Was Fixed (ETL)
1. **Fixing Dates:** Any signup date after March 31, 2024, was changed to NULL. This ensured future dates did not skew the Q1 cohort analysis.
2. **Creating Missing Metrics:** The `first_purchase_date` was calculated by joining the transactions table. The `total_discount_received` metric was created by counting how many discount codes each user successfully applied.
3. **Safe Casting:** `TRY_CAST` was used to handle bad data types safely, and `COALESCE` was used to turn NULL revenue into 0 so the Python calculations would not break.
4. **Date Joins:** For the A/B test, the time was stripped off the dates when joining transactions to the exposure logs. This ensured that same-day purchases were not missed due to timestamp differences.
