
-- RETAIL SALES ANALYSIS & CUSTOMER INSIGHTS

-- 1. DATA INSPECTION

-- Check the total number of records
SELECT COUNT(*) AS total_records
FROM public.retail_sales;

-- View the first 10 records
SELECT *
FROM public.retail_sales
LIMIT 10;


-- 2. DATA CLEANING

-- Identify records containing NULL values
SELECT *
FROM public.retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

-- Delete records containing NULL values
-- Run this only after reviewing the records above
DELETE FROM public.retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;


-- 3. DATA EXPLORATION

-- How many sales transactions are there?
SELECT COUNT(*) AS total_transactions
FROM public.retail_sales;

-- How many unique customers are there?
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM public.retail_sales;

-- What are the unique product categories?
SELECT DISTINCT category
FROM public.retail_sales;


-- 4. DATA ANALYSIS AND BUSINESS QUESTIONS

-- Q1. Retrieve all columns for sales made on 2022-11-05.

SELECT *
FROM public.retail_sales
WHERE sale_date = '2022-11-05';


-- Q2. Retrieve all transactions where the category is Clothing,
-- quantity sold is greater than or equal to 4,
-- and the transaction occurred in November 2022.

SELECT *
FROM public.retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;


-- Q3. Calculate total sales and total number of orders for each category.

SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM public.retail_sales
GROUP BY category
ORDER BY net_sales DESC;


-- Q4. Find the average age of customers who purchased items
-- from the Beauty category.

SELECT
    ROUND(AVG(age), 2) AS average_customer_age
FROM public.retail_sales
WHERE category = 'Beauty';


-- Q5. Find all transactions where the total sale amount is greater than 1000.

SELECT *
FROM public.retail_sales
WHERE total_sale > 1000;


-- Q6. Find the total number of transactions made by each gender
-- in each product category.

SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM public.retail_sales
GROUP BY category, gender
ORDER BY category, gender;


-- Q7. Calculate the average sale for each month
-- and find the month with the highest average sale in each year.

SELECT
    year,
    month,
    avg_sale
FROM
(
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS sales_rank
    FROM public.retail_sales
    GROUP BY
        EXTRACT(YEAR FROM sale_date),
        EXTRACT(MONTH FROM sale_date)
) AS monthly_sales
WHERE sales_rank = 1
ORDER BY year;


-- Q8. Find the top 5 customers based on their highest total sales.

SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM public.retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q9. Find the number of unique customers who purchased items
-- from each product category.

SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.retail_sales
GROUP BY category
ORDER BY category;


-- Q10. Classify transactions into Morning, Afternoon, and Evening shifts
-- based on sale_time and calculate the total number of orders in each shift.

WITH hourly_sale AS
(
    SELECT
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM public.retail_sales
)

SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift
ORDER BY
    CASE shift
        WHEN 'Morning' THEN 1
        WHEN 'Afternoon' THEN 2
        WHEN 'Evening' THEN 3
    END;
