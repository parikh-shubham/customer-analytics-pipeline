# Customer Analytics Pipeline Project

Welcome to the **Customer Analytics Pipeline Project** repository! 🚀  
Designed as a portfolio project, this repository demonstrates an end-to-end analytics pipeline evaluating customer behavior, retention cohorts, segment distribution, and the financial impact of a recommendation algorithm to provide actionable, segment-routed strategies.

---

## 🏗️ Pipeline Architecture

The architecture for this project spans data processing, statistical validation, and executive reporting:
1. **Data Engineering (SQL)**: Database architecture, indexing, data cleaning, and the creation of analytical views (RFM, Cohorts) in SQL Server.
2. **Statistical Analysis (Python)**: Jupyter Notebooks (`analysis.ipynb`, `statistic.ipynb`) executing cohort retention heatmaps, EDA, and A/B test validation via two-sample t-tests and Chi-Square tests.
3. **Business Intelligence (Power BI)**: Executive reporting dashboards mapping out financial projections and strategic outcomes.

---

## 📖 Project Overview

This project involves:

1. **Data Preparation & Architecture**: Building schemas, resolving data anomalies, and establishing covering indexes for optimized query execution.
2. **Customer Segmentation**: Developing RFM models and day-30 cohort retention views to identify mid-funnel re-engagement gaps.
3. **Experimentation Validation**: Statistically validating A/B test results to uncover segment-level algorithm cannibalization.
4. **Strategic Reporting**: Translating findings into actionable steps for promotional budget reallocation and acquisition channel shifts.

---

## 🚀 Project Requirements

### Data Processing & Statistical Validation (Data Engineering & Data Science)

#### Objective
Develop an end-to-end pipeline to move beyond surface-level metrics, utilizing SQL and Python to extract, clean, and validate customer segment behaviors and A/B test outcomes.

#### Specifications
- **Data Environment**: SQL Server (SSMS) for T-SQL data modeling and Python 3.9+ (`pandas`, `numpy`, `scipy`, `statsmodels`) for statistical analysis.
- **Data Quality**: Document and resolve data anomalies; default missing transaction dates to the last known valid login.
- **Experimentation**: Validate the recommendation algorithm assuming a random sample, utilizing a 7-day conversion window following exposure.
- **Scope**: Execution includes building base schemas (`00_create_tables.sql`), establishing indexes (`01_build_indexes.sql`), and sequentially generating pre-aggregated analytical views.

---

### BI: Analytics & Reporting (Data Analysis & Strategy)

#### Objective
Develop Power BI dashboards and executive summaries to deliver detailed, actionable insights into customer retention, promotional efficiency, and channel acquisition.

#### Specifications
- **Key Findings Extracted**:
  - **Retention**: Structural retention plateau at ~9% by Day 30 across Q1 cohorts.
  - **Promotions**: Inefficient spend on highly price-inelastic "Champions" and "Loyal Customers."
  - **Algorithms**: The new algorithm boosted "New Customers" but actively cannibalized conversion for "Champions."
  - **Channels**: Paid social drives volume but creates "Lost" users; Organic/Direct drives high-LTV Champions.
- **Strategic Recommendations**: Deploy segment-routed algorithms, restrict promo codes to lower-tier activation, and shift top-of-funnel spend toward Organic SEO and Direct-to-Consumer branding.

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). 

---

## 🌟 About Me

Hi there! I'm **Shubham Parikh**. I am a Computer Engineer who understands both technology and business operations. Instead of focusing only on code, I focus on how systems, data, and processes work together to improve business performance.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/shubhamparikh/)
