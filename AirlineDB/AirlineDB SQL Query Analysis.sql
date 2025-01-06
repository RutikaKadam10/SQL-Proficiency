SET search_path TO bookings;

--Question 1. Find list of airport codes in Europe/Moscow timezone.
--Expected Output: Airport_code
select distinct airport_code 
from airports_data 
where timezone = 'Europe/Moscow';


--Question 2. Write a query to get the count of seats in various fare condition for every aircraft code?
--Expected Output: Aircraft_code, fare_conditions ,seat count
select aircraft_code, fare_conditions, count(seat_no)
from seats 
group by 1,2
order by 1,2;


--Question 3. How many aircrafts codes have at least one Business class seats?
--Expected Output: Count of aircraft codes
select count(aircraft_code) 
from(
	select 
		aircraft_code,
		count(seat_no) as seat_count
	from seats
	where fare_conditions='Business'
	group by 1
)temp_table;


--Question 4. Find out the name of the airport having maximum number of departure flight
--Expected Output: Airport_name 
with scheduled_departure_flights_data as(
    			select 
    			aa.airport_name::json->> 'en' as airport_name,
    			count(f.flight_id) as flight_count
    			from airports_data aa
    			inner join flights f
    			on aa.airport_code=f.departure_airport
    			where f.status='Scheduled'
    			group by 1
),
rank_data as(
    select *,
    rank() over(order by flight_count desc) as rk
    from scheduled_departure_flights_data
)
select airport_name from rank_data where rk=1;


--Question 5. Find out the name of the airport having least number of scheduled departure flights.
--Expected Output: airport_name  
with scheduled_departure_flights_data as(
    			select 
    			aa.airport_name::json->> 'en' as airport_name,
    			count(f.flight_id) as flight_count
    			from airports_data aa
    			inner join flights f
    			on aa.airport_code=f.departure_airport
    			where f.status='Scheduled'
    			group by 1
),
rank_data as(
    			select *,
    			rank() over(order by flight_count asc) as rk
    			from scheduled_departure_flights_data
)
select airport_name 
from rank_data 
where rk=1;


--Question 6. How many flights from ‘DME’ airport don’t have actual departure?
--Expected Output : Flight Count 
select count(distinct flight_no) as flight_count
from flights
where departure_airport = 'DME' 
and actual_departure is null;


--Question 7. Identify flight ids having range between 3000 to 6000.
--Expected Output: Flight_Number , aircraft_code, ranges 
select
distinct f.flight_no,
a.aircraft_code,
a.range
from aircrafts a
inner join flights f
on a.aircraft_code=f.aircraft_code
where range between 3000 and 6000
order by 1;


--Question 8. Write a query to get the count of flights flying between URS and KUF?
--Expected Output: Flight_count
select 
count(distinct flight_id) 
from flights 
where departure_airport='URS' and arrival_airport='KUF'
or departure_airport='KUF' and arrival_airport='URS';


--Question 9. Write a query to get the count of flights flying from either from NOZ or KRR?
--Expected Output: Flight_count
select
count(distinct flight_id) as Fight_count
from
flights
where departure_airport='NOZ' OR departure_airport='KRR';


--Question 10. Write a query to get the count of flights flying from KZN,DME,NBC,NJC,GDX,SGC,VKO,ROV?
--Expected Output: Departure airport ,count of flights flying from these   airports.
select
departure_airport,
count(distinct flight_id)
from flights
where departure_airport in ('KZN','DME','NBC','NJC','GDX','SGC','VKO','ROV')
group by 1;


--Question 11. Write a query to extract flight details having range between 3000 and 6000 and flying from DME?
--Expected Output: Flight_no,aircraft_code,range,departure_airport
select
distinct f.flight_no,
f.aircraft_code,
a.range,
f.departure_airport
from flights f
inner join aircrafts a
on f.aircraft_code=a.aircraft_code
where departure_airport='DME' 
and (a.range between 3000 and 6000);


--Question 12. Find the list of flight ids which are using aircrafts from “Airbus” company and got cancelled or delayed?
--Expected Output: Flight_id,aircraft_model
select 
f.flight_id,
aa.model
from aircrafts_data aa
inner join flights f
on aa.aircraft_code=f.aircraft_code
where aa.model::text like '%Airbus%' and
(f.status = 'Cancelled' or f.status = 'Delayed');


--Question 13. Find the list of flight ids which are using aircrafts from “Boeing” company and got cancelled or delayed?
--Expected Output: Flight_id,aircraft_model
select 
f.flight_id,
aa.model
from aircrafts_data aa
inner join flights f
on aa.aircraft_code=f.aircraft_code
where aa.model::text like '%Boeing%' and
(f.status = 'Cancelled' or f.status = 'Delayed');


--Question 14. Which airport(name) has most cancelled flights (arriving)?
--Expected Output: Airport_name 
with scheduled_departure_flights_data as(
    			select 
    			aa.airport_name,
    			count(f.flight_id) as flight_count
    			from airports_data aa
    			inner join flights f
    			on aa.airport_code=f.arrival_airport
    			where f.status='Cancelled'
    			group by 1
),
rank_data as(
    			select *,
    			rank() over(order by flight_count desc) as rk
    			from scheduled_departure_flights_data
)
select airport_name::json->> 'en' as airport_name
from rank_data 
where rk=1;


--Question 15. Identify flight ids which are using “Airbus aircrafts”?
--Expected Output: Flight_id,aircraft_model
select
f.flight_id,
aa.model as aircraft_model
from flights f
inner join aircrafts_data aa
on f.aircraft_code=aa.aircraft_code
where model::text like '%Airbus%';


--Question 16. Identify date-wise last flight id flying from every airport?
--Expected Output: Flight_id,flight_number,schedule_departure,departure_airport
with flying_flight_data as(
    			select 
    				flight_id,
   			 		flight_no,
    				scheduled_departure,
   		 			departure_airport
    			from flights
    			where status = 'Scheduled'
),
rank_data as(
    			select *,
				rank() over(partition by departure_airport order by scheduled_departure desc) as rk
    			from flying_flight_data
)
select 
flight_id,
flight_no,
scheduled_departure,
departure_airport 
from rank_data where rk=1;


--Question 17. Identify list of customers who will get the refund due to cancellation of the flights and how much amount they will get?
--Expected Output: Passenger_name,total_refund
select 
t.passenger_name,
tf.amount
from tickets t
inner join ticket_flights tf
on t.ticket_no=tf.ticket_no
inner join flights f
on tf.flight_id=f.flight_id
where status='Cancelled';


--Question 18. Identify date wise first cancelled flight id flying for every airport?
--Expected Output: Flight_id,flight_number,schedule_departure,departure_airport
with flying_flight_data as(
	select 
    	flight_id,
    	flight_no,
    	scheduled_departure,
   		departure_airport
    from flights
    where status = 'Cancelled'
),
first_cancelled_flight as(
    	select *,
		rank() over(partition by departure_airport order by scheduled_departure) as rk
    	from flying_flight_data
)
select 
flight_id,
flight_no,
scheduled_departure,
departure_airport
from first_cancelled_flight where rk=1;


--Question 19. Identify list of Airbus flight ids which got cancelled.
--Expected Output: Flight_id
select
f.flight_id
from flights f
inner join aircrafts_data aa
on f.aircraft_code=aa.aircraft_code
where model::text like '%Airbus%' 
and f.status='Cancelled';


--Question 20. Identify list of flight ids having highest range.
--Expected Output: Flight_no, range
with flights_range_data as(
    			select
    			distinct f.flight_no,
    			aa.range
    			from flights f
    			inner join aircrafts_data aa
    			on f.aircraft_code=aa.aircraft_code
),
rank_data as(
    			select *,
    			rank() over(order by range desc) as rk
    			from flights_range_data
)
select
flight_no,
range 
from rank_data 
where rk=1;


