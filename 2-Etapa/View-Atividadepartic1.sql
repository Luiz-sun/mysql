/*
Transformar cada consulta em view 
unificar as views 
criar view para de tudo unificado
*/

#Prova A

USE CLASSICMODELS;
/*
Crie uma consulta para retornar o cliente e o total pago (amount). 
No primeiro semestre de 2003 e 2004. Além disso, você deve criar um terceira coluna chamada desconto, que deve obedecer a regra abaixo:
Se o total de pagamento for acima de 50 mil, o desconto será de 5%;
Se o total de pagamento for acima de 20 mil, o desconto será de 3%;
Se o total de pagamento for acima de 10 mil, o desconto será de 2%;
Do contrário, zero. 

Importante: Os maiores descontos devem aparecer primeiro e o resultado 
deve apresentar apenas 50 registros.
*/

create or replace view vw_Total
as 
SELECT 
  CUSTOMERNAME AS CLIENTE, 
  SUM(AMOUNT) AS VALOR_TOTAL, 
  CASE 
    WHEN SUM(AMOUNT) > 50000 THEN SUM(AMOUNT) * 0.05
    WHEN SUM(AMOUNT) > 20000 THEN SUM(AMOUNT) * 0.03
    WHEN SUM(AMOUNT) > 10000 THEN SUM(AMOUNT) * 0.02
    ELSE 0
  END AS DESCONTO
FROM 
  PAYMENTS
    INNER JOIN CUSTOMERS USING (CUSTOMERNUMBER)
WHERE 
  YEAR(PAYMENTDATE) IN (2003, 2004) 
AND MONTH(PAYMENTDATE) BETWEEN 1 AND 6
GROUP BY
  CLIENTE
ORDER BY 
  DESCONTO DESC
LIMIT 50;

select * from vw_Total;

/*
Crie uma consulta que retorne a unificação das consultas abaixo:
Consulta 1 - Total de produtos com quantidade de vendas acima de 550 com nota em 2004.
Consulta 2 - Total de clientes que pagaram acima de 100 mil em 2003 nos escritórios de Paris e Tokyo.
Consulta 3 - Total de vendedores que realizaram vendas acima de 200 mil em 2005.
*/

create or replace view vw_Total
as
SELECT 
  PRODUCTNAME,
  SUM(QUANTITYORDERED), 
  'PRODUTO'AS OBSERVACAO
FROM 
  PRODUCTS
    INNER JOIN ORDERDETAILS USING (PRODUCTCODE)
    INNER JOIN ORDERS USING (ORDERNUMBER)
WHERE 
  YEAR(ORDERDATE) = 2004
GROUP BY
  PRODUCTNAME
HAVING 
  SUM(QUANTITYORDERED) > 550;
  
select * from vw_Total;

create or replace view vw_Escritorio_total
as 
SELECT 
  CUSTOMERNAME AS CLIENTE, 
  SUM(AMOUNT) AS PAGTO, 
  'CLIENTE' AS OBSERVACAO
FROM 
  PAYMENTS 
    INNER JOIN CUSTOMERS USING (CUSTOMERNUMBER)
    INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
    INNER JOIN OFFICES USING (OFFICECODE)
WHERE 
  YEAR(PAYMENTDATE) = 2003
AND OFFICES.CITY IN ('Paris', 'Tokyo')
GROUP BY
  CLIENTE
HAVING 
  SUM(AMOUNT) > 100000;
  
select * from vw_Escritorio_total;

create or replace view vw_Vendedores
as
SELECT 
  CONCAT(FIRSTNAME, ' ', LASTNAME) AS VENDEDOR, 
  SUM(AMOUNT) AS TOTAL_VENDA, 
  'VENDEDORES' AS OBSERVACAO
FROM 
    PAYMENTS 
    INNER JOIN CUSTOMERS USING (CUSTOMERNUMBER)
    INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
WHERE 
   YEAR(PAYMENTDATE) = 2005
HAVING 
  SUM(AMOUNT) > 200000;
  
  select * from vw_Vendedores; 
  
  select * from  vw_Total
  union
  select * from vw_Escritorio_total
  union
  select * from vw_Vendedores; 
  
  create or replace view vw_Union
  as 
  (select * from  vw_Total limit 2)
  union
	(select * from vw_Escritorio_total	limit 2)
	union
    (select * from vw_Vendedores limit 2);
    
select * from vw_Union;

/*
Informe o total de clientes existentes em cada país, ordenando do maior para o menor. 
Considere os clientes que realizaram pagamentos em maio, junho e julho de 2005. 
O resultado deve estar limitado a 10 registros.
DICA: use DISTINCT dentro da função de contagem.
*/
USE SAKILA;
create or replace view vw_Cliente
as
SELECT 
  COUNTRY AS PAIS, 
  COUNT(DISTINCT CUSTOMER_ID) AS QTDE
FROM 
  COUNTRY
    INNER JOIN CITY USING (COUNTRY_ID)
    INNER JOIN ADDRESS USING (CITY_ID)
    INNER JOIN CUSTOMER USING (ADDRESS_ID)
    INNER JOIN PAYMENT USING (CUSTOMER_ID)
WHERE 
  YEAR(PAYMENT_DATE) = 2005
AND MONTH(PAYMENT_DATE) IN (5,6,7)
GROUP BY
 PAIS
ORDER BY QTDE DESC
LIMIT 10;

select * from vw_cliente;

#--------------------------------------------------------------------

/*
Crie uma consulta para realizar uma conferência da caixa, no mês de AGOSTO de 2005. Neste consulta, você deverá apresentar as seguintes informações:
Nome completo do cliente, valor_pago (somatório amount), analise_dia (tempo máximo de aluguel menos o tempo alugado) e analise
O campo analise deve fazer uma verificação, conforme abaixo: 
Se analise_dia for menor que zero e igual a 999 (calculo nulo), então escrever: 'Informar ao cliente ' + NOME_COMPLETO + ' tem restrições para alugar'
Do contrário, deve escrever:  'Informar ao cliente ' + NOME_COMPLETO + ‘que terá 10% de desconto’  
	DICA:
		tempo máximo de aluguel = rental_duration, 
tempo de alugado = (dia do aluguel) - (dia de retorno do film)
Utilize: IFNULL , CAST e CONCAT
	Importante: Sua consulta deve apresentar.
*/

USE SAKILA;
create or replace view vw_Caixa
as
SELECT 
  CONCAT(FIRST_NAME, ' ', LAST_NAME) AS CLIENTE, 
  SUM(AMOUNT) AS VALOR_PAGO, 
  IFNULL(RENTAL_DURATION - CAST(DATEDIFF(RETURN_DATE, RENTAL_DATE) AS DECIMAL), 999) AS ANALISE_DIA, 
  CASE 
    WHEN 
    IFNULL(RENTAL_DURATION - CAST(DATEDIFF(RETURN_DATE, RENTAL_DATE) AS DECIMAL), 999) < 0
      OR IFNULL(RENTAL_DURATION - CAST(DATEDIFF(RETURN_DATE, RENTAL_DATE) AS DECIMAL), 999) = 999
	THEN 
      CONCAT('Informar ao cliente ', FIRST_NAME, ' ', LAST_NAME, ' tem restrições para alugar')
    ELSE
      CONCAT('Informar ao cliente ', FIRST_NAME, ' ', LAST_NAME, ' que terá 10% de desconto')
  END AS ANALISE
FROM 
  CUSTOMER
    INNER JOIN PAYMENT USING(CUSTOMER_ID)
    INNER JOIN RENTAL USING (RENTAL_ID)
    INNER JOIN INVENTORY USING (INVENTORY_ID)
    INNER JOIN FILM USING (FILM_ID)
WHERE 
   YEAR(PAYMENT_DATE) = 2005
AND MONTH(PAYMENT_DATE) = 8
GROUP BY
  CLIENTE, ANALISE_DIA, ANALISE
LIMIT 10;

select * from vw_Caixa;

/*
Crie uma consulta para retornar o filme presente no estoque que NÃO FORAM ALUGADOS.
O resultado a sua consulta deve apresentar. 
o título do filme, a loja, a categoria e a quantidade de cópias existentes no estoque:

DICA:Utilizar dois tipos de JOINS.
*/
create or replace view vw_Filme
as
SELECT 
  TITLE AS TITULO, 
  STORE_ID AS LOJA, 
  NAME AS CATEGORIA, 
  COUNT(INVENTORY_ID) AS QTDE
FROM 
  CATEGORY
    INNER JOIN FILM_CATEGORY USING (CATEGORY_ID)
    INNER JOIN FILM USING (FILM_ID)
    INNER JOIN INVENTORY USING (FILM_ID)
    LEFT JOIN RENTAL USING (INVENTORY_ID)
WHERE 
  RENTAL_ID IS NULL
GROUP BY
  TITULO, LOJA, CATEGORIA;
  
select * from vw_Filme;

/*
Faça uma consulta que retorne a quantidade de filmes existentes no estoque (inventory) por loja, para as categorias de Drama (Drama) e Comédia (Comedy).  
*/  
create or replace view vw_QFilmes
as
SELECT 
  NAME AS CATEGORIA, 
  STORE_ID AS LOJA, 
  COUNT(INVENTORY_ID) AS QTDE
FROM 
  CATEGORY
    INNER JOIN FILM_CATEGORY USING (CATEGORY_ID)
    INNER JOIN FILM USING (FILM_ID)
    INNER JOIN INVENTORY USING (FILM_ID)
WHERE 
  CATEGORY.NAME IN ('Comedy', 'Drama') 
GROUP BY
  CATEGORIA, LOJA;
  
select * from vw_QFilmes