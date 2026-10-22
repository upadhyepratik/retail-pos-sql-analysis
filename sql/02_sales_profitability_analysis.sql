
-- Project: Retail Profitability & Customer Analytics
-- Purpose: Analyze sales, profit, and product performance.
-- Source: public.superstore_clean

-- 1. Annual sales and profitability trends
SELECT
    EXTRACT(YEAR FROM order_date)::INTEGER AS order_year,
    COUNT(DISTINCT order_id) AS distinct_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;

-- 2. Monthly sales and profitability trends
SELECT
    DATE_TRUNC('month', order_date)::DATE AS order_month,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;

-- 3. Profitability by category and sub-category
SELECT
    category,
    sub_category,
    COUNT(DISTINCT order_id) AS distinct_orders,
    SUM(quantity) AS units_sold,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
GROUP BY category, sub_category
ORDER BY total_profit ASC;

-- 4. Discount bands and profitability
WITH discount_bands AS (
    SELECT
        CASE
            WHEN discount = 0 THEN '0% - No discount'
            WHEN discount <= 0.20 THEN '>0-20%'
            WHEN discount <= 0.40 THEN '>20-40%'
            WHEN discount <= 0.60 THEN '>40-60%'
            ELSE '>60%'
        END AS discount_band,
        CASE
            WHEN discount = 0 THEN 1
            WHEN discount <= 0.20 THEN 2
            WHEN discount <= 0.40 THEN 3
            WHEN discount <= 0.60 THEN 4
            ELSE 5
        END AS band_order,
        order_id,
        sales,
        profit,
        discount
    FROM public.superstore_clean
)
SELECT
    discount_band,
    COUNT(*) AS order_lines,
    COUNT(DISTINCT order_id) AS distinct_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(discount) * 100, 2) AS average_discount_pct
FROM discount_bands
GROUP BY discount_band, band_order
ORDER BY band_order;
