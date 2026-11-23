# Retail Sales Analysis & Customer Insights

## Project Overview

**Project Title:** Retail Sales Analysis & Customer Insights  
**Level:** Beginner  
**Database:** `SQL_project_p1`  
**Database Management System:** PostgreSQL  
**Language:** SQL

This project focuses on analyzing retail sales data using PostgreSQL. It demonstrates SQL skills and techniques commonly used by data analysts to inspect, clean, explore, and analyze transactional data.

The project involves setting up a retail sales database, performing data cleaning and exploratory data analysis (EDA), and answering business-related questions using SQL queries.

The objective is to understand sales performance, customer purchasing patterns, product category performance, and transaction trends through SQL.

## Objectives

1. **Database Setup:** Create and populate a retail sales database using the provided dataset.
2. **Data Inspection:** Examine the dataset structure and understand the available records.
3. **Data Cleaning:** Identify and handle records containing missing or NULL values.
4. **Exploratory Data Analysis (EDA):** Explore customer information, sales transactions, and product categories.
5. **Business Analysis:** Use SQL queries to answer business questions and understand retail sales patterns.

## Tools & Technologies

- PostgreSQL
- SQL
- pgAdmin / PostgreSQL Terminal
- GitHub

## Project Structure

### 1. Database Setup

The project uses a PostgreSQL database named `SQL_project_p1` and a table named `retail_sales` to store the transaction data.

The table contains information about transaction IDs, sale dates, sale times, customer details, product categories, quantities, prices, costs, and total sales.

**Table Structure:**

```sql
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Inspection

The first step was to inspect the dataset and understand its structure.

The following queries were used to:

- Check the total number of records.
- View sample records from the dataset.
- Understand the available columns and data.

```sql
-- Check the total number of records
SELECT COUNT(*) AS total_records
FROM public.retail_sales;

-- View the first 10 records
SELECT *
FROM public.retail_sales
LIMIT 10;
```

### 3. Data Cleaning

Data cleaning was performed to identify records containing missing values.

The process involved:

- Checking for NULL values across relevant columns.
- Identifying incomplete records.
- Removing records containing missing values from the analysis table.

```sql
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

-- Remove records containing NULL values
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
```

### 4. Exploratory Data Analysis (EDA)

Exploratory Data Analysis was performed to understand the overall dataset and identify basic patterns.

The analysis included:

- Calculating the total number of sales transactions.
- Finding the number of unique customers.
- Identifying unique product categories.

```sql
-- Total number of sales transactions
SELECT COUNT(*) AS total_transactions
FROM public.retail_sales;

-- Number of unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM public.retail_sales;

-- Unique product categories
SELECT DISTINCT category
FROM public.retail_sales;
```

### 5. Data Analysis & Business Questions

The following SQL queries were developed to answer business questions related to sales, customers, product categories, and transaction patterns.

**Q1. Retrieve all columns for sales made on November 5, 2022.**

```sql
SELECT *
FROM public.retail_sales
WHERE sale_date = '2022-11-05';
```

**Q2. Retrieve all transactions where the category is Clothing, the quantity sold is greater than or equal to 4, and the transaction occurred in November 2022.**

```sql
SELECT *
FROM public.retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

**Q3. Calculate total sales and total number of orders for each product category.**

```sql
SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM public.retail_sales
GROUP BY category;
```

**Q4. Find the average age of customers who purchased items from the Beauty category.**

```sql
SELECT
    ROUND(AVG(age), 2) AS average_customer_age
FROM public.retail_sales
WHERE category = 'Beauty';
```

**Q5. Retrieve all transactions where the total sale amount is greater than 1000.**

```sql
SELECT *
FROM public.retail_sales
WHERE total_sale > 1000;
```

**Q6. Calculate the total number of transactions made by each gender in each product category.**

```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM public.retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

**Q7. Calculate the average sale for each month and identify the month with the highest average sale in each year.**

```sql
SELECT
    year,
    month,
    ROUND(avg_sale, 2) AS average_sale
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
    GROUP BY 1, 2
) AS monthly_sales
WHERE sales_rank = 1
ORDER BY year;
```

**Q8. Identify the top 5 customers based on their total sales.**

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM public.retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

**Q9. Calculate the number of unique customers who purchased items from each category.**

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.retail_sales
GROUP BY category
ORDER BY category;
```

**Q10. Classify transactions into Morning, Afternoon, and Evening shifts and calculate the total number of orders in each shift.**

```sql
WITH hourly_sale AS
(
    SELECT
        *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12
                THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17
                THEN 'Afternoon'
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
```

## Key SQL Concepts Practiced

- **Filtering:** WHERE, AND, comparison operators
- **Aggregation:** SUM(), COUNT(), AVG(), ROUND()
- **Grouping:** GROUP BY, ORDER BY
- **Date and Time Functions:** TO_CHAR(), EXTRACT()
- **Subqueries:** Nested SELECT statements
- **Window Functions:** RANK(), PARTITION BY
- **Conditional Logic:** CASE WHEN
- **Common Table Expressions:** WITH clause
- **Distinct Values:** DISTINCT and COUNT(DISTINCT)

## Findings & Areas of Analysis

The project explores the following business areas:

- **Customer Demographics:** Examining customer age and gender information.
- **Sales Performance:** Comparing total sales and average transaction values across categories and months.
- **High-Value Transactions:** Identifying transactions with a total sale amount greater than 1000.
- **Customer Insights:** Identifying top-spending customers and unique customers across product categories.
- **Sales Trends:** Examining monthly average sales and transaction patterns across different time shifts.

*Note: Specific numerical findings can be added after reviewing the actual query results.*

## Conclusion

This project provided practical experience in using SQL for retail sales analysis. It covered the complete analytical workflow, from inspecting and cleaning raw data to performing exploratory analysis and solving business-related questions.

Through this project, I practiced writing SQL queries using filtering, aggregation, grouping, subqueries, window functions, and CTEs.

The analysis demonstrates how SQL can help understand sales performance, customer purchasing patterns, and transaction trends to support data-driven business decisions.

## How to Use

1. Clone or download this GitHub repository.
2. Install PostgreSQL and open pgAdmin or the PostgreSQL terminal.
3. Create a database named `SQL_project_p1`.
4. Create the `retail_sales` table using the table structure provided above.
5. Import the retail sales CSV dataset into the table.
6. Open the `.sql` file available in this repository.
7. Execute the queries to perform data inspection, cleaning, EDA, and business analysis.

## Author

**Saniya Sayyad**

This project is part of my data analytics portfolio and demonstrates my practical understanding of SQL and PostgreSQL for solving business-oriented analytical problems.
