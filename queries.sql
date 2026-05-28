-- Query 1: Monthly Revenue Trend
SELECT 
    DATE_FORMAT(o.order_purchase_date, '%Y-%m') AS month,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- Query 2: Top 10 Categories by Revenue
SELECT 
    p.category_name,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 3: Customer Lifetime Value (CLV)
SELECT 
    o.customer_id,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS lifetime_value,
    ROUND(AVG(oi.price), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.customer_id
ORDER BY lifetime_value DESC
LIMIT 20;

-- Query 4: Average Delivery Time by State
SELECT 
    c.state,
    ROUND(AVG(DATEDIFF(
        o.order_delivered_date, 
        o.order_purchase_date
    )), 1) AS avg_delivery_days,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_delivered_date IS NOT NULL
GROUP BY c.state
ORDER BY avg_delivery_days ASC;

-- Query 5: Revenue vs Freight Cost Analysis
SELECT 
    p.category_name,
    ROUND(SUM(oi.price), 2) AS revenue,
    ROUND(SUM(oi.freight_value), 2) AS freight_cost,
    ROUND(
        SUM(oi.freight_value) / SUM(oi.price) * 100, 2
    ) AS freight_percentage
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category_name
ORDER BY freight_percentage DESC;

-- Query 6: Order Status Breakdown
SELECT 
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Query 7: Week-over-Week Growth (using Window Function)
WITH weekly_revenue AS (
    SELECT 
        YEARWEEK(order_purchase_date) AS week,
        ROUND(SUM(oi.price), 2) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY week
)
SELECT 
    week,
    revenue,
    LAG(revenue) OVER (ORDER BY week) AS prev_week_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY week)) 
        / LAG(revenue) OVER (ORDER BY week) * 100, 2
    ) AS wow_growth_percent
FROM weekly_revenue;

-- Query 8: Top States by Revenue
SELECT 
    c.state,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT o.customer_id) AS unique_customers
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.state
ORDER BY total_revenue DESC
LIMIT 10;

-- Query 9: Repeat vs One-Time Customers
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM orders
    GROUP BY customer_id
) sub
GROUP BY customer_type;

-- Query 10: Best Sales Day of the Week
SELECT 
    DAYNAME(o.order_purchase_date) AS day_of_week,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(oi.price), 2) AS avg_order_value
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
GROUP BY day_of_week
ORDER BY total_orders DESC;


