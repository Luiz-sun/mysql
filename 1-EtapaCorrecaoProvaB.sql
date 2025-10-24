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
	Importante: Sua consulta deve apresentar apenas 10 linhas.
*/

USE SAKILA;

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


/*
Crie uma consulta para retornar o filme presente no estoque que NÃO FORAM ALUGADOS.
O resultado a sua consulta deve apresentar. 
o título do filme, a loja, a categoria e a quantidade de cópias existentes no estoque:

DICA:Utilizar dois tipos de JOINS.
*/

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
  
  
/*
Faça uma consulta que retorne a quantidade de filmes existentes no estoque (inventory) por loja, para as categorias de Drama (Drama) e Comédia (Comedy).  
*/  

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