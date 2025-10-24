use classicmodels;

#Questão A) 
#1)

select 
	customerName,
    sum(amount) as Total_pago,
    case
		when sum(amount) > 50000 
			then ROUND(SUM(AMOUNT) * 0.05,2)
		when sum(amount) > 20000 
			then ROUND(SUM(AMOUNT) * 0.03,2)
		when sum(amount) > 10000 
			then ROUND(SUM(AMOUNT) * 0.02,2)
            or sum(amount)
    end as desconto
from 
	customers
		inner join payments using (customerNumber)
        where 
        year(paymentDate) = 2003 and 2004
        and month (paymentDate) in (1,2,3,4)
        group by customerName asc
        limit 50;
        
#Questão b
select 
	OFFICES.CITY as escritorio,
	customerNumber as Clientes,
	count(customerNumber) as Total,
    sum(amount) as Pagaram
from
customers
		inner join payments using (customerNumber)
		INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
		INNER JOIN OFFICES USING (OFFICECODE)
where
	YEAR(PAYMENTDATE) = 2003
group by OFFICES.CITY = "Paris" and "Tokyo" 
having Pagaram > 10000

union

select 
	employeeNumber as Vendedor,
    count(employeeNumber) as Total,
    sum(amount) as Vendas
from 
	customers
		inner join payments using (customerNumber)
		INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
		INNER JOIN OFFICES USING (OFFICECODE)
where
	YEAR(PAYMENTDATE) = 2005;
    
    use sakila;
    
select
	country as Pais,
	count(customer_id) as quantidade
from 
	country
		inner join city using (country_id)
        inner join address using (city_id)
        inner join customer using (address_id)
        inner join payment using (customer_id)
	where 
		MONTH(PAYMENT_DATE) IN (5,6,7)
	AND YEAR(PAYMENT_DATE) = 2005
    group by country
    order by quantidade desc 
limit 10;
		
        create database avatar;
        use avatar;
        create table avatar(
			avatar_id
        )
	