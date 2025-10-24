/*
Introdução a StoredProcedures;
São obj de BD
Armazena rotinas
Podem ter varias consultas complexas
Regras de negócio
Delimitadores
Begin....end{
Pode ter ou não parâmetros
quando tem parametro(in(entrada),out(saida),inout(ambos)}
Call
*/

create database Make;
use Make;

drop procedure sp_make_diaadia;

delimiter %
create procedure sp_make_diaadia(
	in creme varchar(20), 
    in hidratante varchar(30),
    in primer varchar(20),
    in base varchar(20),
    in pofacial varchar(20),
    in batom varchar(20),
    out situacao_make varchar(30), 
    inout estado_emocional varchar(55))
begin
	select 'Lavar o rosto' as primeiro_passo,
		concat('passar o creme do tipo: ', creme) as segundo_passo,
        concat('passar a hidratante do tipo: ', hidratante)as terceiro_passo,
        concat('passar a primer do tipo: ', primer)as quarto_passo,
        concat('passar a base do tipo: ', base)as quinto_passo,
        concat('passar a po facial do tipo: ', pofacial)as sexto_passo,
        concat('passar a batom do tipo: ', batom)as setimo_passo;
	
    set situacao_make = 'Make pronta';
    
    set estado_emocional = 'relaxada';
end%
delimiter ;

set @estado_emocional = 'Estressada';
call sp_make_diaadia('cerave', 'a','b','c','d','e', @situacao, @estado_emocional);
/*para uma variavel precisa de @*/
select @situacao, @estado_emocional;

drop procedure sp_make_diaadia;

delimiter %
create procedure sp_make_festa(
	in creme varchar(20), 
    in hidratante varchar(30),
    in primer varchar(20),
    in base varchar(20),
    in corretivo varchar(20),
    in pofacial varchar(20),
    in sombra varchar(20),
    in delinear varchar(20),
    in mascaracilios varchar(20),
    in blush varchar(20),
    in batom varchar(20),
    out situacao_make varchar(30), 
    inout estado_emocional varchar(55))
begin
	select 'Lavar o rosto' as primeiro_passo,
		concat('passar o creme do tipo: ', creme) as segundo_passo,
        concat('passar a hidratante do tipo: ', hidratante)as terceiro_passo,
        concat('passar a primer do tipo: ', primer)as quarto_passo,
        concat('passar a base do tipo: ', base)as quinto_passo,
        concat('passar a corretivo do tipo: ', corretivo)as sexto_passo,
        concat('passar a po facial do tipo: ', pofacial)as setimo_passo,
        concat('passar a sombra do tipo: ', sombra)as oitavo_passo,
        concat('passar a delinear do tipo: ', delinear)as nono_passo,
        concat('passar a mascara cilios do tipo: ', mascaracilios)as decimo_passo,
        concat('passar a blush do tipo: ', blush)as decimoprim_passo,
        concat('passar a batom do tipo: ', batom)as decimosegun_passo;
	
    set situacao_make = 'Make pronta';
    
    set estado_emocional = 'relaxada';
end%
delimiter ;

set @estado_emocional = 'Estressada';
call sp_make_festa('cerave', 'a','b','c','d','e','f','g','h','i','j', @situacao, @estado_emocional);
select @situacao, @estado_emocional;