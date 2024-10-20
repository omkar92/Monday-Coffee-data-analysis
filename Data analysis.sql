-- Monday Coffee -- Data Analysis 
select * from city;
select * from customers;
select * from sales;
select * from products;

-- Reports & Data Analysis


-- Q.1 Coffee Consumers Count
-- How many people in each city are estimated to consume coffee, given that 25% of the population does?
select city_name
,population * 0.25 
from city
order by 2 desc;

-- -- Q.2
-- Total Revenue from Coffee Sales
-- What is the total revenue generated from coffee sales across all cities in the last quarter of 2023?
select 
sum(total) 
from sales
where 
EXTRACT (YEAR FROM sale_date ) = 2023
and 
EXTRACT (QUARTER FROM sale_date) = 4


select city_name, 
sum(total)
from sales
join customers
on sales.customer_id = customers.customer_id
join city
on city.city_id = customers.city_id
where 
EXTRACT (YEAR FROM sale_date ) = 2023
and 
EXTRACT (QUARTER FROM sale_date) = 4
GROUP BY 1
ORDER BY 2 desc;

-- Q.3
-- Sales Count for Each Product
-- How many units of each coffee product have been sold?

select 
product_name,
count(sale_id) as number_of_units
from 
products 
join
sales
on
products.product_id = sales.product_id
group by 1;

-- Q.4
-- Average Sales Amount per City
-- What is the average sales amount per customer in each city?
select 
city_name,
sum(sales.total)/count(distinct customers.customer_id)
from 
sales 
join 
customers
on 
sales.customer_id = customers.customer_id
join
city
on 
city.city_id = customers.customer_id
group by 1


order by 2 desc;

-- -- Q.5
-- City Population and Coffee Consumers (25%)
-- Provide a list of cities along with their populations and estimated coffee consumers.
-- return city_name, total current cx, estimated coffee consumers (25%)



select  city_name
,
city.population * 0.25,
count( distinct(customer_id))
from 
city
join customers on city.city_id = customers.city_id
group by city_name,2
order by 3 desc



-- -- Q6
-- Top Selling Products by City
-- What are the top 3 selling products in each city based on sales volume?
with cte as 
(
select city_name,
products
,count(sale_id) ,
RANK() OVER (PARTITION BY city_name order by count(sale_id) desc) 
from 
city 
join customers on customers.city_id = city.city_id
join sales on sales.customer_id = customers.customer_id
join products on products.product_id = sales.product_id
group by 1,2
)

select * from cte where rank <= 3



