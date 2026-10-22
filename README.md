# Retail Profitability & Customer Analytics

A data analytics portfolio project using **PostgreSQL, Python, and Power BI** to evaluate retail sales performance, profitability, customer value, and discount patterns.

## Project Overview

Retail sales growth does not necessarily translate into higher profit. This project analyzes historical retail transaction data to identify sales trends, understand profit drivers, evaluate product-level losses, and segment customers based on purchasing behavior.

The workflow combines SQL-based analysis, Python data validation, and an interactive Power BI report. Findings are translated into practical business recommendations while distinguishing observed relationships from proven causes.

## Dashboard Preview

The Power BI report presents sales performance, profitability trends, product-level insights, discount analysis, and customer segmentation across two interactive pages.

### Page 1 — Sales & Profitability Overview

![Sales and Profitability Overview](dashboard/screenshots/Retail_Profitability_Customer_Analytics%201%20of%202.png)

Highlights:
- Six core business KPIs
- Monthly sales and profit trends
- Sales by product category and region

### Page 2 — Profitability & Customer Insights

![Profitability and Customer Insights](dashboard/screenshots/Retail_Profitability_Customer_Analytics%202%20of%202.png)

Highlights:
- Profitability by product sub-category
- Profit by discount band
- Sales and profit across RFM customer segments

The report is built in Power BI using data from PostgreSQL.

## Business Questions

- How do sales, profit, and profit margin change over time?
- Which product categories, sub-categories, and regions contribute most to sales and profit?
- Which products generate losses despite recording sales?
- How does profitability vary across discount bands?
- Which customer segments contribute most to sales and profit?
- Where should the business investigate pricing, discounting, and product performance?

## Technology Stack

| Tool | Purpose |
|---|---|
| PostgreSQL | Data storage, quality checks, aggregations, and analytical queries |
| Python | Data validation and profiling using pandas |
| Jupyter Notebook | Reproducible data quality checks |
| Power BI Desktop | Interactive dashboards and KPI reporting |
| Git and GitHub | Version control and project presentation |

## Project Workflow

1. **Data preparation:** Loaded the source data into PostgreSQL raw and clean tables.
2. **Data validation:** Used Python and SQL to check missing values, duplicates, numeric ranges, date consistency, and data quality concerns.
3. **SQL analysis:** Developed queries for sales performance, product profitability, discount analysis, and customer segmentation.
4. **Dashboard development:** Connected Power BI to the clean PostgreSQL table and created a two-page analytical report.
5. **KPI reconciliation:** Compared six Power BI KPI measures against independent PostgreSQL calculations.

## Dataset and Data Quality

The analysis uses the Sample Superstore retail dataset, with transactions spanning **January 2014 to December 2017**.

The analyzed clean table contains:

- **9,994** transaction lines
- **5,009** distinct orders
- **793** distinct customers
- **1,862** distinct products
- **21** columns

Python validation identified no missing cells, exact duplicate rows, or duplicate `Row` identifiers in the analyzed dataset. Date parsing and order-versus-ship date checks also passed.

**Data quality consideration:** Postal codes were inferred as numeric values. Some values have fewer than five digits, which may indicate lost leading zeros or formatting differences. This was flagged for review rather than silently corrected.

The original source CSV remains unchanged. Review the source attribution and licensing terms before redistributing the dataset.

## Power BI Dashboard

The report contains two pages.

### Page 1 — Sales & Profitability Overview

Provides a high-level view of business performance through:

- Total Sales
- Total Profit
- Profit Margin %
- Total Orders
- Total Customers
- Average Order Value
- Monthly sales and profit trends
- Sales by product category
- Sales by region

### Page 2 — Profitability & Customer Insights

Focuses on the drivers and distribution of profitability:

- Profit by sub-category
- Total profit by discount band
- Sales by RFM-style customer segment
- Customer-segment profit and customer-count context

Dashboard screenshots are intended to be stored in `dashboard/screenshots/`.

## Verified KPI Baseline

The six Power BI KPI measures were reconciled against independent SQL calculations on `public.superstore_clean`.

| KPI | Verified result |
|---|---:|
| Total Sales | $2,297,200.86 |
| Total Profit | $286,397.02 |
| Profit Margin | 12.47% |
| Total Orders | 5,009 |
| Total Customers | 793 |
| Average Order Value | $458.61 |

These figures are the verified baseline for the analyzed dataset. The reconciliation confirms the six KPI values under the tested report context; it does not independently validate every visual or filter interaction.

## Advanced Analyses and Key Findings

### 1. Customer Segmentation

An RFM-style approach segments customers using recency, order frequency, and sales value. The reference date is December 31, 2017, based on the last observed order date plus one day.

Key findings:

- Loyal Customers generated approximately **27.53%** of total sales.
- Champions generated approximately **23.90%** of total sales.
- The At Risk - High Value segment contains 33 customers and approximately **5.20%** of total sales.

**Business implication:** Customer engagement strategies can be tailored to observed purchasing behavior and value. These segments are descriptive, not predictive churn classifications.

### 2. Product Profitability and Concentration

Product and sub-category results reveal that high sales do not always imply high profitability.

Examples:

- **Tables:** approximately $206,965.53 in sales and a loss of $17,725.48.
- **Bookcases:** approximately $114,880.00 in sales and a loss of $3,472.56.
- **Copiers:** approximately $55,617.82 in profit.

Profit concentration analysis also shows that the top 20 positive-profit products account for approximately **25.39% of total positive product profit**.

**Business implication:** Review persistently loss-making products, pricing, discounts, and costs. Prioritize profitable products while investigating concentration risk.

### 3. Discount-Band Profitability

Transactions were grouped into five discount bands to compare sales and profit.

| Discount band | Sales | Profit | Profit margin |
|---|---:|---:|---:|
| 0% | $1,087,908.47 | $320,987.60 | 29.51% |
| >0–20% | $846,522.24 | $100,785.47 | 11.91% |
| >20–40% | $234,137.90 | -$35,817.47 | -15.30% |
| >40–60% | $71,048.21 | -$28,944.19 | -40.74% |
| >60% | $57,584.04 | -$70,614.40 | -122.63% |

**Business implication:** Higher discount bands in this dataset are associated with weaker profitability. This is an observed relationship, not proof that discounts alone caused the losses. Product mix, costs, and other factors may also contribute.

## Repository Structure

```text
retail-pos-sql-analysis/
├── assets/
├── dashboard/
│   └── screenshots/
├── data/
│   └── README.md
├── docs/
│   └── findings_and_recommendations.md
├── notebooks/
│   └── 01_data_validation.ipynb
├── sql/
│   ├── 01_data_quality_checks.sql
│   ├── 02_sales_profitability_analysis.sql
│   ├── 03_product_profitability_concentration.sql
│   └── 04_customer_rfm_segmentation.sql
├── .gitignore
└── README.md
```

The Power BI `.pbix` report is maintained separately from the SQL scripts and notebook. Add its location to this repository structure if you decide to commit the report.

## How to Reproduce the Analysis

### Prerequisites

- PostgreSQL
- Python and Jupyter Notebook
- Python packages used by the validation notebook, including pandas and a PostgreSQL database connector
- Power BI Desktop

### Steps

1. Obtain the dataset from a source whose usage and redistribution terms permit your intended use.
2. Load the source data into PostgreSQL and prepare `public.superstore_raw` and `public.superstore_clean`.
3. Run the SQL scripts in the `sql/` directory against the database.
4. Create and activate the project's Python virtual environment, install the required packages, and open `notebooks/01_data_validation.ipynb`.
5. Connect Power BI Desktop to the PostgreSQL database and load `public.superstore_clean`.
6. Recreate or open the report, then validate the six KPI measures against the SQL baseline above.

**Note:** Database names, table names, and connection settings must match your local setup. Do not commit passwords, credentials, or private connection details.

## Limitations

- The analysis describes historical transactions and does not establish causal relationships.
- Customer segments are descriptive RFM-style groups, not forecasts of churn or lifetime value.
- Postal-code formatting requires further review.
- The dataset's redistribution licence must be verified before including the raw CSV in a public repository.
- KPI reconciliation does not guarantee that every dashboard interaction has been tested.

## Potential Next Steps

- Complete a final visual and filter-interaction review of both dashboard pages.
- Save the final Power BI screenshots and document the verified results.
- Finalize the findings and recommendations document.
- Confirm data-source attribution and licensing before publishing.
- Add concise instructions for recreating the database tables from the permitted source data.

## Project Outcome

This project demonstrates an end-to-end analytics workflow: data validation in Python, structured analysis in PostgreSQL, interactive reporting in Power BI, and translation of findings into business-focused recommendations.
