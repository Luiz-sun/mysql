use sakila;

select active, count(*) qtnde_clientes 
from customer
group by active;
select distinct active from customer;

select * from film;

select distinct rental_duration from film;
select rental_duration, count(*) as qtde,
sum(rental_rate) as somatorio,
max(rental_rate) as maior,
min(rental_rate) as menor,
format(avg(rental_rate),2)  as media
from film 
group by rental_duration;

select * from payment;

select customer_id, 
sum(amount) as somatorio,
format(avg(amount),2) as media,
max(amount) as maior,
min(amount) as menor,
count(*) as contador
#year(payment_date) as ano,
from payment
group by customer_id; 
#order by customer_id;
#order by media desc;

select * from category;
select * from film_category;

select name, count(film_id) as qtde
from film_category
	inner join category on (film_category.category_id = category.category_id)
group by name;

select * from film_category
inner join category on (film_category.category_id = category.category_id);

select title as filme, count(actor_id) as qtde 
from film 
	inner join film_actor on (film.film_id = film_actor.film_id)
    group by filme;
    
select concat(first_name, '', last_name) as cliente, 
sum(amount) as somatorio,
format(avg(amount),2) as media,
max(amount) as maior,
min(amount) as menor,
count(*) as contador
from payment
	inner join customer using (customer_id)
group by cliente; 

select country as pais, 
sum(amount) as somatorio,
format(avg(amount),2) as media,
max(amount) as maior,
min(amount) as menor,
count(*) as contador
from payment
	inner join customer using (customer_id)
    inner join address using(address_id)
    inner join city using (city_id)
    inner join country using(country_id)
group by pais; 

select 
name as categoria,
sum(amount) as total
	from category 
    inner join film_category using (category_id)
    inner join film using (film_id)
    inner join inventory using (film_id)
    inner join rental using( inventory_id)
    inner join payment using(rental_id)
    group by categoria;