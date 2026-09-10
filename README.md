# E-Commerce Product Intelligence

An end-to-end data analytics project examining sales, product performance, fulfillment, customer experience, retention, seller risk, and geographic demand in a Brazilian e-commerce marketplace.

## Live Dashboard

[View the interactive Tableau dashboard](https://public.tableau.com/views/E-CommerceProductIntelligenceDashboard/ExecutiveOverview)

## Project Summary

This project analyzes 99,441 e-commerce orders using Python, MariaDB SQL, and Tableau. Raw marketplace data was audited, cleaned, modeled into a relational warehouse, analyzed through reusable SQL views, and presented in two interactive dashboards.

### Key Performance Indicators

* 99,441 total orders
* 96,478 delivered orders
* $15.4 million in delivered revenue
* $159.83 average order value
* 12.6 average delivery days
* 8.1% late-delivery rate
* 4.16 out of 5 average review score

## Business Questions

* How did revenue and order volume change over time?
* Which product categories generated the most value?
* How did shipping distance affect freight cost and delivery time?
* How did early and late deliveries affect customer ratings?
* How did one-time and repeat customers differ?
* Which high-volume sellers presented the greatest operational risk?
* Which Brazilian states generated the most revenue and delivery risk?

## Key Findings

* Health and Beauty generated the highest category value at approximately $1.41 million.
* Average freight cost increased from $13.29 for shipments under 100 km to $39.55 for shipments traveling at least 1,500 km.
* Average delivery time increased from 6.49 days to 20.49 days across the same distance groups.
* The late-delivery rate increased from 6.34% to 12.98% as shipping distance increased.
* Orders delivered at least eight days early received an average review score of 4.32, while orders delivered at least eight days late averaged 1.73.
* The customer base included 93,099 one-time customers and 2,997 repeat customers, revealing a major retention opportunity.

These findings show associations within the marketplace data and should not be interpreted as proof of causation.

## Dashboard Pages

### Executive Overview

Summarizes core KPIs, monthly delivered revenue, leading product categories, and state-level performance.

### Operations & Customer Experience

Explores shipping-distance effects, customer ratings by delivery timing, customer retention, and high-volume seller risk.

## Tools and Skills

* **Python:** pandas, data cleaning, feature engineering, validation, and export preparation
* **SQL and MariaDB:** relational modeling, joins, aggregations, reusable views, indexes, keys, and relationship validation
* **Tableau:** KPI design, trend analysis, dual-axis charts, geographic visualization, tooltips, color encoding, and dashboard navigation
* **Git and GitHub:** version control and project documentation

## Project Workflow

1. Audited the raw datasets for missing values, duplicate records, and key integrity.
2. Cleaned and standardized customer, seller, product, order, payment, review, and geographic data.
3. Engineered delivery, distance, revenue, freight, retention, and review features.
4. Loaded dimension and fact tables into a MariaDB warehouse.
5. Validated row counts, primary keys, foreign keys, and orphan records.
6. Created eight reusable SQL views for business analysis.
7. Exported compact dashboard-ready datasets.
8. Built and published two interactive Tableau dashboards.

## Repository Structure

```text
ecommerce-product-intelligence/
├── dashboard/
│   └── data/          # Dashboard-ready analytical CSV files
├── data/
│   ├── raw/           # Original data excluded from Git
│   └── processed/     # Processed data excluded from Git
├── notebooks/
│   ├── 01_data_audit.ipynb
│   ├── 02_data_cleaning.ipynb
│   ├── 03_database_load.ipynb
│   └── 04_sql_business_analysis.ipynb
├── reports/           # Data-quality and warehouse validation outputs
├── sql/               # Reusable MariaDB business-analysis views
├── .gitignore
└── README.md
```

## Data Validation

The final warehouse was validated with the following row counts:

| Table              |    Rows |
| ------------------ | ------: |
| `dim_customers`    |  99,441 |
| `dim_sellers`      |   3,095 |
| `dim_products`     |  32,951 |
| `fact_orders`      |  99,441 |
| `fact_order_items` | 112,650 |

All tested customer, order, product, and seller relationships returned zero orphan records.

## Dataset

The project uses the public Olist Brazilian e-commerce dataset, covering marketplace orders placed between 2016 and 2018. Raw and processed datasets are excluded from this repository because of their size. Compact analytical exports used by the dashboard are included.

## Author

**Adnan Ahmed**
Data Analytics student at Washington State University
