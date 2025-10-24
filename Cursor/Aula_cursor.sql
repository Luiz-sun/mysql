use classicmodels;

delimiter @
create procedure lista_cliente_sem_credito(inout lista_cliente_semsaldo text)
begin
	declare done bool default false; -- Criação de variavel para controle de valor vazio no cursor
    declare var_cliente varchar(100) default ""; -- variavel para armazenar o nome do cliente a cada interação do cursor
		/*Criação da variacel cursor e vinculo com a consulta para o seu preenchimento*/
    declare cursor_cliente_semsaldo cursor for select customername from customers where creditlimit= 0;
/*Controle e monitoramento do cursor para identificar se existe ou não registro na variavel 
	não encontrando o seu valor e atualizado para true
*/
    declare continue handler for 
	  not found set done = true;
      -- Abertura do cursor
      -- os valores são carregador em memorias
	open cursor_cliente_semsaldo;
    -- Inicializando o valor da variavel vazio
    set lista_cliente_semsaldo = '';
  -- Criação do loop (laço) para permitir a interação do cursor 
   -- Importante dar um nome para o loop, ou seja , como se fosse apelido
    processa_cliente: loop
    
  -- captura os valores de um linha do cursor e encrementa a busca para o proximo registro em memoria
	-- importante é necessario ter variaveis para atribuir os valores
	fetch cursor_cliente_semsaldo into var_cliente;
    -- verificação do cursor esta vazio
      -- observação: o valor é sempre analisado pelo handler, que monitora o cursor continuamente
    if done = true then 
    -- comando permite sair do cursor
		leave processa_cliente;
	end if;
    -- inserindo na lista os valores encontrados
    set lista_cliente_semsaldo = concat(var_cliente, " ; ", lista_cliente_semsaldo);
    
    end loop;
    
    -- fechar o cursor
    close cursor_cliente_semsaldo;
    
end@

delimiter ;

set @cliente_semsaldo = '';

call lista_cliente_sem_credito(@cliente_semsaldo);

select @cliente_semsaldo;