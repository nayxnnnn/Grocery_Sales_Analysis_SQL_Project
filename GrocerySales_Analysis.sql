----------------------------------------DATA CLEANING--------------------------------------------------

SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM products;
SELECT * FROM categories;
SELECT * FROM cities;
SELECT * FROM countries;
SELECT * FROM sales;


--- CHECKING NULL VALUES ---

SELECT COUNT(*) 
FROM customers
WHERE customername IS NULL
      OR
      address IS NULL
      ;

SELECT COUNT(*) 
FROM employees
WHERE empname IS NULL
      OR
      birthdate IS NULL
      OR
      gender IS NULL
      OR 
      hiredate IS NULL
      ;

SELECT COUNT(*) 
FROM products
WHERE productname IS NULL
      OR
      price IS NULL
      OR
      level_type IS NULL
      OR
      modifydate IS NULL
      OR
      resistant IS NULL
      OR
      isallergic IS NULL
      OR
      vitalitydays IS NULL
      ;

SELECT COUNT(*) 
FROM categories
WHERE categoryid IS NULL
      OR
      categoryname IS NULL
      ;

SELECT COUNT(*) 
FROM cities
WHERE cityname IS NULL
      OR
      zipcode IS NULL
      ;

SELECT COUNT(*)
FROM countries
WHERE countryname IS NULL 
      OR
      countrycode IS NULL
      ;

SELECT COUNT(*) 
FROM sales
WHERE quantity IS NULL
      OR
      discount IS NULL
      OR
      totalprice IS NULL
      OR
      salesdate IS NULL
      OR
      transactionnumber IS NULL
      ;

-----HANDLING NULL VALUES IN SALES TABLE -----

WITH PreviousDates AS (
  SELECT 
    SalesID,
    SalesDate,
    LAG(SalesDate) OVER (ORDER BY SalesID) AS PrevDate
  FROM Sales
)
UPDATE Sales
SET SalesDate = pd.PrevDate
FROM PreviousDates pd
WHERE Sales.SalesID = pd.SalesID
  AND Sales.SalesDate IS NULL;

-------------DATA MODIFICATION IN PRODUCTS TABLE ---------------------------------------

ALTER TABLE products ADD FOREIGN KEY (categoryid) REFERENCES categories(categoryid);
ALTER TABLE products ALTER COLUMN productname TYPE varchar(50);

UPDATE products SET price = 80 WHERE productname = 'Bread Crumbs - Japanese Style';
UPDATE products SET price = 67 WHERE productname = 'Apricots - Halves';
UPDATE products SET price = 75 WHERE productname = 'Pastry - Raisin Muffin - Mini';


 -----------------PERFORMING EXPLORATORY DATA ANALYSIS-------------

/*
--- Basic data Retrieval
1) list all customers with their city and country. 
*/
SELECT c.customerid,c.customername, ct.cityname, cty.countryname
FROM customers c 
JOIN cities ct
ON c.cityid = ct.cityid
JOIN countries cty
ON ct.countryid = cty.countryid;

/*
---- Basic data Retrieval---
2) Retrieve all products with their categories and prices.
*/
SELECT p.productname, ctg.categoryname, p.price 
FROM products p 
JOIN categories ctg
ON p.categoryid = ctg.categoryid;

/*
---- Basic data Retrieval ---
3) Get total sales amount for each sale transaction.
*/
CREATE INDEX idx_sales_productid ON sales(productid);
CREATE INDEX idx_products_productid ON products(productid);

UPDATE sales
SET totalprice = p.price * sales.quantity
FROM products p
WHERE sales.productid = p.productid;

SELECT transactionnumber, SUM(totalprice) AS total_sales_amount 
FROM sales
GROUP BY transactionnumber;


/*
---- Top Products Identification ----
---- Ranking & Top - N analysis , Sales Performance Analysis ---
4) Find the top 5 products by total quantity sold.
*/
SELECT p.productname, SUM(s.quantity) AS total_quantity_sold
FROM sales s 
JOIN products p ON p.productid = s.productid
GROUP BY p.productname 
ORDER BY total_quantity_sold DESC 
LIMIT 5;


/*
---- Monthly Sales Performance ----
---- Aggregations & Grouping ----
---- Change-over-time trends ---
5) Show total sales revenue by month.
*/
SELECT TO_CHAR(salesdate, 'yyyy-mm') AS monthly,
       SUM(totalprice) AS sales_revenue 
FROM sales 
GROUP BY TO_CHAR(salesdate, 'yyyy-mm')
ORDER BY monthly;


/*
---- Magnitude , Geographical Sales Insights ---
6) Count the number of sales transactions per city.
*/
SELECT COUNT(s.transactionnumber) AS number_of_sales, ct.cityname
FROM sales s
JOIN customers c ON s.customerid = c.customerid
JOIN cities ct ON c.cityid = ct.cityid
GROUP BY ct.cityname
ORDER BY number_of_sales DESC;


/*
--- Customer Purchase Behavior---
7) Find customers who made more than 3 purchases.
*/
SELECT 
    c.customerid,
    c.customername,
    COUNT(*) AS total_purchases
FROM sales s
JOIN customers c ON s.customerid = c.customerid
GROUP BY c.customerid, c.customername
HAVING COUNT(*) > 3
ORDER BY total_purchases DESC;



/*
---- Magnitude , Aggregations & Grouping ---
8) Calculate total sales revenue and quantity sold per product category.
*/
SELECT ctg.categoryname,
       SUM(totalprice) AS total_sales_revenue,
       SUM(quantity) AS total_quantity_sold
FROM sales s
JOIN products p ON p.productid = s.productid
JOIN categories ctg ON ctg.categoryid = p.categoryid
GROUP BY ctg.categoryname
ORDER BY total_sales_revenue DESC;



/*
---- Salesperson Effectiveness -----
---- Ranking & Top-N Analysis , Sales Performance Analysis ----
9) Rank employees by total sales revenue.
*/
SELECT e.employeeid, e.empname,
       SUM(s.totalprice) AS total_sales_revenue,
       RANK() OVER (ORDER BY SUM(s.totalprice) DESC) AS revenue_rank
FROM employees e
JOIN sales s ON e.employeeid = s.employeeid
GROUP BY e.employeeid, e.empname
ORDER BY revenue_rank;



/*
---- Trend & Time Series Analysis, Category Performance Analysis ----
---- Monthly Sales Performance ----
10) Find monthly sales trends for top 3 product categories.
*/
WITH top_categories AS (
    SELECT ctg.categoryid,
           ctg.categoryname,
           SUM(s.totalprice) AS total_sales
    FROM categories ctg
    JOIN products p ON ctg.categoryid = p.categoryid
    JOIN sales s ON p.productid = s.productid
    GROUP BY ctg.categoryid, ctg.categoryname
    ORDER BY total_sales DESC
    LIMIT 3
)
SELECT tc.categoryname,
       TO_CHAR(s.salesdate, 'YYYY-MM') AS month,
       SUM(s.totalprice) AS total_sales
FROM top_categories tc
JOIN products p ON tc.categoryid = p.categoryid
JOIN sales s ON p.productid = s.productid
GROUP BY tc.categoryname, TO_CHAR(s.salesdate, 'YYYY-MM')
ORDER BY month, tc.categoryname;



/*
---- Aggregations & Grouping ----
11) Identify products with stock quantity below a threshold (ex. 10).
*/ 
SELECT p.productid,
       p.productname,
       s.quantity
FROM products p
JOIN sales s ON p.productid = s.productid
WHERE s.quantity < 10
GROUP BY p.productid, p.productname, s.quantity
ORDER BY s.quantity DESC;



/*
---- Customer Segmentation & Behavior----
12) List customers who bought products from more than 2 different categories.
*/
SELECT c.customerid,
       c.customername,
       COUNT(DISTINCT cat.categoryid) AS category_count
FROM sales s
JOIN products p ON s.productid = p.productid
JOIN categories cat ON p.categoryid = cat.categoryid
JOIN customers c ON s.customerid = c.customerid
GROUP BY c.customerid, c.customername
HAVING COUNT(DISTINCT cat.categoryid) > 2;


/*
---- Aggregations & Grouping ----
---- Salesperson Effectiveness ----
13) Show average discount given per employee.
*/
SELECT e.employeeid,
       e.empname,
       ROUND(AVG(s.discount), 2) AS avg_discount_given
FROM sales s
JOIN employees e ON s.employeeid = e.employeeid
GROUP BY e.employeeid, e.empname
ORDER BY avg_discount_given DESC;



/*
---- Customer Purchase Behavior ----
14) Find repeat customers and their total purchase amounts.
*/
SELECT customerid,
       customername,
       total_purchase,
       total_amount
FROM (
    SELECT c.customerid,
           c.customername,
           COUNT(s.salesid) AS total_purchase,
           SUM(s.totalprice) AS total_amount
    FROM sales s
    JOIN customers c ON s.customerid = c.customerid
    GROUP BY c.customerid, c.customername
) AS customer_summary
WHERE total_purchase > 1;



/*
---- Customer Purchase Behavior,Magnitude ----
15) Calculate average basket size per customer.
*/
SELECT c.customerid,
       c.customername,
       ROUND(SUM(s.quantity) * 1.0 / COUNT(DISTINCT s.salesid), 2) AS avg_basket_size
FROM sales s
JOIN customers c ON s.customerid = c.customerid
GROUP BY c.customerid, c.customername
ORDER BY customerid DESC;



/*
---- Customer Segmentation & Behavior,Customer Lifetime Value (CLV) Analysis----
16) Calculate customer lifetime value (clv) based on total spending and purchase frequency.
*/
SELECT c.customerid,
       c.customername,
       COUNT(s.salesid) AS purchase_count,
       SUM(s.totalprice) AS total_spent,
       ROUND(SUM(s.totalprice) * 1.0 / COUNT(s.salesid), 2) AS avg_purchase_value,
       ROUND((SUM(s.totalprice) * 1.0 / COUNT(s.salesid)) * COUNT(s.salesid), 2) AS customer_lifetime_value
FROM sales s
JOIN customers c ON s.customerid = c.customerid
GROUP BY c.customerid, c.customername
ORDER BY customer_lifetime_value DESC;



/*
---- Geographical Sales Insights----
---- Proportional Analysis , Sales Distribution Analysis ----
17) Analyze sales performance by city and country with percentage contribution to total sales.
*/
SELECT cty.countryname,
       ct.cityname,
       SUM(s.totalprice) AS total_sales,
       ROUND(
           SUM(s.totalprice) * 100.0 /
           (SELECT SUM(totalprice) FROM sales),
           2
       ) || '%' AS sales_percentage
FROM sales s
JOIN customers c ON s.customerid = c.customerid
JOIN cities ct ON c.cityid = ct.cityid
JOIN countries cty ON ct.countryid = cty.countryid
GROUP BY cty.countryname, ct.cityname
ORDER BY total_sales DESC;



/*
---- Sales & Discount Impact Analysis ----
---- Top Products Identification , Data Segmentation----
18) Analyze sales quantity and revenue impact due to discounts.
*/
SELECT CASE 
           WHEN discount = 0 THEN 'No Discount'
           WHEN discount BETWEEN 0.01 AND 0.10 THEN '0–10%'
           WHEN discount BETWEEN 0.11 AND 0.20 THEN '11–20%'
           WHEN discount > 0.20 THEN '20%+'
       END AS discount_range,
       COUNT(*) AS transactions,
       SUM(quantity) AS total_quantity,
       SUM(totalprice) AS total_revenue,
       ROUND(AVG(totalprice), 2) AS avg_order_value
FROM sales
GROUP BY discount_range
ORDER BY discount_range;



/*
----  Trend & Time Series Analysis ----
---- Monthly Sales Performance ----
19) Determine product seasonality by analyzing monthly sales variations over the 4-month period.
*/
SELECT p.productname,
       TO_CHAR(s.salesdate, 'YYYY-MM') AS month,
       SUM(s.quantity) AS total_quantity
FROM sales s
JOIN products p ON s.productid = p.productid
WHERE s.salesdate BETWEEN '2018-01-01' AND '2018-05-01'
GROUP BY p.productname, TO_CHAR(s.salesdate, 'YYYY-MM')
ORDER BY p.productname, month;



/*
---- Advanced Analytical Techniques ----
20) Find pairs of products frequently bought together (market basket analysis).
*/
SELECT p1.productid AS product1,
       p2.productid AS product2,
       COUNT(*) AS times_bought_together
FROM sales p1
JOIN sales p2 ON p1.salesid = p2.salesid 
               AND p1.productid < p2.productid
GROUP BY p1.productid, p2.productid
ORDER BY times_bought_together DESC
LIMIT 10;
/* This query returns 0 rows, it confirms that sales table likely
has only one product per salesid (All sales have 1 item) */



/* ---Advanced Analytics Techniques ---
21) Which pairs of products are most frequently bought by the same customers?
  (Customer - level Analysis)
*/
SELECT s1.productid AS product1,
       s2.productid AS product2,
       COUNT(*) AS times_bought_together
FROM sales s1
JOIN sales s2 
  ON s1.customerid = s2.customerid
 AND s1.productid < s2.productid
GROUP BY s1.productid, s2.productid
ORDER BY times_bought_together DESC
LIMIT 10;



/*
----  Trend & Time Series Analysis ----
21) Create a sales forecast using sql window functions over previous months sales.
*/
SELECT productid,
       DATE_TRUNC('month', salesdate) AS sales_month,
       SUM(totalprice) AS total_sales,
       AVG(SUM(totalprice)) OVER (
           PARTITION BY productid
           ORDER BY DATE_TRUNC('month', salesdate)
           ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING
       ) AS forecast_next_month_sales
FROM sales
GROUP BY productid, DATE_TRUNC('month', salesdate)
ORDER BY productid, sales_month;



/*
---- Customer Segmentation & Behavior ----
22) Calculate the average time between purchases for each customer.
*/
WITH diff_dates AS (
    SELECT customerid,
           salesdate,
           salesdate - LAG(salesdate) OVER (PARTITION BY customerid ORDER BY salesdate) AS gap
    FROM sales
	)
SELECT customerid,
       ROUND(AVG(gap), 0) AS avg_days_between_purchases
FROM diff_dates
WHERE gap IS NOT NULL
GROUP BY customerid;


------ END OF REPORTS ------
