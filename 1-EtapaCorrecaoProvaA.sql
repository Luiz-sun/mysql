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

/*
Crie uma consulta que retorne a unificação das consultas abaixo:
Consulta 1 - Total de produtos com quantidade de vendas acima de 550 com nota em 2004.
Consulta 2 - Total de clientes que pagaram acima de 100 mil em 2003 nos escritórios de Paris e Tokyo.
Consulta 3 - Total de vendedores que realizaram vendas acima de 200 mil em 2005.
*/
SELECT 
  OBSERVACAO, 
  COUNT(OBSERVACAO) TOTAL
FROM (
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
  SUM(QUANTITYORDERED) > 550
UNION
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
  SUM(AMOUNT) > 100000
UNION   
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
  SUM(AMOUNT) > 200000) AS RESULTADO
GROUP BY OBSERVACAO;

/*
Informe o total de clientes existentes em cada país, ordenando do maior para o menor. 
Considere os clientes que realizaram pagamentos em maio, junho e julho de 2005. 
O resultado deve estar limitado a 10 registros.
DICA: use DISTINCT dentro da função de contagem.
*/
USE SAKILA;
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

/*
Observe o modelo conceitual abaixo e crie três tabelas representando as três entidades existentes. 
As chaves estrangeiras devem ser criadas com restrição de exclusão explícita. 
Você deverá colocar pelo menos dois atributos em cada uma das entidades.
*/
CREATE TABLE AVATAR (
  IDAVATAR INT NOT NULL auto_increment PRIMARY KEY, 
  NOME VARCHAR(100)
) ENGINE = INNODB;

CREATE TABLE ACESSORIO(
  IDACESSORIO INT NOT NULL auto_increment PRIMARY KEY, 
  NOME VARCHAR(100)
)ENGINE = INNODB;

CREATE TABLE AVATAR_ACESSORIO(
  IDACESSORIO INT NOT NULL,
  IDAVATAR INT NOT NULL,
  foreign key (IDACESSORIO) REFERENCES ACESSORIO (IDACESSORIO) ON DELETE RESTRICT,
  foreign key (IDAVATAR) REFERENCES AVATAR (IDAVATAR) ON DELETE RESTRICT 
)ENGINE = INNODB;