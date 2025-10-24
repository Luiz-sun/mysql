#SIMULADO 2 - TIPO B
/*
b) Crie um consulta para unificar as duas consultas abaixo: 
i) A quantidade de clientes, total de pagamentos por loja quando o meses de pagamento estiverem entre 5 e 8 de 2005, 
considerando apenas clientes ativos; (Cuidado para não fazer joins desnecessários) 
ii) A quantidade de clientes, total de pagamentos por loja quando a quantidade de países (Use distinct) for maior que 5. 
*/

SELECT 
  COUNT(DISTINCT CUSTOMER_ID) AS QTDE_CLIENTE, 
  SUM(AMOUNT) AS TOTAL_PAG, 
  STORE_ID AS LOJA
FROM 
  CUSTOMER 
    INNER JOIN PAYMENT USING (CUSTOMER_ID)
WHERE 
    YEAR(PAYMENT_DATE) = 2005
AND MONTH(PAYMENT_DATE) BETWEEN 5 AND 8
AND ACTIVE = 1
GROUP BY 
  LOJA
UNION  
SELECT 
  COUNT(DISTINCT CUSTOMER_ID) AS QTDE_CLIENTE, 
  SUM(AMOUNT) AS TOTAL_PAG, 
  STORE_ID AS LOJA
FROM 
  CUSTOMER 
    INNER JOIN PAYMENT USING (CUSTOMER_ID)
    INNER JOIN ADDRESS USING (ADDRESS_ID)
    INNER JOIN CITY USING (CITY_ID)
    INNER JOIN COUNTRY USING (COUNTRY_ID)
GROUP BY
  LOJA
HAVING 
  COUNT(COUNTRY_ID) > 5;
  

/*
a) Crie uma consulta que retorne o total de valores recebidos por país em cada uma das lojas nos meses 8 e 5 de 2005. 
Calcule uma retirada de 25% do valor total recebido. 
Dica: 
● Lembre-se que todos os nomes das colunas devem estar em português. ● Funções úteis: Year(), Month(), Day(); 
● 25% -> 0.25 
*/
SELECT 
  COUNTRY AS PAIS,
  SUM(AMOUNT) AS TOTAL_PAG, 
  ROUND(SUM(AMOUNT) * 0.25,2) AS RETIRADA
FROM 
  CUSTOMER 
    INNER JOIN PAYMENT USING (CUSTOMER_ID)
    INNER JOIN ADDRESS USING (ADDRESS_ID)
    INNER JOIN CITY USING (CITY_ID)
    INNER JOIN COUNTRY USING (COUNTRY_ID)
WHERE 
    YEAR(PAYMENT_DATE) = 2005
AND MONTH(PAYMENT_DATE) IN (5,8)
GROUP BY 
  PAIS;
  
USE SAKILA;
/*
c) Informe o total de pagamento recebidos por categoria, quando o filme tiver duração de aluguel (rental_duration) for igual a 3 ou 5 e tamanho (length) for maior que 100. 
*/  
  
SELECT 
   SUM(AMOUNT) AS VALOR_PAGO, 
   CATEGORY.NAME AS CATEGORIA
FROM 
   CATEGORY
     INNER JOIN FILM_CATEGORY USING (CATEGORY_ID)
     INNER JOIN FILM USING (FILM_ID)
	 INNER JOIN INVENTORY USING (FILM_ID)
     INNER JOIN RENTAL USING (INVENTORY_ID)
     INNER JOIN PAYMENT USING (RENTAL_ID)
WHERE
    RENTAL_DURATION IN (3,5)
AND LENGTH > 100
GROUP BY
  CATEGORIA;
  

# SIMULADO 01 - A
USE CLASSICMODELS;
/*
a) Identifique quais produtos por escritório (city) que tiveram mais vendas nos três primeiros meses de 2003.
*/

SELECT 
  OFFICES.CITY AS ESCRITORIO,
  PRODUCTNAME AS PRODUTO, 
  SUM(QUANTITYORDERED) AS QTDE
FROM 
  PRODUCTS
    INNER JOIN ORDERDETAILS USING (PRODUCTCODE)
    INNER JOIN ORDERS USING (ORDERNUMBER)
    INNER JOIN CUSTOMERS USING (CUSTOMERNUMBER)
    INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
    INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
    INNER JOIN OFFICES USING (OFFICECODE)
WHERE 
    MONTH(PAYMENTDATE) IN (1,2,3)
AND YEAR(PAYMENTDATE) = 2003
GROUP BY
  OFFICES.CITY, PRODUCTNAME
ORDER BY 
  QTDE DESC;


# SIMULADO 1 - B
USE SAKILA;
/* 
A) Identifique o idioma e a categoria dos filmes mais alugados, mostrando a quantidade alugada e o valor acumulado em 2005. 
Você deve mostrar em seu resultado o idioma, a categoria e as demais informações solicitadas.
*/

SELECT 
   LANGUAGE.NAME AS IDIOMA, 
   CATEGORY.NAME AS CATEGORIA, 
   COUNT(RENTAL_ID) AS QTDE_ALUGADA, 
   SUM(AMOUNT) AS VALOR_ACUMULADO
FROM 
   CATEGORY
     INNER JOIN FILM_CATEGORY USING (CATEGORY_ID)
     INNER JOIN FILM USING (FILM_ID)
     INNER JOIN LANGUAGE USING (LANGUAGE_ID)
     INNER JOIN INVENTORY USING (FILM_ID)
     INNER JOIN RENTAL USING (INVENTORY_ID)
     INNER JOIN PAYMENT USING (RENTAL_ID)
WHERE 
   YEAR(PAYMENT_DATE) = 2005
GROUP BY
   IDIOMA, CATEGORIA;
   
USE CLASSICMODELS;   
# SIMULADO 2 - A
/*
a) Crie uma consulta que retorne o cliente, sua cidade e total pago considerando que 
podem existir clientes que não efetuaram pagamentos. Você deve considerar os pagamentos realizados em 2005 ou que o limite de crédito é zero. 
Devem ser retornados aqueles clientes que tiverem pagamento maior que 100.000. Dicas: 
● No caso, está sendo priorizada uma tabela em relação a outra. A ordem das tabelas importa (use LEFT ou RIGHT join). 
● Valores nulos devem ser tratados como zero. (use IFNULL). 
● Funções úteis: Year(), Month(), Day(); 
● Campo limite de créditos -> creditLimit (tabela Customers). 
● Os nomes das colunas devem estar em português. 
*/

SELECT 
  CUSTOMERNAME AS CLIENTE, 
  CITY AS CIDADE, 
  IFNULL(SUM(AMOUNT),0) AS VALOR_PAGO
FROM 
  CUSTOMERS
    LEFT JOIN PAYMENTS USING (CUSTOMERNUMBER)
WHERE 
   YEAR(PAYMENTDATE) = 2005
OR CREDITLIMIT = 0
GROUP BY 
   CLIENTE, CIDADE
HAVING 
  VALOR_PAGO > 100000;

# dica da prova
SELECT
  CONCAT('O cliente :' , customerName, 'pagou o valor: ', sum(amount)) OBSERVACAO
FROM
  CUSTOMERS
    INNER JOIN PAYMENTS USING (CUSTOMERNUMBER)
GROUP BY
  customerName;
  
  
# UTILIZANDO O CASE
SELECT 
   CONCAT(FIRSTNAME, ' ', LASTNAME) AS VENDEDOR, 
   SUM(AMOUNT) AS TOTAL_VENDIDO, 
   CASE 
     WHEN  SUM(AMOUNT) > CREDITLIMIT THEN 'CONVERSAR COM O CLIENTE'
     ELSE 'AUMENTAR O VALOR DE CREDITO'
	END AS SITUACAO
FROM 
   PAYMENTS
     INNER JOIN CUSTOMERS USING (CUSTOMERNUMBER)
     INNER JOIN EMPLOYEES ON SALESREPEMPLOYEENUMBER = EMPLOYEENUMBER
WHERE 
    YEAR(PAYMENTDATE) = 2004
AND MONTH(PAYMENTDATE) IN (4,5,6)
GROUP BY
  VENDEDOR;

# SIMULADO 2 - TIP B - QUESTAO 2 
SELECT * FROM COUNTRYLANGUAGE;
USE WORLD;
SELECT
  ROUND(SUM(Percentage * POPULATION)/100,2) AS TOTAL_FALANTES, 
  LANGUAGE AS IDIOMA, 
  NAME AS PAIS
FROM 
  COUNTRY 
    INNER JOIN COUNTRYLANGUAGE ON CODE = COUNTRYCODE
WHERE 
  CONTINENT = 'Asia'
GROUP BY
  IDIOMA, PAIS;