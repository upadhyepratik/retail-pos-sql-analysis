
-- Project: Retail Profitability & Customer Analytics
-- Purpose: Identify loss-making products and measure profit concentration.
-- Source: public.superstore_clean

-- 1. Loss-making sub-categories
SELECT
    category,
    sub_category,
    COUNT(DISTINCT order_id) AS distinct_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct
FROM public.superstore_clean
GROUP BY category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- 2. Top 15 loss-making products
SELECT
    category,
    sub_category,
    product_id,
    product_name,
    COUNT(*) AS order_lines,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin_pct,
    ROUND(AVG(discount) * 100, 2) AS average_discount_pct
FROM public.superstore_clean
GROUP BY category, sub_category, product_id, product_name
HAVING SUM(profit) < 0
ORDER BY total_profit ASC
LIMIT 15;

-- 3. Product profit concentration among profitable products
WITH product_profit AS (
    SELECT
        product_id,
        MAX(product_name) AS product_name,
        SUM(profit) AS total_profit
    FROM public.superstore_clean
    GROUP BY product_id
),
positive_products AS (
    SELECT
        product_id,
        product_name,
        total_profit,
        SUM(total_profit) OVER () AS total_positive_profit,
        SUM(total_profit) OVER (
            ORDER BY total_profit DESC, product_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cumulative_profit
    FROM product_profit
    WHERE total_profit > 0
)
SELECT
    ROW_NUMBER() OVER (
        ORDER BY total_profit DESC, product_id
    ) AS profit_rank,
    product_id,
    product_name,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(
        cumulative_profit / NULLIF(total_positive_profit, 0) * 100,
        2
    ) AS cumulative_positive_profit_pct
FROM positive_products
ORDER BY profit_rank;
