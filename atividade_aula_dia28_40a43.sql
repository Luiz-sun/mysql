use sakila;

#atividade 2 pag 40:

select 
	*
from 
	city inner join  address using (city_id);
    
#b
select 
	*
from 
	address inner join  customer using (address_id);
#c
select 
	*
from 
	customer inner join  payment using (customer_id);
#d
select 
	*
from 
	 payment inner join  customer using (customer_id);
#e
select 
	*
from 
	 film inner join  language using (language_id);
	#atividade  3 pag 41

#a
	select
		count(film_id) as Numeros_filmes,
        name as language
        from 
        language inner join film using (language_id) 
		group by film_id;
#b
	select
		sum(amount) as Numeros_pagamento,
		store_id as	loja
        from 
        payment 
        inner join staff using (staff_id)
        inner join store using (store_id)
		group by amount;
#c
select
	count(active) as numero_clientes,
    store_id as	loja
    from 
		customer inner join store using (store_id)
	group by active;
#d
	select 
    avg(amount) as Media_pagamentos,
    sum(amount) as total_pagamento,
    max(amount) as Valor_maximo_pago,
    min(amount) as valor_minimo_pago,
    count(amount) as quantidade_pagamento,
    store_id as loja
    from 
    payment 
        inner join staff using (staff_id)
        inner join store using (store_id)
		group by amount;
#e
	select 
		sum(amount) as total_pagamento,
        concat(first_name, '', last_name) as clientes
    from
		payment inner join customer using (customer_id)
	group by  amount;
#f
 select
	count(film_id) as Quantidade_filmes,
	name as language
from
	film inner join language using (language_id)
where 
	length between 100 and 150;

#g 
select 
    s.store_id as loja,
    sum(p.amount) as total_pagamentos
from 
    payment p inner join staff st on p.staff_id = st.staff_id inner join store s on st.store_id = s.store_id
where 
    month(p.payment_date) between 8 and 9
group by 
    s.store_id;
#h
select 
    s.store_id as loja,
    count(c.customer_id) as quantidade_clientes
from 
    customer c inner join store s on c.store_id = s.store_id
where 
    c.last_name like 'r%'
group by 
    s.store_id;

#Pagina 42 questão 4

#a 
select 
	* 
from
	city inner join address using(city_id)
    inner join customer using (address_id);
    
#b
select 
	* 
from
	customer inner join payment using(customer_id)
    inner join rental using (rental_id);

#c
select 
	* 
from
	film inner join film_category using(film_id)
    inner join category using (category_id);

#d

select 
	* 
from
	actor inner join film_actor using(actor_id)
    inner join film using (film_id);

#e
select 
	count(customer_id) as quantidade,
    city as cidade
from 
    customer inner join address using (address_id)
    inner join city using (city_id)
    where month(create_date) = 2
    group by city;

#5 pag 43

#a
select *
from city
inner join address on city.city_id = address.city_id
inner join customer on address.address_id = customer.address_id
inner join payment on customer.customer_id = payment.customer_id;
#b
select *
from store
inner join staff on store.manager_staff_id = staff.staff_id
inner join payment on staff.staff_id = payment.staff_id
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id;

#c
select *
from actor
inner join film_actor on actor.actor_id = film_actor.actor_id
inner join film on film_actor.film_id = film.film_id
inner join inventory on film.film_id = inventory.film_id
inner join rental on inventory.inventory_id = rental.inventory_id
inner join payment on rental.rental_id = payment.rental_id
inner join customer on payment.customer_id = customer.customer_id
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id;

#Atividade 6

select 
    category.name as categoria,
    sum(payment.amount) as total_pagamentos
from payment
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
group by category.name
order by total_pagamentos desc;

#aTIVIDADE 7

select 
    country.country as país,
    count(payment.payment_id) as quantidade_pagamentos
from payment
inner join customer on payment.customer_id = customer.customer_id
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
group by country.country
order by quantidade_pagamentos desc;

#ATIVIDAE 8
select 
    'por categoria' as tipo_consulta,
    category.name as item,
    sum(payment.amount) as total,
    null as quantidade
from payment
inner join rental on payment.rental_id = rental.rental_id
inner join inventory on rental.inventory_id = inventory.inventory_id
inner join film on inventory.film_id = film.film_id
inner join film_category on film.film_id = film_category.film_id
inner join category on film_category.category_id = category.category_id
group by category.name

union all

select 
    'por país' as tipo_consulta,
    country.country as item,
    null as total,
    count(payment.payment_id) as quantidade
from payment
inner join customer on payment.customer_id = customer.customer_id
inner join address on customer.address_id = address.address_id
inner join city on address.city_id = city.city_id
inner join country on city.country_id = country.country_id
group by country.country

order by tipo_consulta, 
         case when tipo_consulta = 'por categoria' then total else quantidade end desc;