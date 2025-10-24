/*Declare cria variavel*/
create database Sinuca;
use Sinuca;

create table sacola(
Numerobola int not null primary key,
Quantidade int,
cor varchar(10)
) engine = innoDB;

delimiter @
create procedure incluir_bolas_sacola(in param_nume int, in param_cor varchar (10), in param_quantidade int)
begin
	declare var_capacidade_sacola int default 200;
	declare var_valor_atual int default 0;
    declare var_valor_final int default 0;
    declare var_bola_existe int default 0;
    declare var_espaco_disponivel int default 0;
    declare var_valor_final_incluir int default 0;
    
	select ifnull(sum(Quanridade),0)into var_valor_atual from sacola;

	set var_valor_final_incluir = var_valor_atual + param_quantidade;
    
    if var_valor_final_incluir <= var_capacidade_sacola then
		select ifnull(Quantidade) into var_bola_existe from sacola where Numerobola = param_nume;
		if var_bola_existe > 0 then
            call alterar_bolas_sacola(param_nume, param_cor, param_quantidade);
		else
			insert into sacolo(Numerobola,cor, quantidade) values (parm_nume, param_cor, param_quantidade);
            select concat('Foi incluido: ', param_quantidade, 'bolas de numero', param_nume); 
		end if;
        else
			set var_espaco_disponivel = var_capacidade_sacola - var_valorarual;
			insert into sacolo(Numerobola,cor, quantidade) values (param_nume, param_cor, var_espaco_disponivel);
			select concat('Foi possive incluir: ', var_espacodisponivel,'bolas.', 'Ficaram',(param_quantidade - var_espaco_disponivel)'para fora');
        end if;
end @
create procedure alterar_bolas_sacola (in param_numeros int, in param_cor varchar(10), in param_quantidade int)
begin
    declare bola_existe int default 0;
    select count(*) into bola_existe from sacola where numerobola = param_numero;

    if bola_existe > 0 then update sacola
        set cor = param_cor, qtde = param_nova_quantidade where numerobola = param_numero;
        select concat('bolas do número ', param_numero, ' alteradas com sucesso. nova quantidade: ', param_nova_quantidade, ', nova cor: ', param_cor, '.');
    else
        select concat('erro: a bola com o número ', param_numero, ' não foi encontrada na sacola para alteração.');
    end if;    
end@
delimiter ;

call incluir_bolas_sacola (2,'amarela',2, @var_valor_final_incluir);
select @var_valor_final_incluir