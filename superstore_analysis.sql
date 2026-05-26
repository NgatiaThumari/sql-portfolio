-- ================================================
-- PROJECT: Superstore Sales Analysis
-- Author:  Ngatia Thumari
-- Date:    May 2026
-- Dataset: Superstore Final Dataset (Kaggle)
-- ================================================


-- ================================================
-- LEVEL 1: BEGINNER QUERIES
-- ================================================

-- Q1: First Class shipments (first 20 rows)
SELECT * FROM superstore_final
WHERE ship_mode = 'First Class'
LIMIT 20;

-- Q2: West region customers sorted by total sales
SELECT customer_name, city, state, 
  ROUND(SUM(sales), 2) AS total_sales
FROM superstore_final
WHERE region = 'West'
GROUP BY customer_name, city, state
ORDER BY total_sales DESC;


-- ================================================
-- LEVEL 2: INTERMEDIATE QUERIES
-- ================================================

-- Q3: Total orders and revenue per region
SELECT region, 
  COUNT(order_id) AS orders, 
  ROUND(SUM(sales), 2) AS total_revenue
FROM superstore_final
GROUP BY region
ORDER BY total_revenue DESC;

-- Q4: Category performance summary
SELECT category, 
  ROUND(SUM(sales), 2) AS total_sales, 
  ROUND(AVG(sales), 2) AS average_sale, 
  ROUND(MAX(sales), 2) AS highest_sale
FROM superstore_final
GROUP BY category;

-- Q5: Orders per customer segment
SELECT segment, 
  COUNT(order_id) AS orders 
FROM superstore_final
GROUP BY segment
ORDER BY orders DESC;


-- ================================================
-- LEVEL 3: UPPER INTERMEDIATE QUERIES
-- ================================================

-- Q6: States with total sales above $50,000
SELECT state, 
  ROUND(SUM(sales), 2) AS total_sales 
FROM superstore_final
GROUP BY state
HAVING SUM(sales) > 50000
ORDER BY total_sales DESC;

-- Q7: Classifying orders into sales tiers
SELECT order_id, customer_name, 
  ROUND(sales, 2) AS sales,
  CASE
    WHEN sales >= 1000 THEN 'High Value'
    WHEN sales >= 500  THEN 'Mid Value'
    ELSE 'Low Value'
  END AS sales_tier
FROM superstore_final;


-- ================================================
-- LEVEL 4: ADVANCED QUERIES
-- ================================================

-- Q8: Orders above the overall average sale
SELECT customer_name, 
  ROUND(sales, 2) AS sales 
FROM superstore_final
WHERE sales > (SELECT AVG(sales) FROM superstore_final)
ORDER BY sales DESC;

-- Q9: Sub-category performance vs average
SELECT sub_category, 
  ROUND(SUM(sales), 2) AS total_sales,
  CASE
    WHEN SUM(sales) > (
      SELECT AVG(sub_total) 
      FROM (
        SELECT SUM(sales) AS sub_total
        FROM superstore_final
        GROUP BY sub_category
      ) AS sub_averages
    ) THEN 'Above Average'
    ELSE 'Below Average'
  END AS performance_label
FROM superstore_final
GROUP BY sub_category;


-- ================================================
-- LEVEL 5: INTERVIEW LEVEL QUERIES
-- ================================================

-- Q10: Monthly sales trend with performance label
SELECT 
  DATE_FORMAT(STR_TO_DATE(Order_Date, '%m/%d/%Y'), '%Y-%m') AS month,
  ROUND(SUM(sales), 2) AS total_sales,
  CASE
    WHEN SUM(sales) > 50000 THEN 'Strong'
    ELSE 'Weak'
  END AS month_label
FROM superstore_final
GROUP BY DATE_FORMAT(STR_TO_DATE(Order_Date, '%m/%d/%Y'), '%Y-%m')
ORDER BY month ASC;