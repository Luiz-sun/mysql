use sakila;

(select 
	concat(first_name, ' ', last_name) as nomeCompleto, customer_id from customer
    limit 5)
union #Union não aceita numero de colunas diferente
(select sum(amount) as total, customer_id 
from 
payment group by customer_id limit 5);

#crie uma consulta que unifique as consultas abaixo:
#1- Retorne o nome dos clientes ativos, que realizaram pagamentos em 2005 entre o mês de agosto e outubro cujo o país inicia com a letra A
#2-Retorme o nome dos clientes inativos que o pais inicie com a letra C;

#Primeira consulta
select concat(first_name, ' ', last_name) as nomeCompleto
from 
 country 
 inner join city using (country_id)
 inner join address using(city_id)
 inner join customer using(address_id)
 inner join payment using(customer_id)
 where
 year(payment_date) = 2005
 and month (payment_date) between 8 and 10
 and active = 1
 and country like 'A%'
 
 union #Tira os valores repetidos
#union all deixa o valor repetidos
 #Segunda consulta
 
 select concat(first_name, ' ', last_name) as nomeCompleto
from 
country 
inner join city using (country_id)
inner join address using (city_id)
inner join customer using (address_id)
where
active = 0
and country like 'C%';
 
 #use a base classicmolds
 use classicmodels;
 
 select 
 *
 from customers;
 
 select 
 *
 from payments;
 
 select customerNumber,
 sum(amount) as Total,
 avg(amount) as media
 from payments
 group by customerNumber
 having total > 500000
 or media>60000;
 #filtrar informação having
 
 #1-Consulta
 
 (select 
	customerName as nomeCompleto, 
    creditLimit as LimiteCredito
from 
 customers
	inner join payments using(customerNumber)
 where
	year (paymentDate) between 2003 and 2005
 and month(paymentDate) in (1,2,3)
 limit 5)
 union
 #2-Consulta
 
 (select 
 customerName as nomeCompleto, 
 sum(amount) as total
from 
 customers
	inner join payments using(customerNumber)
where
	year (paymentDate)=2006
and month(paymentDate) in (1,2,3)
group by
	nomeCompleto
having 
total >50000
limit 5);

# cria uma consulta pra unificar os resultados das consultas abaixos;
# retorne o valor recebido pelo escritorio tokyo no ano de 2003 no terceiro trimestre;
# retorne o valor recebido pelo escritorio Paris no antre 2004 e 2005 no segundo trimestre

select 
sum(amount) as TotalRecebido,
offices.city as Escritorios
from
	offices
		inner join employees using (officeCode)
        inner join customers on (salesRepEmployeeNumber = EmployeeNumber)
        inner join payments using (customerNumber)
	where
		year(paymentDate)=2003
        and month(paymentDate) in (7,8,9)
        and offices.city = 'Tokyo'
	group by
		escritorios
        
        union 
#2_consulta

select 
sum(amount) as TotalRecebido,
offices.city as Escritorios
from
	offices
		inner join employees using (officeCode)
        inner join customers on (salesRepEmployeeNumber = EmployeeNumber)
        inner join payments using (customerNumber)
	where
		year(paymentDate) in (2004,2005)
        and month(paymentDate) in (4,5,6)
        and offices.city = 'Paris'
	group by
		escritorios;