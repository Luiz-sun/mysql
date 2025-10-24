create database LojaBancoDados2;
use LojaBancoDados2;

create table Produto(
CodigoProduto int auto_increment primary key,
Nome varchar(100),
Descricao text,
Qtde_estoque int
) engine= InnoDB;

create table Cliente(
CodigoCliente int auto_increment primary key,
Nome varchar(100),
Email varchar(100),
Cpf varchar(100)
)engine= InnoDB;

create table Pedido(
CodigoPedido int auto_increment primary key,
dataPedido date not null,
status varchar(20)
)engine= InnoDB;

create table ItemPedido(
CodigoPedido int,
CodigoProduto int,
PrecoVenda decimal(10,2) not null,
Qtde INT,
PRIMARY KEY (CodigoPedido, CodigoProduto),
    FOREIGN KEY (CodigoPedido) REFERENCES Pedido(CodigoPedido),
    FOREIGN KEY (CodigoProduto) REFERENCES Produto(CodigoProduto)
)engine= InnoDB;

create table Funcionario(
CodigoFuncionario int auto_increment primary key,
Nome varchar(100),
Funcao varchar(50),
Cidade varchar(50)
)engine= InnoDB;

drop table Auditoria;
create table Auditoria(
DataModificacao datetime default current_timestamp,
NomeTabela varchar(50),
Historico text
)engine= InnoDB;

/*triggers*/
#Produto 

delimiter %
 create trigger trg_produto_inser after insert on Produto
for each row 
	begin
		insert into Auditoria(DataModificacao, NomeTabela,Historico )
		value('Produto;', concat("Codigo do novo produto: ", new.CodigoProduto, "Nome do produto", new.Nome, 
        "Quantidade do produto", NEW.Qtde_estoque));
    end %

CREATE TRIGGER trg_produto_update
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Produto',
          CONCAT('Produto atualizado: ID=', OLD.CodigoProduto, 
                 ', Nome antigo=', OLD.Nome, ', Novo nome=', NEW.Nome,
                 ', Qtde antiga=', OLD.Qtde_estoque, ', Nova qtde=', NEW.Qtde_estoque));
END%

CREATE TRIGGER trg_produto_delete
AFTER DELETE ON Produto
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Produto',
          CONCAT('Produto excluído: Nome=', OLD.Nome, ', Qtde=', OLD.Qtde_estoque));
END%
delimiter ;

#Cliente

DELIMITER $

CREATE TRIGGER trg_cliente_insert
AFTER INSERT ON Cliente
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Cliente',
    CONCAT('Cliente inserido: Nome=', NEW.Nome, ', Email=', NEW.Email));
END$

CREATE TRIGGER trg_cliente_update
AFTER UPDATE ON Cliente
FOR EACH ROW
BEGIN
 INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
 VALUES ('Cliente',
    CONCAT('Cliente atualizado: Nome antigo: ', OLD.Nome, ', Novo nome: ', NEW.Nome,
		"Email velho: ", old.Email, "Novo email: ", new.Email));
END$

CREATE TRIGGER trg_cliente_delete
AFTER DELETE ON Cliente
FOR EACH ROW
BEGIN
   INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Cliente',
    CONCAT('Cliente excluído: Nome: ', OLD.Nome, ', Email: ', OLD.Email, "Codigo: ", 
    old.CodigoCliente, "Cpf: ", old.Cpf));
END$

DELIMITER ;

#pedido

delimiter %
CREATE TRIGGER trg_pedido_insert
AFTER INSERT ON Pedido
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Pedido',
    CONCAT('Pedido inserido: Código: ', NEW.CodigoPedido, ', Status: ', NEW.Status));
END%

CREATE TRIGGER trg_pedido_update
AFTER UPDATE ON Pedido
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Pedido',
    CONCAT('Pedido atualizando, Pedido velho: ', old.CodigoPedido, 'Pedido novo: ', new.CodigoPedido, 
    ', Status velho: ', old.Status, 'Status novo: ', new.Status));
END%

CREATE TRIGGER trg_pedido_delete
AFTER DELETE ON Pedido
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Pedido',
    CONCAT('Pedido excluído: Código=', OLD.CodigoPedido, ', Status=', OLD.Status));
END%

delimiter ; 

#ItemPedido

delimiter %
CREATE TRIGGER trg_itempedido_insert
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('ItemPedido',
    CONCAT('Item adicionado ao pedido: ', NEW.CodigoPedido,
           ' Produto: ', NEW.CodigoProduto, ', Quantidade: ', NEW.Qtde));
END%

CREATE TRIGGER trg_itempedido_update
AFTER UPDATE ON ItemPedido
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('ItemPedido',
    CONCAT('Item do pedido atualizado: Pedido: ', OLD.CodigoPedido,
           ', Produto: ', OLD.CodigoProduto,
           ', Quantidade antiga: ', OLD.Qtde, ', Nova Quantidade: ', NEW.Qtde));
END%

CREATE TRIGGER trg_itempedido_delete
AFTER DELETE ON ItemPedido
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('ItemPedido',
    CONCAT('Item removido do pedido :', OLD.CodigoPedido,
           ' Produto: ', OLD.CodigoProduto, ', Quantidade: ', OLD.Qtde));
END%

delimiter ;

#Vendedor

delimiter %
CREATE TRIGGER trg_funcionario_insert
AFTER INSERT ON Funcionario
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Funcionario',
    CONCAT(' Funcionario: ', NEW.CodigoFuncionario,
           ' Nome: ', NEW.Nome, ', Funcao: ', NEW.Funcao, 'Cidade', new.Cidade));
END%

CREATE TRIGGER trg_funcionario_update
AFTER UPDATE ON Funcionario
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Funcionario',
    CONCAT(' Atualizando informação funcionario: ', 
           ' Nome antigo: ', old.Nome, 'Nome novo: ', new.Nome, ' Funcao velha: ', old.Funcao, 
           'Funcao nova:', new.Funcao, 'Cidade velha:', old.Cidade, 'Cidade nova: ', new.Cidade));
END%  /*Concertado tava faltando uma firgula.*/

CREATE TRIGGER trg_funcionario_delete
AFTER DELETE ON Funcionario
FOR EACH ROW
BEGIN
  INSERT INTO Auditoria (DataModificacao, NomeTabela, Historico)
  VALUES ('Funcionario',
    CONCAT('Delete infomação funcionario', 
           ' Nome: ', old.Nome, ' Funcao: ', old.Funcao, 
            'Cidade: ', old.Cidade, 'Codigo: ', old.CodigoFuncionario));
END%

delimiter ;

#Procedure

delimiter %

create procedure InserirProduto(
    in p_Nome varchar(100),
    in p_Descricao text,
    in p_Qtde_estoque int
)
begin
    insert into Produto (Nome, Descricao, Qtde_estoque)
    values (p_Nome, p_Descricao, p_Qtde_estoque);
end%

delimiter ;

CALL InserirProduto('Caneta Azul', 'Caneta esferográfica azul', 150); /*Concertado passou*/

delimiter %

create procedure InserirCliente(
    in p_Nome varchar(100),
    in p_Email varchar(100),
    in p_Cpf varchar(100)
)
begin
    insert into Cliente (Nome, Email, Cpf)
    values (p_Nome, p_Email, p_Cpf);
end%

delimiter ;

CALL InserirCliente('João Silva', 'joao@email.com', '123.456.789-00');

delimiter %

create procedure InserirFuncionario(
    in p_Nome varchar(100),
    in p_Funcao varchar(50),
    in p_Cidade varchar(50)
)
begin
    insert into Funcionario (Nome, Funcao, Cidade)
    values (p_Nome, p_Funcao, p_Cidade);
end%

delimiter ;

CALL InserirFuncionario('Maria Souza', 'Vendedora', 'São Paulo');

DELIMITER $$

CREATE PROCEDURE InserirAuditoria(
    IN p_NomeTabela VARCHAR(50),
    IN p_Historico TEXT
)
BEGIN
    INSERT INTO Auditoria (NomeTabela, Historico)
    VALUES (p_NomeTabela, p_Historico);
END$$

DELIMITER ;

CALL InserirAuditoria('Produto', 'Ajuste manual no estoque.');

-- Json --

CALL InserirCliente('Joao Silva', 'joao@email.com', '111.111.111-11'); -- Cliente Codigo 1
CALL InserirFuncionario('Maria Vendedora', 'Vendedor', 'Sao Paulo'); -- Funcionario Codigo 1
CALL InserirProduto('Teclado Mecânico', 'Teclado RGB', 10); -- Produto Codigo 1
CALL InserirProduto('Mouse Gamer', 'Mouse Optico', 5); -- Produto Codigo 2

/*SET @p_ItensJSON = '{
    "CodigoCliente": 1,
    "CodigoFuncionario": 1,
    "Itens": [
        { "CodigoProduto": 1, "Qtde": 3, "PrecoVenda": 50.00 },
        { "CodigoProduto": 2, "Qtde": 1, "PrecoVenda": 150.00 }
    ]
}';*/

SET @itens_json = '[
    { "CodigoProduto": 1, "Qtde": 3, "PrecoVenda": 50.00 },
    { "CodigoProduto": 2, "Qtde": 1, "PrecoVenda": 150.00 }
]';

SELECT
    -- Acessando um campo principal:
    JSON_EXTRACT(@json_carrinho, '$.CodigoCliente') AS Cliente,

    -- Acessando o primeiro elemento do array "Itens" (posição [0]):
    JSON_EXTRACT(@json_carrinho, '$.Itens[0].CodigoProduto') AS Primeiro_Produto_ID,
    JSON_EXTRACT(@json_carrinho, '$.Itens[0].Qtde') AS Qtde_Primeiro_Item,
    
    -- Acessando o segundo elemento do array "Itens" (posição [1]):
    JSON_EXTRACT(@json_carrinho, '$.Itens[1].CodigoProduto') AS Segundo_Produto_ID; /*concertado, carrinho concertado */
    

DELIMITER $$

CREATE PROCEDURE InserirPedidoCompleto(
    IN p_CodigoCliente INT,
    IN p_Status VARCHAR(20),
    IN p_ItensJSON JSON
)
BEGIN
    DECLARE v_CodigoPedido INT;
    DECLARE v_CodigoProduto INT;
    DECLARE v_Qtde INT;
    DECLARE v_PrecoVenda DECIMAL(10,2);
    DECLARE v_EstoqueAtual INT;
    DECLARE v_Indice INT DEFAULT 0;
    DECLARE v_TotalItens INT;

    -- Tratamento de erro
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erro ao inserir pedido — transação cancelada.';
    END;

    START TRANSACTION;

    -- 1️⃣ Inserir o pedido
    INSERT INTO Pedido (dataPedido, status)
    VALUES (CURDATE(), p_Status);

    SET v_CodigoPedido = LAST_INSERT_ID();

    -- 2️⃣ Contar quantos itens o JSON possui
    SET v_TotalItens = JSON_LENGTH(p_ItensJSON);

    -- 3️⃣ Loop pelos itens (simulando cursor manual)
    WHILE v_Indice < v_TotalItens DO
        -- Extrair dados do item atual
        SET v_CodigoProduto = JSON_EXTRACT(p_ItensJSON, CONCAT('$[', v_Indice, '].CodigoProduto'));
        SET v_Qtde = JSON_EXTRACT(p_ItensJSON, CONCAT('$[', v_Indice, '].Qtde'));
        SET v_PrecoVenda = JSON_EXTRACT(p_ItensJSON, CONCAT('$[', v_Indice, '].PrecoVenda'));

        -- 4️⃣ Validar produto
        SELECT Qtde_estoque INTO v_EstoqueAtual
        FROM Produto
        WHERE CodigoProduto = v_CodigoProduto;

        IF v_EstoqueAtual IS NULL THEN
           SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Produto inexistente: ';
        END IF;

        IF v_EstoqueAtual < v_Qtde THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente para o produto ';
        END IF;

        -- 5️⃣ Inserir item
        INSERT INTO ItemPedido (CodigoPedido, CodigoProduto, PrecoVenda, Qtde)
        VALUES (v_CodigoPedido, v_CodigoProduto, v_PrecoVenda, v_Qtde);

        -- 6️⃣ Atualizar estoque
        UPDATE Produto
        SET Qtde_estoque = Qtde_estoque - v_Qtde
        WHERE CodigoProduto = v_CodigoProduto;

        -- 7️⃣ Incrementar contador
        SET v_Indice = v_Indice + 1;
    END WHILE;

    COMMIT;
END$$

DELIMITER ;

CALL InserirPedidoCompleto(
    1,            -- Código do cliente
    'Aberto',     -- Status do pedido
    @itens_json   -- JSON com os itens
);

SELECT * FROM Pedido;
SELECT * FROM ItemPedido;
SELECT * FROM Produto;
SELECT * FROM Auditoria ORDER BY DataModificacao DESC; /*concertado com sucesso*/

-- view --
CREATE OR REPLACE VIEW ProdutosMaisVendidos AS
SELECT
    p.CodigoProduto,
    p.Nome,
    p.Descricao,
    COALESCE(SUM(ip.Qtde), 0) AS TotalVendido
FROM
    Produto p
LEFT JOIN
    ItemPedido ip ON p.CodigoProduto = ip.CodigoProduto
GROUP BY
    p.CodigoProduto, p.Nome, p.Descricao
ORDER BY
    TotalVendido DESC;
    
select * from ProdutosMaisVendidos
,
