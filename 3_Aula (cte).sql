/*
Commom table expression with (cte)
*similar a uma tabela
*Permite consultas complexas
*Organização de consulras complexas
*Não é um objeto
*somente a té 
cte permite trabalhar com consultas complexas e pode deixar eu fazer consultas isoladas
*/
use classicmodels;
select * from customers;

select 
	customernumber,
	customername,
	phone,
	addressline1
from
	customers;
    
with cte_Cliente (codigo,nome, telefone, endereco)as (select 
	customernumber,
	customername,
	phone,
	addressline1
from
	customers),
    cte_Pagamento(codigo, valor) as (
    select 
		customernumber,
        sum(amount)
	from 
        payments
	group by
		customernumber
        )
    
select * from cte_Cliente inner join cte_Pagamento using(codigo);