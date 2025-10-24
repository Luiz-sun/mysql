use classicmodels;

/*
Crie uma view para a consulta abaixo:

Retorne o nome do produto, o preço unitario, o preço de compra e o msrp(preço sugerido).
Alem disso, também crie uma coluna na sua view para calcular o porcentual de lucro considerando o preço sugerido.
Outro campo , será o percentual de lucro em cima de preço de compra.
Por fim, faça uma analise considerando o criterio abaixo:
Tudo isso deverá ser para o escritorio de Paris, Tokyo e San francisco. Alem disso, você deve obeservar 
o ano do pedido que deverá estar entre 2004 e 2005, apenas para quarto trimestre.

percentual de preço sugerido; [(priceach/msrp)*100]-1
percentual de preço de compra; [(priceach/byprice)*100]-1
*/

create or replace view vw_Analise_lucro
as 
select 
	productName as Nome,
    buyPrice as Preco_Compra,
    priceEach as Preco_unitario,
    MSRP as Preco_sugerido,
	round(((priceEach/msrp)*100)-1,2) as Porcen_Lucro_Sugerido,
    round(((priceEach/buyprice)*100)-1,2) as Porcen_Lucro_Compra
from
	products
    inner join orderdetails using (productCode)
    inner join orders using (orderNumber)
    inner join customers using (customerNumber)
    inner join EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
    inner join OFFICES USING (OFFICECODE)
where 
	offices.city in ('Paris', 'Tokyo', 'San Francisco')
    and year(orderdate) in (2004,2005)
    and month(orderdate) in (10,11,12);
    
select * from vw_Analise_lucro order by produto;

/*
Usando a view anterior você deverá calcular a média de porcentual de preço de compra e a média do 
percentual do preço sugerido sugerido por produto

Dê o nome de view analise_lucro medio
*/

create or replace view vw_Analise_Lucro_Media
as 
select 
	Nome,
	round(avg(Porcen_Lucro_Sugerido),2) as Media_Lucro_sugerido,
	round(avg(Porcen_Lucro_Compra),2) as Media_Lucro_Compra 
from vw_Analise_lucro group by Nome;

select * from vw_Analise_Lucro_Media;

/*update view*/

update vw_Analise_Lucro_Media set Media_Lucro_sugerido = 100 where produto = "1895 UGIUGIKUG"; 

/*-----------------------------------------------------------------------------------*/

use classicmodels;

create or replace view ProdutoMaisVendidos
as 
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

create or replace view ValoresVendidos
as 
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

create or replace view QuantidadeProduto
as 
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

create or replace view TotalCliente
as 
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

create or replace view RelacaoProdMenosVendido
as 
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

create or replace view ValoresTokyo
as 
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

create or replace view MenorQuantidade
as 
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

create or replace view TotalClienteCadaEscritorio
as 
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
    
select * from ProdutoMaisVendidos;
select * from ValoresVendidos;
select * from QuantidadeProduto;
select * from TotalCliente;
select * from RelacaoProdMenosVendido;
select * from ValoresTokyo;
select * from MenorQuantidade; 
select * from TotalClienteCadaEscritorio;

update ProdutoMaisVendidos set customername = 'Bernardo Jose' where customernumber = 103;
update ValoresVendidos set max_value = 256 where offc.city = 'Tokyo';
update QuantidadeProduto set total_quantity = 100 where  month(o.requireddate) between 7 and 12;


/*
1-Fazer o update diretamente na tabale desejada
2- Criar uma tabela baseada em consulta
*/