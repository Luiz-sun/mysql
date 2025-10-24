create or replace view vw_Analise
as 
with cte_Produto (codigoproduto, nomeproduto, preco_compra, preco_sugerido)as(select	
	productcode,
    productname,
	buyprice,
    msrp 
from
	products),

cte_Itempedido (codigoproduto, numeronota, preco_unitario) as (
select	
	productcode,
    ordernumber,
    priceeach
from 
	orderdetails),
cte_Pedido (numeronota,codigocliente, datapedido) as (
select 
	ordernumber,
    customernumber,
    orderdate
from 
	orders
where
	year(orderdate) in (2004,2005)
and month(orderdate) in (10,11,12)),
cte_cliente(codigocliente,nome,codigovendedor) as (
select 
	customernumber,
    customername,
    salesRepEmployeeNumber
    from 
    customers),
    
cte_vendedor (codigovendedor,codigoescritorio)as(
select 
	employeenumber,
    officecode
    from
    employees),
cte_Escritorio(codigoescritorio,cidade) as 
(select
	officecode,
    city
from
	offices
where 
city in ('Tokyo', 'Paris','San Francisco')
)

select 
	nomeproduto, 
	preco_unitario,
	preco_compra,
	preco_sugerido,
	round(((preco_unitario/preco_compra)-1)*100,2) as Lucro_Perc_Compra,
	round(((preco_unitario/preco_sugerido)-1)*100,2) as Lucro_Perc_Sugerido
from
cte_Produto
	inner join cte_Itempedido using(codigoproduto)
    inner join cte_Pedido using(numeronota)
    inner join cte_Cliente using (codigoCliente)
    inner join cte_Vendedor using (codigovendedor)
    inner join cte_Escritorio using (codigoescritorio);