use classicmodels;

# crie uma consulta que retorne os clientes que não tem vendedores vinculafos:

select 
	CustomerName as cliente,
    employeeNumber
from
 customers left join employees on (salesRepEmployeeNumber = EmployeeNumber)
 where
  employeeNumber is null;
  
  # crie uma consulta para identificar os produtos que não foram vendidos.
  # tabelas envolvidas: products e orderdetails
  
  select 
	productName as Produtos
from
	products left join orderdetails using (productCode)
where 
	ordernumber is null;
   
 select
	productName as Produtos
from
	orderdetails right join products using (productCode)
where 
	ordernumber is null;
    
# crie uma consulta que irá retornar os filmes que não estão presentes no estoque

use sakila;

select 
	count(title) as Titulos
from 
	film left join inventory using(film_id)
where
	inventory_id is null;

# retorne os vendedores que não tem clientes vinculados. A função é: 'Sales Rep':

use classicmodels;

select 
	firstName as Nome,
    count(fisttName) as Numeros_Vendedor
from 
	employees left join customers on (salesRepEmployeeNumber = EmployeeNumber)
where 
 customerName is null and joBTitle = 'Sales Rep';
 
 # crie uma consulta para unificar as consultas abaixos:
 # retorne o nome dos clientes que não tem vendedor;
 # retorne o nome dos produtos que não foram vendidos;
 # Retorne os vendedores que não tem clientes;
 
 select 
 observacao,
 count(observacao)
 from
 (
select
	CustomerName as cliente, 'Clientes sem vendedores' as observacao
from
 customers left join employees on (salesRepEmployeeNumber = EmployeeNumber)
 where
  employeeNumber is null
  
  union
  
  select 
	productName as Produtos, 'Produtos não vendidos'  as observacao
from
	products left join orderdetails using (productCode)
where 
	ordernumber is null
    
    union
   
 select 
	concat(firstName, '', lastName) as Nome, 'Vendedores sem clientes'  as observacao
from 
	employees left join customers on (salesRepEmployeeNumber = EmployeeNumber)
where 
 customerName is null and joBTitle = 'Sales Rep') as resultados
 group by 
 observacao;
 
 
 