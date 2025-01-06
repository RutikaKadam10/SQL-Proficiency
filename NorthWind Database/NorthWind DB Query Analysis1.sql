--Question 1. Using Orders table, write the query to count distinct customers who purchase anything from Northwind
--Expected Output: Single number denoting the distinct transacting customers
select count(distinct customer_id) from orders;


--Question 2. Get the details of the orders made by VINET, TOMSP, HANAR, VICTE, SUPRD, CHOPS from the orders table.
--Expected Output: Order_id, order_date, customer_id, Ship_country and Employee_id
select 
order_id,
order_date,
customer_id,
ship_country,
employee_id
from orders
where customer_id in ('VINET','TOMSP','HANAR','VICTE','SUPRD','CHOPS');


--Question 3. According to the customers table, list down the customer_ids which start from "L" and end at "S".
--Expected Output: Customer_id
select 
customer_id
from 
customers
where customer_id like 'L%S';

--Question 4. According to the customers table, list down the customer_ids of france which starts from “L”
--Expected Output: Customer_id
select 
customer_id
from 
customers
where country='France' and customer_id like 'L%';


--Question 5. The company is planning to give a 10% discount on products above 10 dollars price point(including). Get the list of the product_id which are going to be listed at discounted price
--Expected Output: Product_id
select
product_id
from products
where unit_price >= 10;


--Question 6. According to the products table, which category_ids have more than 500 units_in_stock?
--Expected Output: category_id, total units_in_stock
select 
category_id,
sum(units_in_stock) total_units
from products
group by category_id
having sum(units_in_stock)>500
order by 1;


--Question 7. According to the products table, list the supplier_ids responsible for supplying exactly 5 products from the list.
--Expected Output: supplier id, total products supplied
select 
supplier_id,
count(product_id)
from products
group by supplier_id
having count(product_id)=5;


--Question 8. Using the orders table, create a table where the count of orders placed would be mentioned against every customer_id.
--Expected Output: Customer_id, count of orders
select
customer_id,
count(order_id)
from orders
group by customer_id;


--Question 9. Using the orders table, create a table where the count of orders placed would be mentioned against every customer_id but only for customers having at least 10 orders.
--Expected Output: Customer_id, count of orders
select
customer_id,
count(order_id)
from orders
group by customer_id
having count(order_id)>=10;


--Question 10. The Order_Details table is unique at the order_id and product_id levels. It shows the various products ordered for every order_id. Northwind is using bigger boxes for orders having 6 or more product_ids. Can you extract the list of order ids along with the count of products ordered?
--Expected Output: Order_id, count of products
select
order_id,
count(product_id)
from order_details
group by order_id
having count(product_id)>=6;


--Question 11. Classify orders based on the total quantity of items purchased.
--If the total quantity is greater than 200, label it as "High."
--If the total quantity is between 100 and 200 (inclusive), label it as "Medium."
--If the total quantity is less than 100, label it as "Low."
--Expectated Output: order ID, total quantity, and the classification for each order.
select
	o.order_id,
	sum(od.quantity),
	case 
		when sum(od.quantity)>200 then 'High'
		when sum(od.quantity)<=200 and sum(od.quantity)>=100 then 'Medium'
		when sum(od.quantity)<100 then 'Low'
	end
from orders o 
inner join order_details od
on o.order_id=od.order_id
group by 1;


--Question 12: Find the category with the least number of products.
--Calculate the total number of products for each category.
--Rank the categories based on the product count in ascending order.
--Expectated Output: category name, product count for the category ranked first (i.e., the category with the least products).
with number_of_products_per_cate as(
	select
		c.category_name,
		count(product_id) as prod_count
	from products p
	inner join categories c
	on p.category_id=c.category_id
	group by 1
),
rank_data as(
	select *,
	rank() over(order by prod_count) as rk
	from number_of_products_per_cate
)
select * from rank_data where rk=1;


--Question 13. Identify first order id placed by every customer
--Expected Output: Customer_id, order_id
select
	customer_id,
	order_id
from(
select order_id, customer_id,
rank() over (partition by customer_id order by order_id)
from orders
) as T1
where rank=1;


--Question 14. Identify last order id placed by every customer
--Expected Output: Customer_id, order_id
with orderdata as (select order_id,
customer_id,
rank() over (partition by customer_id order by order_date desc) as order_rank
from orders)
select * from orderdata
where order_rank = 1;


--Question 15. Identify 2nd last order id placed by every customer.
--Expected Output: order_id, customer_id
with orderdata as (
	select order_id, customer_id,
	dense_rank() over (partition by customer_id order by order_date desc) as
	order_rank
	from orders)
select * from orderdata
where order_rank = 2;


--Question 16. Identify the country and customer id wise last order id.
--Expected Output: order_id, customer_id
with orderdata as (
	select order_id, customer_id,
	dense_rank() over (partition by customer_id, ship_country order by order_date
	desc) as order_rank
	from orders)
select * from orderdata
where order_rank = 1;


--Question 17. Identify the primary shipper for every country. Primary shipper means the shipping company who is delivering most orders in the country.
--Expected Output: ship_country, company_name, orders, ranks
with orderdata as (
	select ship_country,
		company_name,
		count(order_ID) as orders ,
	dense_rank() over (partition by ship_country order by
	count(order_ID) asc) as ranks
	from orders a
	left join shippers b
	on a.ship_via = b.shipper_id
	group by 1,2 )
select * from orderdata where ranks = 1;


--Question 18. Identify name of most expensive item for every category.
--Expected Output: category_name, product_name, unit_price, price_rank
with dataset as (
	select category_name,
		product_name,
		unit_price,
	rank() over (partition by category_name order by unit_price desc) as
	price_rank
	from products a
	left join categories b
	on a.category_id = b.category_id)
select * from dataset where price_rank = 1;


--Question 19. Identify the date difference between successive order dates for every
--customer. For example, if Rajat has placed 3 orders on 1 jan, 5 jan and 7th
--jan. Then Difference between first order and second order 4. difference
--between 2nd order and 3 order is 2 days.
with cust_order_rank as (
	select
		customer_id,
		order_date,
	rank() over (partition by customer_id order by order_date) as
	order_rank
	from orders)
select
A.customer_id,
A.order_date as previous_Date,
B.order_date as next_date,
B.order_date-A.order_date as datedifference
from cust_order_rank a
left join cust_order_rank b
on a.customer_id = b.customer_id and a.order_rank = b.order_rank-1
and B.order_date is not null;


--Question 20. Write a SQL query to retrieve the first names of employees and their respective managers.
select 
	e.first_name Employee_name, 
	m.first_name Manager_name
from employees as e
join employees as m
on e.reports_to=m.employee_id;