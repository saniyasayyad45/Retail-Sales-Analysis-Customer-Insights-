# Retail Sales Analysis & Customer Insights

## Project Overview

This project focuses on analyzing retail sales data using PostgreSQL to identify sales trends, understand customer purchasing behavior, and generate meaningful business insights.

The analysis uses SQL queries to explore transaction records, perform basic data cleaning, and answer business-related questions about product categories, customer demographics, monthly sales performance, and purchasing patterns.

The objective is to demonstrate how SQL can be used to transform raw retail transaction data into structured information that supports business decision-making.

## Project Objectives

- Inspect and understand the retail sales dataset.
- Identify and handle missing values.
- Explore customer and transaction information.
- Analyze sales performance across product categories.
- Understand customer purchasing patterns.
- Identify top-performing customers.
- Analyze monthly sales trends.
- Categorize transactions based on time of purchase.

## Tools & Technologies

- **Database:** PostgreSQL
- **Query Language:** SQL
- **Platform:** GitHub
- **Concepts:** Data Cleaning, Data Exploration, Aggregations, CTEs, Subqueries, Window Functions, and CASE Statements.

## Dataset

The project uses a retail sales transaction dataset containing information about:

| Column | Description |
|---|---|
| transactions_id | Unique transaction identifier |
| sale_date | Date of the transaction |
| sale_time | Time of the transaction |
| customer_id | Unique customer identifier |
| gender | Customer gender |
| age | Customer age |
| category | Product category |
| quantity | Quantity of products purchased |
| price_per_unit | Price per unit |
| cogs | Cost of goods sold |
| total_sale | Total transaction amount |

## Project Structure

```text
Retail-Sales-Analysis-Customer-Insights/
│
├── README.md
│
├── Retail Sales Analysis & Customer Insights.sql
│
└── SQL - Retail Sales Analysis_utf.csv
```

## Database Setup

### 1. Create the Database

```sql
CREATE DATABASE SQL_project_p1;
```

### 2. Create the Table

```sql
CREATE TABLE public.retail_sales
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

### 3. Import the Dataset

Import the retail sales CSV file into the `retail_sales` table using PostgreSQL or pgAdmin.

Ensure that the column names and data types match the table structure.

## Data Inspection & Cleaning

The initial analysis checks the number of records and examines sample rows.

```sql
SELECT COUNT(*) AS total_records
FROM public.retail_sales;

SELECT *
FROM public.retail_sales
LIMIT 10;
```

Missing values are identified across important columns before removing incomplete records.

```sql
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
```

Records containing NULL values are removed after inspection.

## Data Exploration

The dataset is explored to understand its basic structure.

**1. Total number of transactions**

```sql
SELECT COUNT(*) AS total_transactions
FROM public.retail_sales;
```

**2. Total number of unique customers**

```sql
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM public.retail_sales;
```

**3. Unique product categories**

```sql
SELECT DISTINCT category
FROM public.retail_sales;
```

## Business Questions & SQL Analysis

The following business questions were addressed using SQL.

### Q1. Retrieve all sales made on November 5, 2022.

```sql
SELECT *
FROM public.retail_sales
WHERE sale_date = '2022-11-05';
```

### Q2. Find Clothing transactions where the quantity sold was greater than or equal to 4 during November 2022.

```sql
SELECT *
FROM public.retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

### Q3. Calculate total sales and the number of orders for each product category.

```sql
SELECT
    category,
    SUM(total_sale) AS net_sales,
    COUNT(*) AS total_orders
FROM public.retail_sales
GROUP BY category
ORDER BY net_sales DESC;
```

### Q4. Find the average age of customers purchasing from the Beauty category.

```sql
SELECT
    ROUND(AVG(age), 2) AS average_customer_age
FROM public.retail_sales
WHERE category = 'Beauty';
```

### Q5. Identify transactions where the total sale amount is greater than 1000.

```sql
SELECT *
FROM public.retail_sales
WHERE total_sale > 1000;
```

### Q6. Calculate the number of transactions made by each gender across product categories.

```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM public.retail_sales
GROUP BY category, gender
ORDER BY category, gender;
```

### Q7. Identify the month with the highest average sale in each year.

```sql
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
```

### Q8. Find the top 5 customers based on their total sales.

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM public.retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### Q9. Calculate the number of unique customers purchasing from each product category.

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM public.retail_sales
GROUP BY category
ORDER BY category;
```

### Q10. Categorize transactions into Morning, Afternoon, and Evening shifts.

```sql
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
```

## SQL Concepts Practiced

| SQL Concept | Application |
|---|---|
| SELECT | Retrieving records |
| WHERE | Filtering transactions |
| IS NULL | Identifying missing values |
| DELETE | Removing incomplete records |
| DISTINCT | Finding unique values |
| COUNT() | Counting records and customers |
| SUM() | Calculating total sales |
| AVG() | Calculating average sales and age |
| GROUP BY | Aggregating data by category and gender |
| ORDER BY | Sorting query results |
| TO_CHAR() | Filtering transactions by month |
| EXTRACT() | Extracting year and hour from dates and times |
| CASE WHEN | Categorizing transactions into shifts |
| CTE | Organizing intermediate query results |
| Subqueries | Performing nested analysis |
| RANK() OVER() | Ranking monthly average sales |

## Areas of Analysis

The project explores the following business areas:

- **Sales Performance:** Understanding sales distribution across product categories.
- **Customer Insights:** Examining customer demographics and purchasing behavior.
- **Customer Segmentation:** Identifying customers based on their total purchase value.
- **Monthly Trends:** Comparing average transaction values across months and years.
- **Purchase Timing:** Understanding transaction distribution across different time shifts.

Specific numerical findings can be added after reviewing the actual query outputs.

## Conclusion

This project demonstrates the use of PostgreSQL for retail sales analysis, covering data inspection, data cleaning, exploratory analysis, and business problem-solving.

Through practical SQL queries, the project explores customer behavior, category-level sales performance, monthly trends, and transaction patterns.

It also provides hands-on experience with SQL concepts commonly used in Data Analyst and Business Analyst roles.

## How to Use This Project

1. Clone or download this GitHub repository.
2. Install PostgreSQL.
3. Create the database `SQL_project_p1`.
4. Create the `retail_sales` table using the provided schema.
5. Import the retail sales CSV dataset.
6. Open the `.sql` file in PostgreSQL or pgAdmin.
7. Execute the queries to explore the dataset and analyze the business questions.

## Author

**Saniya Sayyad**

Business Analyst

[LinkedIn](https://www.linkedin.com/in/saniyasayyad45/)
