
-- Project: Retail Profitability & Customer Analytics
-- Purpose: Validate the cleaned Superstore dataset.
-- Source: public.superstore_clean

-- 1. Dataset size and key entity counts
SELECT
    COUNT(*) AS order_lines,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(DISTINCT customer_id) AS distinct_customers,
    COUNT(DISTINCT product_id) AS distinct_products
FROM public.superstore_clean;

-- 2. Date and numeric quality checks
SELECT
    COUNT(*) FILTER (WHERE order_date IS NULL) AS missing_order_dates,
    COUNT(*) FILTER (WHERE ship_date IS NULL) AS missing_ship_dates,
    COUNT(*) FILTER (WHERE ship_date < order_date) AS ship_before_order,
    COUNT(*) FILTER (WHERE sales <= 0) AS nonpositive_sales,
    COUNT(*) FILTER (WHERE quantity <= 0) AS nonpositive_quantity,
    COUNT(*) FILTER (
        WHERE discount < 0 OR discount > 1
    ) AS invalid_discounts,
    COUNT(*) FILTER (WHERE profit IS NULL) AS missing_profit
FROM public.superstore_clean;

-- 3. Overall sales and profitability baseline
SELECT
    COUNT(*) AS order_lines,
    COUNT(DISTINCT order_id) AS distinct_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS overall_profit_margin_pct,
    ROUND(AVG(sales), 2) AS average_line_sales,
    ROUND(AVG(discount), 4) AS average_line_discount
FROM public.superstore_clean;
