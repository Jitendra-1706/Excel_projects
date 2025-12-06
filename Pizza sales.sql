select *
From pizza_sales;


create table pizza_sales_report
like pizza_sales;


select *
From pizza_sales_report;

insert pizza_sales_report
select * 
from pizza_sales;

select sum(total_price) as Total_Revenue
from pizza_sales_report; 


select sum(total_price) / count(distinct order_id) as Average_order_Value
from pizza_sales_report; 


select sum(quantity) as Total_Pizza_sold
from pizza_sales_report; 

select count(distinct order_id) as Total_Orders
from pizza_sales_report;


select sum(quantity) / count(distinct order_id) as avg_pizza_per_order 
from pizza_sales_report;

  -- Daily Trend for orders
SELECT 
    DAYNAME(STR_TO_DATE(order_date, '%Y-%m-%d')) AS order_day,
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales_report
GROUP BY 
    DAYNAME(STR_TO_DATE(order_date, '%Y-%m-%d'));



DESC pizza_sales_report;

-- Hourly sale for Total orders

SELECT order_time 
FROM pizza_sales_report 
;

SELECT 
    HOUR(STR_TO_DATE(order_time, '%H:%i:%s')) AS order_hour,
    COUNT(DISTINCT order_id) AS total_orders
FROM 
    pizza_sales_report
GROUP BY 
    HOUR(STR_TO_DATE(order_time, '%H:%i:%s'))
ORDER BY 
    order_hour;


-- Percent sales by pizza category   
SELECT pizza_category,
       ROUND(SUM(total_price) * 100 / SUM(SUM(total_price)) OVER (), 2) AS percent_sales_by_category
FROM pizza_sales_report
WHERE MONTH(order_date) = 3
GROUP BY pizza_category
order by 2 asc;


-- 1. Add a new DATE column
ALTER TABLE pizza_sales_report 
ADD COLUMN order_date_new DATE;

-- 2. Convert text into DATE and update
UPDATE pizza_sales_report
SET order_date_new = STR_TO_DATE(order_date, '%d-%m-%Y');

-- 3. (Optional) Drop old column and rename new one
ALTER TABLE pizza_sales_report DROP COLUMN order_date;

ALTER TABLE pizza_sales_report 
CHANGE COLUMN order_date_new order_date DATE;



SELECT pizza_size,
       ROUND(SUM(total_price) * 100 / SUM(SUM(total_price)) OVER (), 2) AS percent_sales_by_category
FROM pizza_sales_report
GROUP BY pizza_size
;


-- total pizza sold by pizza category 
select pizza_category , sum(quantity) as Total_Pizza_sold from pizza_sales_report
group by pizza_category;

-- top 5 best sellers by pizza sold
select pizza_name , sum(quantity)
from pizza_sales_report
group by pizza_name
order by 2 desc
limit 5
 ;


-- Bottom 5 worst sellers by pizza sold
select pizza_name , sum(quantity)
from pizza_sales_report
group by pizza_name
order by 2 
limit 5
 ;

