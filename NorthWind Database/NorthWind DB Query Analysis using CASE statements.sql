-- Case Statement application
--Application 1: Categorizing products as Low, Medium and Expensive based on its unit_price
select 
	product_id,
	unit_price,
	case
		when unit_price < 50 then 'Low'
		when unit_price between 50 and 200 then 'Medium'
		else 'Expensive'
	end as Bucket
from products;


--Application 2: Counting number of products based on category buckets
select 
	case
		when unit_price < 50 then 'Low'
		when unit_price between 50 and 200 then 'Medium'
		else 'Expensive'
	end as Bucket,
count(product_id)
from products
group by 1;


--1. Write a query to classify the product_ids into "Expensive" and "Affordable" using the following logic.
--Expensive: Unit_price above 100
--Affordable: Unit_price Below 100
--Expected Output: Product_id,unit_price and price_category. The output should be sorted in ascending order of product_id
select
	product_id,
	unit_price,
	case
		when unit_price<100 then 'Affordable'
		else 'Expensive'
	end as price_category
from
products
order by 1;


--2. Classify employees into 'Old' and 'Very old' category using following logic
--Birth Year > 1950: Old
--Birth Year < 1950: Very old
--Expected Output: Employee_id, Birth_year and Age_category. Sort the table on employee_id in ascending order
select
	employee_id,
	extract(year from birth_date),
	case 
		when extract(year from birth_date)>1950 then 'Old'
		else 'Very Old'
	end as age_category
from employees
order by 1;

--OR

select
	employee_id,
	extract(year from birth_date) as birth_year,
	case 
		when extract(year from birth_date)<1950 then 'Very Old'
	else 'Old'
	end as age_category
from employees
order by 1;


--3. Create a is_ship_region_present column that through true or false. True when ship_region is not null and False when ship_region is null
--Expected Output: Order_id, Ship_region, and is_ship_region_present. The output should be sorted by order_id in ascending order
select 
	order_id,
	ship_region,
	case 
		when ship_region is null then False
	else True
	end as is_ship_region_present
from orders
order by 1;


--4. From the data, create a column called is_shipped. It is going to be TRUE if shipping date is available. If shipping date is not available then its going to be FALSE
--Expected Output: order_id, order_date, shipped_date and is_shipped. The output should be sorted by order_id in ascending order
select 
	order_id,
	order_date,
	shipped_date,
	case 
		when shipped_date is null then False
		else True
	end as is_shiped
from orders
order by 1;


