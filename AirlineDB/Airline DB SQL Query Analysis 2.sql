SET search_path TO bookings;

--Question 1. Represent the “book_date” column in “yyyy-mmm-dd” format using Bookings table.
--Expected Output: book_ref, book_date (in “yyyy-mmm-dd” format) , total amount 
select 
book_ref,
to_char(book_date, 'yyyy-Mon-dd'),
total_amount
from bookings;


--Question 2. Get the following columns in the exact same sequence.
--Expected Output: ticket_no, boarding_no, seat_number, passenger_id, passenger_name.
select 
b.ticket_no,
b.boarding_no,
b.seat_no,
t.passenger_id,
t.passenger_name
from boarding_passes b
inner join tickets t
on b.ticket_no=t.ticket_no;


--Question 3. Write a query to find the seat number which is least allocated among all the seats?
with seat_wise_count as(
    select
    	seat_no,
    	count(seat_no),
    	rank() over(order by count(seat_no) asc) as rk
	from boarding_passes
	group by seat_no
)

select *
from seat_wise_count
where rk = 1;


--Question 4. In the database, identify the month wise highest paying passenger name and passenger id.
--Expected Output: Month_name(“mmm-yy” format), passenger_id, passenger_name and total amount
with month_wise_passenger_amount as(
    select
   		to_char(book_date, 'Mon-yy') as month_year,
    	t.passenger_id,
    	t.passenger_name,
    	sum(b.total_amount) as tl_amount
    	from bookings b
    	inner join tickets t
    	on b.book_ref=t.book_ref
    	group by 1,2,3
),
rank_data as(
    select *,
    rank() over(partition by month_year order by tl_amount desc) as rk
    from month_wise_passenger_amount
)
select * from rank_data where rk=1;


--Question 5. In the database, identify the month wise least paying passenger name and passenger id?
--Expected Output: Month_name(“mmm-yy” format), passenger_id, passenger_name and total amount
with month_wise_passenger_amount as(
    select
    	to_char(book_date, 'Mon-yy') as month_year,
    	t.passenger_id,
    	t.passenger_name,
    	sum(b.total_amount) as tl_amount
    from bookings b
    inner join tickets t
    on b.book_ref=t.book_ref
    group by 1,2,3
),
rank_data as(
    select *,
    rank() over(partition by month_year order by tl_amount) as rk
    from month_wise_passenger_amount
)
select * from rank_data where rk=1;


--Question 6. Identify the travel details of non stop journeys  or return journeys (having more than 1 flight).
--Expected Output: Passenger_id, passenger_name, ticket_number and flight count
select
t.passenger_id,
t.passenger_name,
t.ticket_no,
count(flight_id) as flight_count
from tickets t
inner join ticket_flights f
on t.ticket_no=f.ticket_no
group by 1,2,3
having count(flight_id)>1;


--Question 7. How many tickets are there without boarding passes?
--Expected Output: just one number is required
select 
count(*)
from tickets t
left join boarding_passes b
on t.ticket_no=b.ticket_no
where b.boarding_no is null;


--Question 8. Identify details of the longest flight (using flights table)?
--Expected Output: Flight number, departure airport, arrival airport, aircraft code and durations
with flight_details_with_duration as(
    select
    	flight_id,
    	flight_no,
    	departure_airport,
    	arrival_airport,
    	aircraft_code,
    	(scheduled_arrival-scheduled_departure) as duration
    from flights
),
rank_data as(
    select *,
    rank() over(order by duration desc) as rk
    from flight_details_with_duration
)
select * from rank_data where rk=1;


--Question 9. Identify details of all the morning flights (morning means between 6AM to 11 AM, using flights table)?
--Expected Output: : flight_id, flight_number, scheduled_departure, scheduled_arrival and timings
with flight_details as(
    select
		flight_id,
		flight_no,
		scheduled_departure,
		scheduled_arrival,
		to_char(scheduled_departure, 'HH24:MI:SS') as timings
    from flights
)
select * 
from flight_details 
where timings between '06:00:00' and '11:00:00';


--Question 10. Identify the earliest morning flight available from every airport.
--Expected Output: flight_id, flight_number, scheduled_departure, scheduled_arrival, departure airport and timings
with flight_details as(
    select
		flight_id,
		flight_no,
		scheduled_departure,
		scheduled_arrival,
		departure_airport,
		to_char(scheduled_departure, 'HH24:MI:SS') as timings
    from flights
    where status = 'Scheduled'
),
rank_data as(
    select *,
    rank() over(partition by departure_airport order by timings asc) as rk
    from flight_details
    where timings between '02:00:00' and '06:00:00'
)
select * from rank_data where rk=1;
