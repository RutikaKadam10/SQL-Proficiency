--Question 1. Using the orders table of the Northwind database, how many consumers got acquired in the month of September 1886?
--Expected Output: 9
select
customer_id,
min(order_date)
from orders
group by 1
having extract(month from min(order_date)) = 9 
and extract(year from min(order_date)) = 1996;



--Question 2. Using the orders table of the Northwind database, out of all the consumers transacted in October 1996, how many of them are acquired in August 1996?
--Expected Output: 4
with first_transaction_data as (
select 
    customer_id,
    extract(year from min(order_date))*100+extract(month from min(order_date)) as first_transaction_month
    from orders
    group by 1
),

october_trasacting_customer_unique as (
select 
    distinct customer_id as oct_customer_id
    from orders
    where extract(year from order_date) = 1996  
	and extract(month from order_date) = 10), 

Mergedata as (
select 
    oct_customer_id,
    first_transaction_month
    from october_trasacting_customer_unique OTCU
    join first_transaction_data FTD
    on OTCU.oct_customer_id = FTD.customer_id
    where first_transaction_month = 199608
)
select * from Mergedata;



--Question 3. How many rows will be created if all possible combination of distinct dates of "orders" table and employee_id of the employees table are created?
--Expected Output: 4320
select 
distinct o.order_date,
e.employee_id
from
orders o
cross join employees e;