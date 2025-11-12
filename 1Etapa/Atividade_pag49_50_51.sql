use sakila;

#pag49

select 
	*
from 
	city inner join  address using (city_id); -- Inner Join --
    

select 
	*
from 
	city left join  address using (city_id);  #left join
    
select 
	*
from 
	city Left outer Join  address using (city_id); #left join exclusive
    
select 
	*
from 
	city right join  address using (city_id); #right join 

select 
	*
from 
	city right outer join  address using (city_id); #right join exclusive
    
select 
	*
from 
	city full join  address using (city_id); #full join
    
#pag50 ex2                                                                                                                                    

#1  Ddl
#2  Dcl, Dml
#3  Dml
#4  Dcl, Dml
#5  Dml
#6  Dml

#Ex3
# O principal cuidado ao executar UPDATE é sempre usar a cláusula WHERE para evitar a modificar todos os registros da tabela;

#Pag51
use classicmodels;
#a
select 
    p.productcode,
    p.productname,
    sum(od.quantityordered) as total_quantity,
    sum(od.quantityordered * od.priceeach) as total_value
from 
    orderdetails od
join 
    orders o on od.ordernumber = o.ordernumber
join 
    products p on od.productcode = p.productcode
where 
    year(o.orderdate) = 2003
group by 
    p.productcode, p.productname
order by 
    total_quantity desc
limit 20;
#b
select 
    month(o.orderdate) as month,
    avg(od.quantityordered * od.priceeach) as avg_value,
    max(od.quantityordered * od.priceeach) as max_value,
    min(od.quantityordered * od.priceeach) as min_value
from 
    orderdetails od
join 
    orders o on od.ordernumber = o.ordernumber
join 
    customers c on o.customernumber = c.customernumber
join 
    employees e on c.salesrepemployeenumber = e.employeenumber
join 
    offices offc on e.officecode = offc.officecode
where 
    year(o.orderdate) = 2004
    and offc.city = 'paris'
group by 
    month(o.orderdate)
order by 
    month;
#c
select 
    p.productcode,
    p.productname,
    sum(od.quantityordered) as total_quantity
from 
    orderdetails od
join 
    orders o on od.ordernumber = o.ordernumber
join 
    products p on od.productcode = p.productcode
where 
    month(o.requireddate) between 9 and 12
group by 
    p.productcode, p.productname
order by 
    total_quantity desc;
#d
select 
    offc.officecode,
    offc.city,
    count(c.customernumber) as total_customers
from 
    offices offc
left join 
    employees e on offc.officecode = e.officecode
left join 
    customers c on e.employeenumber = c.salesrepemployeenumber
group by 
    offc.officecode, offc.city
order by 
    total_customers desc;
#e
select 
    p.productcode,
    p.productname,
    sum(od.quantityordered) as total_quantity,
    sum(od.quantityordered * od.priceeach) as total_value
from 
    orderdetails od
join 
    orders o on od.ordernumber = o.ordernumber
join 
    products p on od.productcode = p.productcode
where 
    year(o.orderdate) = 2004
    and month(o.orderdate) between 1 and 6
group by 
    p.productcode, p.productname
order by 
    total_quantity asc
limit 15;
#f
select 
    avg(od.quantityordered * od.priceeach) as avg_value,
    max(od.quantityordered * od.priceeach) as max_value,
    min(od.quantityordered * od.priceeach) as min_value
from 
    orderdetails od
join 
    orders o on od.ordernumber = o.ordernumber
join 
    customers c on o.customernumber = c.customernumber
join 
    employees e on c.salesrepemployeenumber = e.employeenumber
join 
    offices offc on e.officecode = offc.officecode
where 
    year(o.orderdate) = 2003
    and offc.city = 'tokyo';
#g
select 
    p.productcode,
    p.productname,
    min(od.quantityordered) as min_quantity
from 
    orderdetails od
join 
    orders o on od.ordernumber = o.ordernumber
join 
    products p on od.productcode = p.productcode
where 
    month(o.requireddate) between 9 and 12
group by 
    p.productcode, p.productname
order by 
    min_quantity;
#h
select 
    offc.officecode,
    offc.city,
    count(c.customernumber) as total_customers
from 
    offices offc
left join 
    employees e on offc.officecode = e.officecode
left join 
    customers c on e.employeenumber = c.salesrepemployeenumber
group by 
    offc.officecode, offc.city
order by 
    total_customers desc;