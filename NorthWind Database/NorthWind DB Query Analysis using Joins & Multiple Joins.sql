--Question 1. Orders table has order-level information but it doesn't have the customer name. Customer details are available in the customer table. To get the customer name, you need to join the table. Write a query to get order_id, customer_id and contact name (from customer_details)
--Expectated Output: order_id, customer_id, and contact name in exact same sequence. 
--Sort the output in ascending order of order-id
select
	o.order_id,
	o.customer_id,
	c.contact_name
from orders o
inner join customers c
on o.customer_id=c.customer_id
order by 1;


--Question 2. Orders table has order-level information but it doesn't have the employee first_name. Employee details are available in the employees table. To get the customer name, you need to join the table. Write a query to get order_id and first_name (from employees table)
--Expected Output: order_id, employee_id and first_name in exact same sequence. Sort the output in ascending order of order-id
select
	o.order_id,
	o.employee_id,
	e.first_name
from orders o
inner join employees e
on o.employee_id=e.employee_id
order by 1;


--Question 3: Write a query joining more then 2 tables. Write a query to get order_id, contact_name(from customers) and last_name(from employees)
--Expected Output: order_id, contact_name and last_name in exact same sequence. Sort the output in ascending order of order-id
select
	o.order_id,
	c.contact_name,
	e.last_name
from orders o
inner join customers c
on o.customer_id=c.customer_id
inner join employees e
on o.employee_id=e.employee_id
order by 1;


--Question 4: Check if all the previous queries have same number of rows or not. Lets first check how many rows we have in orders table
--Expected Output: 830
select
count(*)
from orders;


--Question 5: Check if all the previous queries have the same number of rows or not. Lets check how many rows for the output of the following query
--Expected Output: 830
with table1 as(
select
o.order_id,
c.customer_id,
c.contact_name
from orders as o
join customers as c
on c.customer_id=o.customer_id
order by 1 asc)

select count(*) from table1;


--Question 6: Check if all the previous queries have the same number of rows or not. Lets check how many rows for the output of the following query
--Expected Output: 830
with table1 as(
select
	o.order_id,
	e.employee_id,
	e.first_name
from orders as o
join employees as e
on e.employee_id=o.employee_id
order by 1 asc)

select count(*) from table1;


--Question 7: If you check the number of rows in the following query, you will again find 830 rows. This is happening because although customer_id and employee_id are getting repeated in orders table, they are active as the foreign key. Customers and employees tables don't have duplicate value of customer_id and employee_id respectively. Hence, due to many to one mapping, we are getting 830 result everytime.
--Expected Output: 830
with table1 as(
select
	o.order_id,
	c.contact_name,
	e.last_name
from orders o
inner join customers c
on o.customer_id=c.customer_id
inner join employees e
on o.employee_id=e.employee_id
order by 1)

select count(*) from table1;


--Question 8: Using order_details and products table, map category_id against every order_id and product_id.
--Expected Output: Order_id, product_id and category_id sorted by order_id in ascending order and product id in ascending order
select
	o.order_id,
	p.product_id,
	c.category_id
from order_details o
inner join products p
on o.product_id=p.product_id
inner join categories c
on p.category_id=c.category_id
order by 1,2;


--Question 9: In previous questions, we cannot get category_name as the products table doesn't have a category names. To get the category name, you need to write another join with the categories table. Using order_details, categories and products table, map category_name against every order_id and product_id.
--Expected Output: Order_id, product_id and category_name sorted by order_id in ascending order and product id in ascending order
select
	o.order_id,
	p.product_id,
	c.category_name
from order_details o
inner join products p
on o.product_id=p.product_id
inner join categories c
on p.category_id=c.category_id
order by 1,2;


--Question 10: In previous questions, we cannot get category_name as the products table doesn't have a category names. To get the category name, you need to write another join with the categories table. Using order_details, categories, and products table, identify quantity(from order_details) sold for every category name. Name the sum of quantity as quantity_sold
--Expected Output: Category_name and quantity_sold sorted by quantity_sold in ascending order. Don't forget to rename the newly created column

select
	c.category_name,
	sum(o.quantity) as quantity_sold
	from order_details o
inner join products p
on o.product_id=p.product_id
inner join categories c
on p.category_id=c.category_id
group by c.category_name
order by 2;



