/*Crie uma procedure que irá receber o codigo da loja e ultimo número de matricula  e deverá incluir todos os filmes faltantes no estoque.
Para isso, você deve utilizar: Cursor, Left, Insert.
Ao final retorne a mensagem de sucesso no processo de inclusão dos filmes.
Coloque a quantidade de copias para cada filme igual a ultimo número da sua matricula.
Se seu ultimo número for Zero, coloca pelo menos uma copia.*/

use sakila;

describe inventory;

delimiter @
	create procedure inseriri_filmes_no_estoque(in codigoloja int, in ultimo_nmatricula int)
    begin
    declare done bool default false;
    declare var_filme int;
    declare contador int;
    
    declare cursor_filme_foraestoque cursor for
    select film_id
    from
		FILM
        WHERE FILM_ID NOT IN(SELECT distinct(FILM_ID)FROM INVENTORY WHERE STORE_ID=CODIGOLOJA);
        
	declare continue handler for
		not found set done= true;
        
	open cursor_filme_foraestoque;
    
    process_filmes: loop
    
	 fetch cursor_filme_foraestoque into var_filme;
     
     if done = true then
		leave process_filmes;
     end if;
     
     set contador = 0;
     repeat 
     
     insert into inventory(inventory_id, store_id, film_id)
		values(default,codigoloja,var_filme);
        
        SET CONTADOR = CONTADOR +1;
     until CONTADOR <= ultimo_nmatricula
     end repeat;
     END LOOP;
	CLOSE cursor_filme_foraestoque;
			
    end@
delimiter ;

drop procedure inseriri_filmes_no_estoque;


call inseriri_filmes_no_estoque(1,26);

    select film_id
    from
		FILM
        WHERE FILM_ID NOT IN(SELECT distinct(FILM_ID)FROM INVENTORY WHERE STORE_ID=1);