-- Analytics on Gold Layer

-- Total Sales by Category:
-- Problem: Find the total sales amount for each category of items.

SELECT I.Item_name,
       SUM(S.Total_amount) AS Amount_per_item
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_items AS I on S.Item_sk = I.Item_id
GROUP BY Item_name 
ORDER BY Amount_per_item DESC;

-- Top 10 Best-Selling Items:
-- Problem: Identify the top 10 items based on the quantity sold.

SELECT I.Item_name,
       SUM(S.Quantity) AS Quantity_per_item
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_items AS I on S.Item_sk = I.Item_id
GROUP BY Item_name 
ORDER BY Quantity_per_item DESC LIMIT 10;


-- Monthly Sales Trend:
-- Problem: Analyze the sales trend on a monthly basis for the past year.
SELECT SUM(Total_amount) AS Revenue_per_month, MONTHNAME(Date) as MONTH
FROM gold_fact_sales 
WHERE Date >= date_sub(curdate(), interval 1 YEAR)
GROUP BY MONTH
ORDER BY Revenue_per_month DESC;



--  Sales by Location:
-- Problem: Determine the total sales amount for each location.

SELECT  L.Location_name,
		SUM(S.Total_amount) as Revenue_per_location
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id
GROUP BY Location_name
ORDER BY Revenue_per_location DESC;


--   Customer Purchase Frequency:
-- Problem: Find the number of purchases made by each customer.

SELECT C.Customer_name,
        COUNT(C.Customer_name) AS Purchase_Count
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
GROUP BY Customer_name
ORDER BY Purchase_Count DESC ;


-- Average Order Value (AOV):
-- Problem: Calculate the average order value for each location.
SELECT  L.Location_name,
		AVG(S.Total_amount) as AOV
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id
GROUP BY Location_name
ORDER BY AOV DESC;


--  Revenue Contribution by Membership Status:
-- Problem: Analyze the revenue contribution by different customer membership statuses.

SELECT  C.Membership_status,
		SUM(S.Total_amount) AS Revenue_per_membership
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
GROUP BY Membership_status
ORDER BY Revenue_per_membership DESC ;

--  Product Performance in Different Locations:
-- Problem: Find out how each product category performs in different locations.

SELECT L.Location_name, I.Item_name,
SUM(S.Quantity) as Total_quantity
FROM gold_fact_sales AS S
LEFT JOIN gold_dim_items AS I on S.Item_sk = I.Item_id
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id
GROUP BY Item_name, Location_name
ORDER BY Item_name ASC, Total_quantity DESC;

--  Customer Retention Analysis:
-- Problem: Identify customers who made purchases in both the first half and the second half of the year.

SELECT C.Customer_name
FROM  gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
WHERE YEAR(S.date) = '2023' AND (MONTH(S.Date)  BETWEEN 1 AND 6) 
AND C.Customer_name in 
(SELECT C.Customer_name
FROM  gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
WHERE YEAR(S.date) = '2023' AND (MONTH(S.Date) BETWEEN 7 AND 12));


--  Promotion Effectiveness:
-- Problem: Evaluate the effectiveness of promotions by comparing sales during promotional periods with non-promotional periods.

SELECT 'Promotional Period' AS Period,
    AVG(Total_amount) AS AVG_Sales
FROM Gold_fact_sales
WHERE MONTH(Date) BETWEEN 10 AND 12 
UNION 
SELECT 'Non-Promotional Period' AS Period,
    AVG(Total_amount) AS AVG_Sales
FROM Gold_fact_sales
WHERE MONTH(Date) NOT BETWEEN 10 AND 12;



--  all the  details of  transactions
SELECT C.Customer_name,
	   IFNULL(C.Membership_status, -1) AS Membership_status,
	   IFNULL(I.Item_name,-1) AS Item_name,
       L.Location_name, L.City,
       S.Quantity, S.Price_per_unit, S.Date, S.Total_amount
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
LEFT JOIN gold_dim_items AS I on S.Item_sk = I.Item_id
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id;


-- number of Orders per city 
SELECT COUNT(S.Sales_sk) as Orders_per_city, L.City
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id
GROUP BY City;

-- number of ORDERS per Location
SELECT COUNT(S.Sales_sk) as Orders_per_Location, L.Location_name, L.City
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id
GROUP BY Location_name, City
ORDER BY Orders_per_Location DESC ;

--  Ranking the Transaction per customers on the basis of total_amount they have spent partition by  different Cities.

SELECT C.Customer_name, C.Membership_status,
	   I.Item_name,
       L.Location_name, L.City,
       S.Quantity, S.Price_per_unit, S.Date, S.Total_amount,
       RANK() over (PARTITION BY City ORDER BY Total_amount DESC) AS Ranking
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
LEFT JOIN gold_dim_items AS I on S.Item_sk = I.Item_id
LEFT JOIN gold_dim_locations AS L On S.Location_sk = L.Location_id;

-- Finding the amount spent by every customer 
-- and number of transaction per customer
-- and average amount spent by every customer per transaction
SELECT C.Customer_name,
	    SUM(S.Total_amount) AS Amount_spent,
        COUNT(C.Customer_name) AS transaction_per_customer,
        AVG(S.Total_amount) as avg_amount_per_transaction
       FROM gold_fact_sales AS S
LEFT JOIN gold_dim_customers AS C on S.Customer_sk = C.Customer_id
GROUP BY Customer_name
ORDER BY Amount_spent DESC ;


-- Finding revenue per year 
SELECT SUM(Total_amount) AS Revenue_per_year, YEAR(Date) as Year
FROM gold_fact_sales 
GROUP BY YEAR(Date);

-- Finding revenue per Month 
SELECT SUM(Total_amount) AS Revenue_per_year, MONTHNAME(Date) as MONTH
FROM gold_fact_sales 
GROUP BY MONTHNAME(Date)
ORDER BY Revenue_per_year DESC;

-- Counting which membership is taken most by customers
SELECT COUNT(Customer_name) AS membership_count, Membership_status
FROM gold_dim_customers
GROUP BY Membership_status; 

















