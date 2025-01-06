--Question 1. Create order_rank for all the orders based on the order data. Also, observe if more than one order_Id have gotten same rank or not.
--Expected Output: Order_id, order_date and order_rank. 
select
order_id,
order_date,
rank() over(order by order_date) as order_rank
from orders;


--Question 2. Create shipping_rank for all the orders based on the orders data. The first shipped order should get the first rank. Also, observe if more than one order_Id have gotten the same rank or not.
--Expected Output: Order_id, shipped_date and shipping_rank. 
select
order_id,
shipped_date,
rank() over(order by shipped_date) as shipping_rank
from orders;


--Question 3. Create order_rank for all the orders based on the order data. The latest order should get the first rank Also, observe if more than one order_Id have gotten the same rank or not.
--Expected Output: Order_id, order_date and order_rank. 
select
order_id,
order_date,
rank() over(order by order_date desc) as order_rank
from orders;


--Question 4. Company wants to give $5 cashback to every customer on the first order. Identify the order_ids and customer_ids which are eligible for getting the cashback. 
--Expected Output: Customer_id and first_order_id. The output should be sorted by customer_id first then order_id
--In CTE format
with order_list_of_customers as(
	select customer_id, order_id as first_order_id,
	dense_rank() over(partition by customer_id order by order_id) as rk
	from orders
)

select customer_id,first_order_id
from order_list_of_customers
where rk=1;

--In Sub-query format
select customer_id, first_order_id from
(
	select customer_id, order_id as first_order_id,
	dense_rank() over(partition by customer_id order by order_id) as rk
	from orders
) asa														           
where rk=1



--Question 5. To increase the sale of a new employee, bonus is given on the first sale of the employee. Identify the first order_id for every employee id using order_date in the orders table. 
--In CTE format
with orders_list_of_employee as(
    select employee_id, order_id as first_order_id,
    dense_rank() over(partition by employee_id order by order_date asc) as rk
    from orders
)

select employee_id, first_order_id
from orders_list_of_employee
where rk=1;

--In sub-query format
Select employee_id,first_order_id From
(Select employee_id, order_id as first_order_id,
Dense_rank() Over(Partition by  employee_id Order by order_id Asc) as rk
From Orders ) asa														
Where rk = 1;



--Question 6. Identify first order_id (using order_date) for every month. 
--Expected Output: Year_month in 'YYYY-MM' format and first order_id. Final output should be sorted in ascending order of Year_month
with orders_every_month as (
	select 
	to_char(order_date, 'YYYY-MM') as Year_month,
	order_id as first_order_id,
	dense_rank() over(partition by to_char(order_date, 'YYYY-MM') order by order_date) as rk
	from orders
)

select Year_month,
first_order_id
from 
orders_every_month
where rk=1;


--Question 7.Identify highest selling (quantity sold) product_id in every category_id
--Expected Output: Category_id, Highest_selling_product_id and quantity_sold. The output should be sorted by category_id in ascending order
with category_product_wise_quantity_sold as(
	select 
	p.category_id,
	o.product_id,
	sum(o.quantity) as quantity_sold
	from order_details o
	inner join products p
	on o.product_id=p.product_id
	group by 1,2
),

rank_data as(
	select *,
	rank() over(partition by category_id order by quantity_sold desc) as rk
	from category_product_wise_quantity_sold
)

select 
	category_id,
	product_id,
	quantity_sold
	from rank_data
	where rk=1
	order by 1;


--Question 8.Identify least selling (quantity sold) product_id in every category_id
--Expected Output: Category_id, Highest_selling_product_id, and quantity_sold. The output should be sorted by category_id in ascending order
with category_product_wise_quantity_sold as(
	select 
	p.category_id,
	o.product_id,
	sum(o.quantity) as quantity_sold
	from order_details o
	inner join products p
	on o.product_id=p.product_id
	group by 1,2
),

rank_data as(
	select *,
	rank() over(partition by category_id order by quantity_sold) as rk
	from category_product_wise_quantity_sold
)

select 
	category_id,
	product_id,
	quantity_sold
	from rank_data
	where rk=1
	order by 1;


--Question 9. Identify highest selling (quantity sold) product_id in every category_name
--Expected Output: Category_name, Highest_selling_product_id and quantity_sold. The output should be sorted by category_id in ascending order
with category_product_wise_quantity_sold as(
	select 
	c.category_id,
	c.category_name,
	o.product_id,
	sum(o.quantity) as quantity_sold
	from order_details o
	inner join products p
	on o.product_id=p.product_id
	inner join categories c
	on p.category_id=c.category_id
	group by 1,2,3
),

rank_data as(
	select *,
	rank() over(partition by category_name order by quantity_sold desc) as rk
	from category_product_wise_quantity_sold
)

select 
	category_name,
	product_id,
	quantity_sold
	from rank_data
	where rk=1
	order by 1;




