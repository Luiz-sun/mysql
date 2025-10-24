use classicmodels;

select * from customers where creditlimit = 0 and customernumber = 169;

update customers set creditlimit = 8000 where customernumber = 169;

create table log_modifi(
	IdModificacao int not null primary key auto_increment,
    modificado text,
    dataMotificacao datetime default current_timestamp,
    tabela varchar(50)
) engine = InnoDb;

drop trigger trg_update_cliente;

delimiter $
	create trigger trg_update_cliente after Update on Customers for each row
    begin
		insert into log_modifi(IdModificacao, modificado, tabela)
			values (default, concat("O cliente e codigo:", old.customernumber, "sofreu uma mudança no credito. O valor antigo é: ", old.creditlimit, "e o valor atual é: ", new.creditlimit), "Customers");
    end$
	-- Old -. Permite acessar o dado da tabela que esta sofrendo a alteração. Contudo, nota-se que comando OLD é referente ao dado antigo
    -- New -. Permite acessar o dado da tabela que esta sofrendo a alteração. Contudo, nota-se que comando New é referente ao dado novo
delimiter ;

select * from log_modifi;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
delimiter %
	create trigger trg_inserir_itemPedido before insert on OrderDetails for each row
		begin 
			declare var_estoque int default 0;
		
			select quantityInStock into var_estoque from products where new.productcode;
            
            if var_estoque >= new.quantityOrdered then
				insert into log_modifi(IdModificacao, modificado, tabela)
					values (default, concat("No pedido numero: ", new.ordernumber, " foi incluido o produto ", new.productCode, " com a quantidade de ", new.quantityOrdered), "OrderDetails");
				
				update products set quantityInStock = var_estoque - new.quantityOrdered where productcode = new.productcode;
			else
				signal	sqlstate '45000'
                set message_text = 'Venda cancelada. Estoque insuficienre';
			end if;
        end%
        
	create trigger trg_update_produtos after Update on Products for each row
    begin
		insert into log_modifi(IdModificacao, modificado, tabela)
					values (default, concat("O estoque do produto: ", old.productCode, " foi atualizado. O antigo era ", old.quantityINStock, " e o valor atual é ", new.quantityInStock), "Products");
    end%

delimiter ;