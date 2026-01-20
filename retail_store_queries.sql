
-- retail_store_queries.sql
-- SQL queries for retail_store analysis

-- 1. Total sales amount per region (last quarter)
SELECT 
    Region,
    SUM(TotalAmount) AS total_sales
FROM retail_store
WHERE Date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY Region
ORDER BY total_sales DESC;

-- 2. Top 5 best-selling products (by revenue)
SELECT 
    ProductName,
    SUM(TotalAmount) AS revenue
FROM retail_store
GROUP BY ProductName
ORDER BY revenue DESC
LIMIT 5;

-- 3. Monthly sales trend across all regions
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SUM(TotalAmount) AS monthly_sales
FROM retail_store
GROUP BY month
ORDER BY month;

-- 4. Region-wise contribution to total sales (%)
SELECT 
    Region,
    SUM(TotalAmount) AS region_sales,
    ROUND(
        SUM(TotalAmount) * 100.0 / SUM(SUM(TotalAmount)) OVER (),
        2
    ) AS sales_percentage
FROM retail_store
GROUP BY Region
ORDER BY sales_percentage DESC;

-- 5. Online vs Offline sales comparison (monthly)
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS month,
    SalesChannel,
    SUM(TotalAmount) AS total_sales
FROM retail_store
GROUP BY month, SalesChannel
ORDER BY month, SalesChannel;

-- 6. Sales trend by Category with MoM change
SELECT
    month,
    Category,
    category_sales,
    category_sales - LAG(category_sales)
        OVER (PARTITION BY Category ORDER BY month) AS sales_change
FROM (
    SELECT 
        DATE_FORMAT(Date, '%Y-%m') AS month,
        Category,
        SUM(TotalAmount) AS category_sales
    FROM retail_store
    GROUP BY month, Category
) t;

-- 7. Customers who purchased more than 10 times
SELECT 
    CustomerID,
    COUNT(TransactionID) AS purchase_count
FROM retail_store
GROUP BY CustomerID
HAVING COUNT(TransactionID) > 10
ORDER BY purchase_count DESC;
