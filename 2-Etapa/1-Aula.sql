/*Estudo do Views*/
/*
1- Salva a estrutura da consulta (não estou 
salvando dado, só salvando o script(estrutura da consulta)
2- Tabela
Para salvar (create view cliente as select * from customers)
Para chmar a views usar( select * from clientes)
3-Segurança não tem acess a tabelas
4- Permite consultas complexas
5- Pode receber (insert, delete e update) se não tiver função de agregação
6- Fazendo so o select so acha que tem ele no banco de dados, não da para saber de onde vem os dados
_______________________________________
Desvantagem pode cair, ficar lento
--------------------------------------
Unidefined pode usar merge -> Diminui o tempo  associa direto e o
temptable é por memoria e demora.
*/
use classicmodels;

create or replace view vw_cliente (codigo, nome, telefone, endereco, employeenumber)
as
select customernumber, customername, phone, addressline1, salesrepemployeenumber from customers;

drop view vw_cliente;

select * from vw_cliente;

create or replace view vw_pagamento (codigo, valor, datapagamento)
as
select customernumber, amount, paymentdate from payments;

select * from vw_pagamento;

create or replace view analise
as
select 
	codigo,
    valor,
    datapagamento
from
	vw_cliente inner join vw_pagamento using (codigo);
    
select 
	codigo,
    nome,
    firstname
from 
	vw_cliente inner join employees using (employeenumber);
    
select * from analise;
#---------------------
#Union

select 
	codigo, nome
from 
	vw_cliente;
    
select 
	codigo, valor
from 
	vw_pagamento;
    
select 
	codigo, nome
from 
	vw_cliente
union
select 
	codigo, valor
from 
	vw_pagamento;