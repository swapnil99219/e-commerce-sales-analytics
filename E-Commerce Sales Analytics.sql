-- Project: E-Commerce Sales & Customer Analytics
-- Q1. Total Revenue
SELECT SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered';

-- Q2. Total Orders
SELECT COUNT(*) AS total_orders
FROM orders;

-- Q3. Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

-- Q4. Total Products
SELECT COUNT(*) AS total_products
FROM products;



-- Q5. Average Order Value
SELECT AVG(order_total) AS avg_order_value
FROM (
SELECT o.order_id,
SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.order_id
) AS order_summary;


-- Q6. Top 5 Best-Selling Products
SELECT p.product_id,
p.product_name,
SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;


-- Q7. Highest Revenue Category
SELECT p.category,
SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 1;


-- Q8. Top 5 Valuable Customers
SELECT c.customer_id,
c.customer_name,
SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 5;



-- Q9. Month-by-Month Revenue Trend
SELECT DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month;


-- Q10. Highest Revenue City
SELECT c.city,
SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 1;



-- Q11. Customers Who Ordered More Than Once
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;


-- Q12. Customers Who Never Placed an Order
SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Q13. Customers Inactive in the Last 90 Days
SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING MAX(o.order_date) < CURDATE() - INTERVAL 90 DAY
    OR MAX(o.order_date) IS NULL;


-- Q14. Best-Selling Category by Quantity
SELECT
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY total_quantity_sold DESC
LIMIT 1;


-- Q15. Product Generating the Highest Revenue
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 1;


-- Q16. Product Generating the Lowest Revenue
SELECT
    p.product_id,
    p.product_name,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0) AS total_revenue
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o
    ON oi.order_id = o.order_id
    AND o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue ASC
LIMIT 1;


-- Q17. Average Number of Items per Order
SELECT
    AVG(item_count) AS avg_items_per_order
FROM (
    SELECT
        o.order_id,
        SUM(oi.quantity) AS item_count
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id
) AS order_summary;


-- Q18. Orders Worth More Than 10,000
SELECT
    o.order_id,
    SUM(oi.quantity * oi.unit_price) AS order_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY o.order_id
HAVING SUM(oi.quantity * oi.unit_price) > 10000
ORDER BY order_total DESC;


-- Q19. Customers with the Highest Average Order Value
SELECT
    c.customer_id,
    c.customer_name,
    AVG(order_summary.order_total) AS avg_order_value
FROM customers c
JOIN (
    SELECT
        o.order_id,
        o.customer_id,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_id, o.customer_id
) AS order_summary
    ON c.customer_id = order_summary.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY avg_order_value DESC
LIMIT 5;


-- Q20. Top 3 Cities by Revenue
SELECT
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 3;



-- Q21. Rank Customers by Total Revenue
SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(oi.quantity * oi.unit_price) DESC
    ) AS revenue_rank
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name;


-- Q22. Top-Selling Product in Each Category
WITH product_sales AS (
    SELECT
        p.category,
        p.product_id,
        p.product_name,
        SUM(oi.quantity) AS total_quantity_sold,
        ROW_NUMBER() OVER (
            PARTITION BY p.category
            ORDER BY SUM(oi.quantity) DESC
        ) AS rn
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.category, p.product_id, p.product_name
)
SELECT category, product_id, product_name, total_quantity_sold
FROM product_sales
WHERE rn = 1;


-- Q23. Cumulative Revenue by Order Date
WITH daily_sales AS (
    SELECT
        o.order_date,
        SUM(oi.quantity * oi.unit_price) AS daily_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_date
)
SELECT
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY order_date
    ) AS cumulative_revenue
FROM daily_sales
ORDER BY order_date;


-- Q24. Previous Order Date for Each Customer
SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_date
FROM orders
WHERE order_status = 'Delivered';


-- Q25. Next Order Date for Each Customer
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_order_date
FROM orders
WHERE order_status = 'Delivered';


-- Q26. Days Between Consecutive Orders
WITH customer_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
    WHERE order_status = 'Delivered'
)
SELECT
    customer_id,
    order_id,
    order_date,
    previous_order_date,
    DATEDIFF(order_date, previous_order_date) AS days_between_orders
FROM customer_orders
WHERE previous_order_date IS NOT NULL;


-- Q27. Top 3 Customers by Revenue
SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 3;


-- Q28. Product Contribution Percentage of Total Revenue
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.product_id, p.product_name
)
SELECT
    product_id,
    product_name,
    total_revenue,
    ROUND(
        total_revenue * 100.0 / SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_pct
FROM product_revenue
ORDER BY total_revenue DESC;


-- Q29. Month-over-Month Revenue Growth Percentage
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
),
sales_with_previous AS (
    SELECT
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_sales
)
SELECT
    sales_month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_percentage
FROM sales_with_previous
ORDER BY sales_month;


-- Q30. Highest-Value Order for Each Customer
WITH order_totals AS (
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        SUM(oi.quantity * oi.unit_price) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.customer_id, o.order_id, o.order_date
),
ranked_orders AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_total DESC
        ) AS rn
    FROM order_totals
)
SELECT
    customer_id,
    order_id,
    order_date,
    order_total
FROM ranked_orders
WHERE rn = 1;


-- Q31. Customer Lifetime Value (CLV)
SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS customer_lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY customer_lifetime_value DESC;


-- Q32. Repeat Purchase Rate (%)
WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(*) AS total_orders
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
)
SELECT
    ROUND(
        SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS repeat_purchase_rate_pct
FROM customer_orders;


-- Q33. New vs Returning Customers by Month
WITH customer_months AS (
    SELECT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
        MIN(DATE_FORMAT(order_date, '%Y-%m')) OVER (
            PARTITION BY customer_id
        ) AS first_order_month
    FROM orders
    WHERE order_status = 'Delivered'
)
SELECT
    sales_month,
    COUNT(DISTINCT CASE
        WHEN sales_month = first_order_month THEN customer_id
    END) AS new_customers,
    COUNT(DISTINCT CASE
        WHEN sales_month > first_order_month THEN customer_id
    END) AS returning_customers
FROM customer_months
GROUP BY sales_month
ORDER BY sales_month;


-- Q34. Monthly Active Customers
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders
WHERE order_status = 'Delivered'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY sales_month;


-- Q35. Customers Buying Products from Multiple Categories
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT p.category) AS categories_purchased
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT p.category) > 1
ORDER BY categories_purchased DESC;


-- Q36. Product Pairs Bought Together
SELECT
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(DISTINCT oi1.order_id) AS orders_bought_together
FROM order_items oi1
JOIN order_items oi2
    ON oi1.order_id = oi2.order_id
    AND oi1.product_id < oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
JOIN orders o ON oi1.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p1.product_name, p2.product_name
ORDER BY orders_bought_together DESC;


-- Q37. Average Days Between Orders per Customer
WITH customer_orders AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date
    FROM orders
    WHERE order_status = 'Delivered'
)
SELECT
    customer_id,
    ROUND(AVG(DATEDIFF(order_date, previous_order_date)), 2)
        AS avg_days_between_orders
FROM customer_orders
WHERE previous_order_date IS NOT NULL
GROUP BY customer_id
ORDER BY avg_days_between_orders;


-- Q38. Fastest-Growing Category by Monthly Revenue
WITH monthly_category_sales AS (
    SELECT
        p.category,
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.category, DATE_FORMAT(o.order_date, '%Y-%m')
),
category_growth AS (
    SELECT
        category,
        sales_month,
        monthly_revenue,
        LAG(monthly_revenue) OVER (
            PARTITION BY category
            ORDER BY sales_month
        ) AS previous_month_revenue
    FROM monthly_category_sales
)
SELECT
    category,
    sales_month,
    monthly_revenue,
    previous_month_revenue,
    ROUND(
        (monthly_revenue - previous_month_revenue) * 100.0
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS growth_pct
FROM category_growth
WHERE previous_month_revenue IS NOT NULL
ORDER BY growth_pct DESC;


-- Q39. Customers at Risk of Churning
SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS inactive_days
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
HAVING MAX(o.order_date) < CURDATE() - INTERVAL 90 DAY
ORDER BY inactive_days DESC;


-- Q40. RFM Analysis (Recency, Frequency, Monetary)
WITH customer_rfm AS (
    SELECT
        c.customer_id,
        c.customer_name,
        DATEDIFF(CURDATE(), MAX(o.order_date)) AS recency_days,
        COUNT(DISTINCT o.order_id) AS frequency,
        SUM(oi.quantity * oi.unit_price) AS monetary_value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY c.customer_id, c.customer_name
)
SELECT
    *,
    NTILE(5) OVER (ORDER BY recency_days DESC) AS recency_score,
    NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_score,
    NTILE(5) OVER (ORDER BY monetary_value ASC) AS monetary_score
FROM customer_rfm
ORDER BY monetary_value DESC;


-- Q41. Daily Sales Trend
SELECT
    DATE(o.order_date) AS sales_date,
    SUM(oi.quantity * oi.unit_price) AS daily_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE(o.order_date)
ORDER BY sales_date;


-- Q42. Top 10 Best-Selling Products by Quantity
SELECT
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- Q43. Top 10 Customers by Revenue
SELECT
    c.customer_id,
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Q44. Revenue by Gender
SELECT
    c.gender,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.gender
ORDER BY total_revenue DESC;


-- Q45. Customer Churn Rate (%)
WITH customer_activity AS (
    SELECT
        c.customer_id,
        MAX(o.order_date) AS last_order_date
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'Delivered'
    GROUP BY c.customer_id
)
SELECT
    ROUND(
        SUM(
            CASE
                WHEN last_order_date IS NULL
                  OR last_order_date < CURDATE() - INTERVAL 90 DAY
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate_pct
FROM customer_activity;


-- Q46. Order Cancellation Rate (%)
SELECT
    ROUND(
        SUM(CASE WHEN order_status = 'Cancelled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate_pct
FROM orders;


-- Q47. Delivered vs Cancelled Orders
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status IN ('Delivered', 'Cancelled')
GROUP BY order_status
ORDER BY total_orders DESC;


-- Q48. Worst-Selling Category by Quantity
SELECT
    p.category,
    COALESCE(SUM(
        CASE
            WHEN o.order_status = 'Delivered' THEN oi.quantity
            ELSE 0
        END
    ), 0) AS total_quantity_sold
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id
GROUP BY p.category
ORDER BY total_quantity_sold ASC
LIMIT 1;


-- Q49. Most Expensive Product Sold
SELECT
    p.product_id,
    p.product_name,
    MAX(oi.unit_price) AS highest_selling_price
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name
ORDER BY highest_selling_price DESC
LIMIT 1;


-- Q50. Month with the Highest Revenue
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY monthly_revenue DESC
LIMIT 1;




-- Q51. Number of New Customers Each Month
SELECT
    DATE_FORMAT(signup_date, '%Y-%m') AS signup_month,
    COUNT(*) AS new_customers
FROM customers
GROUP BY DATE_FORMAT(signup_date, '%Y-%m')
ORDER BY signup_month;


-- Q52. Category Contribution Percentage of Total Revenue
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    JOIN orders o
        ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.category
)
SELECT
    category,
    total_revenue,
    ROUND(
        total_revenue * 100.0
        / SUM(total_revenue) OVER (),
        2
    ) AS revenue_contribution_pct
FROM category_revenue
ORDER BY total_revenue DESC;

SHOW DATABASES;




