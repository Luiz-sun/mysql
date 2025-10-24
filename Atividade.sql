-- 1. Criar o database
CREATE DATABASE IF NOT EXISTS LojaBancoDados2;
USE LojaBancoDados2;

---

-- 2. Criar as tabelas

-- Tabela Produto
CREATE TABLE Produto (
    CodigoProduto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    qtde_estoque INT NOT NULL DEFAULT 0
);

-- Tabela Cliente
CREATE TABLE Cliente (
    CodigoCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    cpf VARCHAR(14) UNIQUE
);

-- Tabela Pedido
CREATE TABLE Pedido (
    CodigoPedido INT PRIMARY KEY AUTO_INCREMENT,
    dataPedido DATE NOT NULL,
    status VARCHAR(50) NOT NULL
);

-- Tabela Funcionario
-- Foi usada no lugar de "Vendedor" para as triggers, conforme solicitado.
CREATE TABLE Funcionario (
    CodigoFuncionario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    funcao VARCHAR(50),
    cidade VARCHAR(100)
);

-- Tabela ItemPedido (com chaves estrangeiras)
CREATE TABLE ItemPedido (
    CodigoPedido INT NOT NULL,
    CodigoProduto INT NOT NULL,
    PrecoVenda DECIMAL(10, 2) NOT NULL,
    Qtde INT NOT NULL,
    PRIMARY KEY (CodigoPedido, CodigoProduto),
    FOREIGN KEY (CodigoPedido) REFERENCES Pedido(CodigoPedido) ON DELETE CASCADE,
    FOREIGN KEY (CodigoProduto) REFERENCES Produto(CodigoProduto)
);

--

-- 3. Criar a tabela Auditoria
CREATE TABLE Auditoria (
    IdAuditoria INT PRIMARY KEY AUTO_INCREMENT,
    DataModificacao DATETIME NOT NULL,
    nometabela VARCHAR(100) NOT NULL,
    historico TEXT
);

--

-- 4. Criar as Triggers de Insert, Update e Delete
-- Usando DELIMITER para definir os blocos de triggers

DELIMITER $


-- TRIGGERS PARA PRODUTO


-- Trigger de INSERT
CREATE TRIGGER tr_Produto_Insert
AFTER INSERT ON Produto
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Produto', CONCAT('INSERIDO: Código ', NEW.CodigoProduto, ', Nome: ', NEW.nome));
END$

-- Trigger de UPDATE
CREATE TRIGGER tr_Produto_Update
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Produto', CONCAT('ATUALIZADO (Código ', OLD.CodigoProduto, '). Mudança: Estoque de ', OLD.qtde_estoque, ' para ', NEW.qtde_estoque, ', Nome de ', OLD.nome, ' para ', NEW.nome));
END$

-- Trigger de DELETE
CREATE TRIGGER tr_Produto_Delete
BEFORE DELETE ON Produto
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Produto', CONCAT('DELETADO: Código ', OLD.CodigoProduto, ', Nome: ', OLD.nome));
END$

-- 

-- TRIGGERS PARA CLIENTE


-- Trigger de INSERT
CREATE TRIGGER tr_Cliente_Insert
AFTER INSERT ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Cliente', CONCAT('INSERIDO: Código ', NEW.CodigoCliente, ', Nome: ', NEW.nome, ', CPF: ', NEW.cpf));
END$

-- Trigger de UPDATE
CREATE TRIGGER tr_Cliente_Update
AFTER UPDATE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Cliente', CONCAT('ATUALIZADO (Código ', OLD.CodigoCliente, '). Nome de ', OLD.nome, ' para ', NEW.nome, ', Email: ', NEW.email));
END$

-- Trigger de DELETE
CREATE TRIGGER tr_Cliente_Delete
BEFORE DELETE ON Cliente
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Cliente', CONCAT('DELETADO: Código ', OLD.CodigoCliente, ', Nome: ', OLD.nome));
END$



-- TRIGGERS PARA PEDIDO


-- Trigger de INSERT
CREATE TRIGGER tr_Pedido_Insert
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Pedido', CONCAT('INSERIDO: Pedido ', NEW.CodigoPedido, ', Data: ', NEW.dataPedido, ', Status: ', NEW.status));
END$

-- Trigger de UPDATE
CREATE TRIGGER tr_Pedido_Update
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Pedido', CONCAT('ATUALIZADO (Código ', OLD.CodigoPedido, '). Status de ', OLD.status, ' para ', NEW.status));
END$

-- Trigger de DELETE
CREATE TRIGGER tr_Pedido_Delete
BEFORE DELETE ON Pedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Pedido', CONCAT('DELETADO: Pedido ', OLD.CodigoPedido, ', Status: ', OLD.status));
END$



-- TRIGGERS PARA ITEMPEDIDO


-- Trigger de INSERT
CREATE TRIGGER tr_ItemPedido_Insert
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'ItemPedido', CONCAT('INSERIDO: Pedido ', NEW.CodigoPedido, ', Produto ', NEW.CodigoProduto, ', Qtde: ', NEW.Qtde));
END$

-- Trigger de UPDATE
CREATE TRIGGER tr_ItemPedido_Update
AFTER UPDATE ON ItemPedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'ItemPedido', CONCAT('ATUALIZADO: Pedido ', OLD.CodigoPedido, ', Produto ', OLD.CodigoProduto, '. Qtde de ', OLD.Qtde, ' para ', NEW.Qtde));
END$

-- Trigger de DELETE
CREATE TRIGGER tr_ItemPedido_Delete
BEFORE DELETE ON ItemPedido
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'ItemPedido', CONCAT('DELETADO: Pedido ', OLD.CodigoPedido, ', Produto ', OLD.CodigoProduto));
END$

-- TRIGGERS PARA FUNCIONARIO (Usado no lugar de Vendedor)

-- Trigger de INSERT
CREATE TRIGGER tr_Funcionario_Insert
AFTER INSERT ON Funcionario
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Funcionario', CONCAT('INSERIDO: Código ', NEW.CodigoFuncionario, ', Nome: ', NEW.nome, ', Função: ', NEW.funcao));
END$

-- Trigger de UPDATE
CREATE TRIGGER tr_Funcionario_Update
AFTER UPDATE ON Funcionario
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Funcionario', CONCAT('ATUALIZADO (Código ', OLD.CodigoFuncionario, '). Nome de ', OLD.nome, ' para ', NEW.nome, ', Função: ', NEW.funcao));
END$

-- Trigger de DELETE
CREATE TRIGGER tr_Funcionario_Delete
BEFORE DELETE ON Funcionario
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (DataModificacao, nometabela, historico)
    VALUES (NOW(), 'Funcionario', CONCAT('DELETADO: Código ', OLD.CodigoFuncionario, ', Nome: ', OLD.nome));
END$


-- 5. Criar uma procedure para cada tabela para inserir os dados, exceto para Pedido e ItemPedido.


-- Procedure para inserir PRODUTO
CREATE PROCEDURE InserirProduto (
    IN p_nome VARCHAR(100),
    IN p_descricao TEXT,
    IN p_qtde_estoque INT
)
BEGIN
    INSERT INTO Produto (nome, descricao, qtde_estoque)
    VALUES (p_nome, p_descricao, p_qtde_estoque);
END$

-- Procedure para inserir CLIENTE
CREATE PROCEDURE InserirCliente (
    IN p_nome VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_cpf VARCHAR(14)
)
BEGIN
    INSERT INTO Cliente (nome, email, cpf)
    VALUES (p_nome, p_email, p_cpf);
END$

-- Procedure para inserir FUNCIONARIO (Vendedor)
CREATE PROCEDURE InserirFuncionario (
    IN p_nome VARCHAR(100),
    IN p_funcao VARCHAR(50),
    IN p_cidade VARCHAR(100)
)
BEGIN
    INSERT INTO Funcionario (nome, funcao, cidade)
    VALUES (p_nome, p_funcao, p_cidade);
END$
/*Criar procedure auditoria: Erro linha 261*/
delimiter ;

-- 7. PROCEDURE PARA INSERIR PEDIDO E ITEMPEDIDO (TRANSAÇÃO, CURSOR E VALIDAÇÕES)

delimiter $
CREATE PROCEDURE sp_criar_pedido_completo(
    IN p_codigo_cliente INT,
    IN p_codigo_funcionario INT,
    IN p_itens_json JSON
)
BEGIN
    -- Variáveis para o loop e dados do item
    DECLARE v_id_pedido INT;
    DECLARE v_total_itens INT;
    DECLARE i INT DEFAULT 0;
    DECLARE v_cod_produto INT;
    DECLARE v_qtde_item INT;
    DECLARE v_preco_produto DECIMAL(10, 2);
    DECLARE v_estoque_atual INT;

    -- Handler para reverter a transação em caso de erro
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL; -- Propaga o erro para o cliente que chamou a procedure
    END;

    -- Inicia a transação
    START TRANSACTION;

    -- 1. VALIDAÇÃO: Verifica se o cliente e o funcionário existem
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CodigoCliente = p_codigo_cliente) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Cliente não encontrado.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Funcionario WHERE CodigoFuncionario = p_codigo_funcionario) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Funcionário não encontrado.';
    END IF;

    -- 2. INSERÇÃO DO PEDIDO: Cria o pedido principal para obter o ID
    INSERT INTO Pedido (CodigoCliente, CodigoFuncionario, dataPedido, status)
    VALUES (p_codigo_cliente, p_codigo_funcionario, NOW(), 'Processando');

    SET v_id_pedido = LAST_INSERT_ID(); -- Pega o ID do pedido recém-criado

    -- 3. LOOP (simulando um cursor) PARA PROCESSAR OS ITENS DO JSON
    SET v_total_itens = JSON_LENGTH(p_itens_json);

    WHILE i < v_total_itens DO
        -- Extrai os dados do item atual do array JSON
        SET v_cod_produto = JSON_UNQUOTE(JSON_EXTRACT(p_itens_json, CONCAT('$[', i, '].CodigoProduto')));
        SET v_qtde_item = JSON_UNQUOTE(JSON_EXTRACT(p_itens_json, CONCAT('$[', i, '].Qtde')));

        -- 4. VALIDAÇÃO DE ESTOQUE: Busca o preço e o estoque do produto
        SELECT preco, qtde_estoque INTO v_preco_produto, v_estoque_atual
        FROM Produto WHERE CodigoProduto = v_cod_produto;

        IF v_estoque_atual IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Produto não encontrado.';
        END IF;

        IF v_qtde_item > v_estoque_atual THEN
            SIGNAL SQLSTATE '45000' SET  MESSAGE_TEXT= 'Erro: Estoque insuficiente para o produto ID ';
        END IF; /* erro no conct*/

        -- 5. INSERÇÃO DO ITEM DO PEDIDO
        INSERT INTO ItemPedido (CodigoPedido, CodigoProduto, PrecoVenda, Qtde)
        VALUES (v_id_pedido, v_cod_produto, v_preco_produto, v_qtde_item);

        -- 6. ATUALIZAÇÃO DO ESTOQUE
        UPDATE Produto
        SET qtde_estoque = qtde_estoque - v_qtde_item
        WHERE CodigoProduto = v_cod_produto;

        SET i = i + 1; -- Próximo item
    END WHILE;

    -- Se tudo correu bem, confirma a transação
    COMMIT;

END$

DELIMITER ;



-- 6.  Criar a JSON Carrinho (CodigoProduto, CodigoCliente, CodigoVendedor, Qtde). Aplicar JSON extract




CALL InserirCliente('Joao Silva', 'joao9@email.com', '111.111.111-11'); -- Cliente Codigo 1
CALL InserirFuncionario('Maria Vendedora', 'Vendedor', 'Sao Paulo'); -- Funcionario Codigo 1
CALL InserirProduto('Teclado Mecânico', 'Teclado RGB', 10); -- Produto Codigo 1
CALL InserirProduto('Mouse Gamer', 'Mouse Optico', 5); -- Produto Codigo 2

SET @json_carrinho = '{
    "CodigoCliente": 1,
    "CodigoFuncionario": 1,
    "Itens": [
        { "CodigoProduto": 101, "Qtde": 3, "PrecoVenda": 50.00 },
        { "CodigoProduto": 102, "Qtde": 1, "PrecoVenda": 150.00 }
    ]
}';

SELECT
    -- Acessando um campo principal:
    JSON_EXTRACT(@json_carrinho, '$.CodigoCliente') AS Cliente,

    -- Acessando o primeiro elemento do array "Itens" (posição [0]):
    JSON_EXTRACT(@json_carrinho, '$.Itens[0].CodigoProduto') AS Primeiro_Produto_ID,
    JSON_EXTRACT(@json_carrinho, '$.Itens[0].Qtde') AS Qtde_Primeiro_Item,
    
    -- Acessando o segundo elemento do array "Itens" (posição [1]):
    JSON_EXTRACT(@json_carrinho, '$.Itens[1].CodigoProduto') AS Segundo_Produto_ID;


-- =========================================================
-- 8. CRIAÇÃO DA VIEW (Produtos mais vendidos)
-- =========================================================

CREATE VIEW ProdutosMaisVendidos AS
SELECT
    P.CodigoProduto,
    P.nome AS NomeProduto,
    SUM(IP.Qtde) AS TotalVendido
FROM
    Produto P
JOIN
    ItemPedido IP ON P.CodigoProduto = IP.CodigoProduto
GROUP BY
    P.CodigoProduto, P.nome
ORDER BY
    TotalVendido DESC;
    
    select * from ProdutosMaisVendidos;
    

    
    