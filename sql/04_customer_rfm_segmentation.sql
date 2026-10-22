
-- Project: Retail Profitability & Customer Analytics
-- Purpose: Calculate RFM metrics and segment customers.
-- Source: public.superstore_clean
-- Reference date: latest order date + 1 day.
-- Segmentation is rule-based and descriptive, not predictive.

-- 1. Customer-level RFM metrics
WITH analysis_date AS (
    SELECT MAX(order_date) + 1 AS reference_date
    FROM public.superstore_clean
),
customer_metrics AS (
    SELECT
        customer_id,
        MAX(customer_name) AS customer_name,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency_orders,
        SUM(sales) AS monetary_sales,
        SUM(profit) AS total_profit
    FROM public.superstore_clean
    GROUP BY customer_id
)
SELECT
    cm.customer_id,
    cm.customer_name,
    cm.last_order_date,
    ad.reference_date,
    ad.reference_date - cm.last_order_date AS recency_days,
    cm.frequency_orders,
    ROUND(cm.monetary_sales, 2) AS monetary_sales,
    ROUND(cm.total_profit, 2) AS total_profit
FROM customer_metrics cm
CROSS JOIN analysis_date ad
ORDER BY cm.monetary_sales DESC;

-- 2. RFM scores and customer segments
WITH analysis_date AS (
    SELECT MAX(order_date) + 1 AS reference_date
    FROM public.superstore_clean
),
customer_metrics AS (
    SELECT
        customer_id,
        MAX(customer_name) AS customer_name,
        MAX(order_date) AS last_order_date,
        COUNT(DISTINCT order_id) AS frequency_orders,
        SUM(sales) AS monetary_sales,
        SUM(profit) AS total_profit
    FROM public.superstore_clean
    GROUP BY customer_id
),
customer_recency AS (
    SELECT
        cm.*,
        ad.reference_date,
        ad.reference_date - cm.last_order_date AS recency_days
    FROM customer_metrics cm
    CROSS JOIN analysis_date ad
),
rfm_scores AS (
    SELECT
        *,
        NTILE(5) OVER (
            ORDER BY recency_days DESC
        ) AS recency_score,
        NTILE(5) OVER (
            ORDER BY frequency_orders ASC
        ) AS frequency_score,
        NTILE(5) OVER (
            ORDER BY monetary_sales ASC
        ) AS monetary_score
    FROM customer_recency
),
segmented_customers AS (
    SELECT
        *,
        CASE
            WHEN recency_score >= 4
             AND frequency_score >= 4
             AND monetary_score >= 4
                THEN 'Champions'
            WHEN frequency_score >= 4
             AND monetary_score >= 3
                THEN 'Loyal Customers'
            WHEN recency_score >= 4
             AND frequency_score >= 2
                THEN 'Potential Loyalists'
            WHEN recency_score <= 2
             AND frequency_score >= 3
             AND monetary_score >= 3
                THEN 'At Risk - High Value'
            WHEN recency_score <= 2
             AND frequency_score <= 2
                THEN 'Needs Attention'
            ELSE 'Other Customers'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(monetary_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(
        SUM(monetary_sales)
        / NULLIF(SUM(SUM(monetary_sales)) OVER (), 0) * 100,
        2
    ) AS sales_share_pct
FROM segmented_customers
GROUP BY customer_segment
ORDER BY total_sales DESC;
