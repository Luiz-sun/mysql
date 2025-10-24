/*
Crie uma procedure que irá receber o código do cliente (sem crédito) e um código do vendedor como entrada.
Na sequência, dentro da procedure execute os seguintes passos:
0 - Inicie uma transação ok
1 - Atualize o credito do cliente para 100.000 ok
2 - Realizar o pedido para o cliente (Orders) OK
3 - Gere os itens do pedido para o cliente
     3.1 - Serão associados ao clientes os 5 produtos mais vendidos. (use cursor) OK
     3.2 - Você deverá colocar a quantidade de compra igual os três últimos números da sua matricula. OK
4 - Caso o produto não tenha no estoque, você deverá dar um RollBack OK
5 - De baixa no estoque com base na quantidade comprada para cada produto. OK
6 - Realize o vinculo do cliente com o vendedor.
7 - Realize um faturamento do pedido (Payments).
*/

DESCRIBE PRODUCTS;
DESCRIBE ORDERDETAILS;
DESCRIBE PAYMENTS;
DELIMITER $
CREATE PROCEDURE CLIENTE_SEM_CRED(INOUT CODIGO_VENDEDOR VARCHAR(20))
BEGIN
  DECLARE DONE BOOL DEFAULT FALSE;
  DECLARE VAR_PRODUTO VARCHAR(15);
  DECLARE ESTOQUE INT;
  DECLARE PRECO_VENDA DECIMAL(10,2);
  DECLARE FATURAMENTO DECIMAL (10,2);
  DECLARE NUMERO_PEDIDO INT;
  DECLARE CONTADOR INT;
 
  DECLARE CURSOR_PRODUTOS_MAIS_VENDIDOS CURSOR FOR
    SELECT
     PRODUTCODE, QUANTITYINSTOCK, MSRP
        FROM PRODUTCS
     INNER JOIN ORDERDETAILS USING (PRODUCTCODE)
          ORDER BY QUANTITIYORDEDERED
          LIMIT 5;
 
  DECLARE CONTINUE HANDLER FOR
    NOT FOUND SET DONE = TRUE;
 
  START TRANSACTION;
 
     UPDATE CUSTOMERS SET creditLimit = 100000 WHERE creditLimit = 0 ;

     SELECT MAX(ORDERNUMBER) + 1 INTO NUMERO_PEDIDO FROM ORDERS;

     INSERT INTO ORDERS (orderNumber, orderDate, requiredDate, shippedDate, status, customerNumber)
    VALUES (NUMERO_PEDIDO, current_date, date_format(current_date() + 7, '%Y-%M-%D'),date_format(current_date() + 5, '%Y-%M-%D'), 'shiped', CodigoCliente);
     
     OPEN CURSOR_PRODUTOS_MAIS_VENDIDOS;
     
     SET CONTADOR = 1;
     
     PROCESS_LISTA: LOOP
       
        FETCH CURSOR_PRODUTOS_MAIS_VENDIDOS INTO VAR_PRODUTO, ESTOQUE, PRECO_VENDA;
       
        IF DONE = TRUE THEN
          LEAVE PROCESS_LISTA;
        END IF;
       
        IF 151 <= ESTOQUE THEN
          INSERT INTO ORDERDETAILS (ORDERNUMBER, PRODUCTCODE, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER)
             VALUES(NUMERO_PEDIDO, VAR_PRODUTO, 151, PRECO_VENDA, CONTADOR);
             
  UPDATE PRODUCTS SET QUANTITYINSTOCK = (ESTOQUE - 151) WHERE PRODUCTCODE = VAR_PRODUTO;
        ELSE
           ROLLBACK;
           LEAVE PROCESS_LISTA;
        END IF;
       
        UPDATE CUSTOMERS SET SALESREPEMPLOYNUMBER = CODIGO_VENDEDOR WHERE CUSTOMERNUMBER = CODIGO_CLIENTE;
       
        SELECT SUM(PRICEEACH * QUANTITYORDERED) INTO FATURAMENTO FROM ORDERDETAILS WHERE ORDERNUMBER = NUMERO_PEDIDO;
       
        INSERT INTO PAYMENTS (CUSTOMERNUMBER, CHECKNUMER, PAYMENTDATE, AMOUNT)
          VALUES(CODIGO_CLIENTE, '7138934IAUD', CURRENT_DATE(), FATURAMENTO );
         
     END LOOP;
END $
DELIMITER ;