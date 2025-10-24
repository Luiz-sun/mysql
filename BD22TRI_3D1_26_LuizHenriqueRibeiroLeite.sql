/*Questão A*/

use classicmodels;

create or replace view vw_Total_compra
as 
select
	productName as Nome,
    buyPrice as Preco_Compra,
    priceEach as Preco_unitario,
    MSRP as Preco_sugerido,
	round(buyPrice*quantityOrdered) as Quantidade_Realcomprada,
    round(priceEach*quantityOrdered) as TotalPreco_sugerido,
    reportsTo as Grente_Vendas
from 
	products
    inner join orderdetails using (productCode)
    inner join orders using (orderNumber)
    inner join customers using (customerNumber)
    inner join EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
    inner join OFFICES USING (OFFICECODE)
where 
	offices.city in ('Boston', 'NYC') and
    reportsTo =  1143;
 
 drop view vw_Total_compra;

create or replace view vw_Total_compra
as 
with cte_Pagamento (nome,Preco_compra, Preco_Uinitario, Preco_sugerido, Quantidade_Realcomprada,TotalPreco_sugerido,Grente_Vendas)as (select 
productName as Nome,
    buyPrice as Preco_Compra,
    priceEach as Preco_unitario,
    MSRP as Preco_sugerido,
	round(buyPrice*quantityOrdered) as Quantidade_Realcomprada,
    round(priceEach*quantityOrdered) as TotalPreco_sugerido,
    reportsTo as Grente_Vendas
from 
	products
    inner join orderdetails using (productCode)
    inner join orders using (orderNumber)
    inner join customers using (customerNumber)
    inner join EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
    inner join OFFICES USING (OFFICECODE)
where 
	offices.city in ('Boston', 'NYC') and
    reportsTo =  1143
)
select * from vw_Total_compra;
/*Questão B*/

use sakila;

delimiter %
create procedure pr_Pais_mai_pagamento(
	out country varchar(50),
    out payment int,
    out customer int)
begin
declare var_valormaior int default 0;
declare pais_com_mais_pagamento int default 0;
declare mes int;
	select 
		country as Nome_Pais,
        customer_id as Qauntidade_Pessoa,
        amount as Total_pagamento,
        round(amount*customer_id) as Quantidade_Pagamentos
	from
		country
			inner join city using (country_id)
            inner join address using (city_id)
            inner join customer using(address_id)
            inner join payment using(customer_id)
	where
		pais_com_mais_pagamento = country and
        MONTH(mes)  
	group by
		customer_id
	ORDER BY Nome_Pais DESC;
    set pais_com_mais_pagamento = country;
    set Quantidade_Pessoa = customer_id;
end%
delimiter ;
call pr_Pais_mai_pagamento();
select @pr_Pais_mai_pagamento;

/*Questao D*/

/*Questão e*/

create database minha_rotina;
use minha_rotina;
delimiter %
create procedure sp_minha_rotina(
	in creme varchar (50),
    out situacao varchar(50))
begin
	select 'acordar' as primeiro_passo,
		'tomar banho' as segundo_passo,
		concat('pentear o cabelo com o creme: ', creme) as terceiro_passo, 
        'ler livro' as quarto_passo,
        'lavar louça' as quinto_passo;
	set situacao = "Terminou";
end%
delimiter ;
call sp_minha_rotina('skala', @situacao);