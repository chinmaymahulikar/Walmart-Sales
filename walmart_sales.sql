CREATE DATABASE walmart_Sales;
USE walmart_Sales;

CREATE TABLE sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);


-- FEATURE ENGINEERING --

-- time_of_day

SELECT time,
(CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
        WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "AFTERNOON"
        ELSE "EVENING"
END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(10);

UPDATE sales
SET time_of_day = (
CASE 
	WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
	WHEN `time` BETWEEN "12:00:01" AND "16:00:00" THEN "AFTERNOON"
	ELSE "EVENING"
END
);

-- day_name
SELECT 
	date,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name
SELECT
	date,
    MONTHNAME(date) as month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- ----------------------------------------------------------------
-- -------------------------- GENERIC -----------------------------

-- Q1. How many unique cities does the data have?
SELECT COUNT(DISTINCT city) AS TOTAL_COUNT FROM sales;

-- They are:
SELECT DISTINCT city FROM sales;

-- Q2. In which city is each branch?
SELECT DISTINCT city, branch FROM sales;

-- ----------------------------------------------------------------
-- -------------------------- PRODUCT -----------------------------

-- Q3. How many unique product lines does the data have?
SELECT DISTINCT product_line FROM sales;
SELECT COUNT(DISTINCT product_line) FROM SALES;

-- Q4. What is the most common payment method?
SELECT payment_method, COUNT(payment_method) AS cnt FROM sales GROUP BY payment_method ORDER BY cnt DESC;

-- Q5. What is the most selling product line?
SELECT product_line, COUNT(product_line) AS cnt FROM sales GROUP BY product_line ORDER BY cnt DESC;

-- Q6. What is the total revenue by month?
SELECT month_name AS mon, SUM(total) AS total_revenue FROM sales GROUP BY mon ORDER BY total_revenue DESC;

-- Q7. What month had the largest COGS?
SELECT month_name as mon, SUM(cogs) AS cogs FROM sales GROUP BY mon ORDER BY cogs;

-- Q8. What product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue FROM sales GROUP BY product_line ORDER BY total_revenue DESC;

-- Q9. What is the city with the largest revenue?
SELECT city, SUM(total) AS total_revenue FROM sales GROUP BY city ORDER BY total_revenue DESC;

-- Q10. What product line had the largest VAT?
SELECT product_line, SUM(VAT) AS tax FROM sales GROUP BY product_line ORDER BY tax DESC;

-- Q11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT ROUND(AVG(quantity)) AS avg_qty FROM sales;
SELECT product_line,
CASE
	WHEN AVG(quantity) > 6 THEN "Good"
    ELSE "Bad"
END AS remark FROM sales GROUP BY product_line;

-- Q12. Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty FROM sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- Q13. What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) AS total_cnt FROM sales GROUP BY gender, product_line ORDER BY total_cnt DESC;

-- Q14. What is the average rating of each product line?
SELECT product_line, AVG(rating) as avg_rating FROM sales GROUP BY product_line;

-- ----------------------------------------------------------------
-- -------------------------- SALES -------------------------------

-- Q.1 Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) AS total_sales FROM sales WHERE day_name = "Monday" GROUP BY time_of_day;

-- Q.2 Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_rev FROM sales GROUP BY customer_type ORDER BY total_rev DESC;

-- Q.3 Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, AVG(VAT) AS tax FROM sales GROUP BY city ORDER BY tax DESC;

-- Q.4 Which customer type pays the most in VAT?
SELECT customer_type, AVG(VAT) AS tax FROM sales GROUP BY customer_type ORDER BY tax DESC;

-- ----------------------------------------------------------------
-- -------------------------- CUSTOMER ----------------------------

-- Q.1 How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;

-- Q.2 How many unique payment methods does the data have?
SELECT DISTINCT payment_method FROM sales;

-- Q.3 What is the most common customer type?
SELECT customer_type, COUNT(*) AS cnt FROM sales GROUP BY customer_type;

-- Q.5 What is the gender of most of the customers?
SELECT gender, COUNT(*) AS cnt FROM sales GROUP BY gender ORDER BY cnt DESC;

-- Q.6 What is the gender distribution per branch?
SELECT gender, COUNT(*) AS cnt FROM sales WHERE branch = "A" GROUP BY gender ORDER BY cnt DESC;
SELECT gender, COUNT(*) AS cnt FROM sales WHERE branch = "B" GROUP BY gender ORDER BY cnt DESC;
SELECT gender, COUNT(*) AS cnt FROM sales WHERE branch = "C" GROUP BY gender ORDER BY cnt DESC;

-- Q.7 Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales GROUP BY time_of_day ORDER BY avg_rating DESC;

-- Q.8 Which time of the day do customers give most ratings per branch?
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales WHERE branch = "A" GROUP BY time_of_day ORDER BY avg_rating DESC;
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales WHERE branch = "B" GROUP BY time_of_day ORDER BY avg_rating DESC;
SELECT time_of_day, AVG(rating) AS avg_rating FROM sales WHERE branch = "C" GROUP BY time_of_day ORDER BY avg_rating DESC;

-- Q.9 Which day fo the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating FROM sales GROUP BY day_name ORDER BY avg_rating DESC;

-- Q.10 Which day of the week has the best average ratings per branch?
SELECT day_name, AVG(rating) AS avg_rating FROM sales WHERE branch = "A" GROUP BY day_name ORDER BY avg_rating DESC;
