use classicmodels;
#Questao 1 

# A) 
create or replace view vm_TotalRecebido_Empregados
as 
select 
	offices.city,
	sum(amount),
	sum(EMPLOYEEnumber) as Quantidade_empregado

from 
	offices
	inner join EMPLOYEES using (officeCode)
	inner join customers on salesRepEmployeeNumber = employeeNumber
	inner join payments using(customerNumber)
where
	offices.country in ('USA') and
    year(paymentDate) = 2004 and 
    MONTH(PAYMENTDATE) between 6 and 12
group by
	offices.city;

select * from vm_TotalRecebido_Empregados;

#Questão b

create or replace view vm_TotalRecebido_Empregados_codigo_cliente
as 
select 
	customernumber,
	offices.city,
	sum(amount),
	sum(EMPLOYEEnumber) as Quantidade_empregado

from 
	offices
	inner join EMPLOYEES using (officeCode)
	inner join customers on salesRepEmployeeNumber = employeeNumber
	inner join payments using(customerNumber)
where
	offices.country in ('USA') and
    year(paymentDate) = 2004 and 
    MONTH(PAYMENTDATE) between 6 and 12
group by
	offices.city,
    customernumber;

with cte_Juntar_view (TotalRecebido, totalpedidos, escritorio) as (
	select
		offices.city,
		sum(amount),
        sum(quantityOrdered)
	from 
    orders 
		inner join orderdetails using (ordernumber)
        inner join customers using(customernumber)
        inner join payments using (customernumber)
		inner join employees on salesRepEmployeeNumber = employeeNumber
        inner join offices using (officeCode)
	group by 
		offices.city
)















#Questão 2
use world;

select
region,
name as Pais, 
population,
sum(Percentage * Population )/100 as total_de_pessoas_falantes
from 
country 
inner join  countrylanguage on countryCode = Code
where
region = ('Polynesia')
group by 
region,Pais,Population;