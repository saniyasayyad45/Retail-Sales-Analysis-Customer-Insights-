SELECT COUNT(*)
FROM public.retail_sales;
SELECT *
FROM public.retail_sales
LIMIT 10;
--DATA CLEANING
SELECT * FROM retail_sales	 
WHERE 
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR 
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL
DELETE FROM retail_sales
WHERE
     transactions_id IS NULL
	 OR
	 sale_date IS NULL
	 OR
	 sale_time IS NULL
	 OR
	 gender IS NULL
	 OR 
	 category IS NULL
	 OR
	 quantiy IS NULL
	 OR
	 cogs IS NULL
	 OR
	 total_sale IS NULL
-- EXPLORATION
-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales
-- How many customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales
-- HOW many unique category?
SELECT DISTINCT category FROM retail_sales

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS
--Q.1 write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of NOV-22
SELECT *
FROM retail_sales
WHERE  category = 'Clothing'
   AND 
   TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
   AND
   quantiy>= 4
   

-- Q1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT *
FROM public.retail_sales
WHERE sale_date = '2022-11-05';


-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing', the quantity sold is greater than or equal to 4, and the transaction occurred in November 2022.
SELECT *
FROM public.retail_sales
WHERE category = 'Clothing'
AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantity >= 4;


-- Q3. Write a SQL query to calculate the total sales (total_sale) and total number of orders for each category.
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM public.retail_sales
GROUP BY category;


-- Q4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM public.retail_sales
WHERE category = 'Beauty';


-- Q5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM public.retail_sales
WHERE total_sale > 1000;


-- Q6. Write a SQL query to find the total number of transactions made by each gender in each category.
SELECT
    category,
    gender,
    COUNT(*) AS total_trans
FROM public.retail_sales
GROUP BY category, gender
ORDER BY category;


-- Q7. Write a SQL query to calculate the average sale for each month and find the best-selling month in each year based on the highest average sale.
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
        ) AS rank
    FROM public.retail_sales
    GROUP BY 1, 2
) AS t1
WHERE rank = 1;


-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM public.retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;


-- Q9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
    category,
    COUNT(DISTINCT customer_id) AS cnt_unique_cs
FROM public.retail_sales
GROUP BY category;


-- Q10. Write a SQL query to classify transactions into Morning, Afternoon, and Evening shifts based on sale_time and calculate the total number of orders in each shift.
WITH hourly_sale AS
(
    SELECT *,
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
GROUP BY shift;


	 