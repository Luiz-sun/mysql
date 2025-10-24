/*Functions
°{São objetos do banco de dados (create e drop para atualizar)}
°Utilizam delemiter (Begin e end)
°Os parametros são apenas de entrada
°Permite consulta complexas
°Palavras importantes{
	Returns: Tipo de valor
	Return: valor
	Deterministic:
}
*/
use tpa;

delimiter %
create function velocidade(des decimal(10,2), temp decimal(10,2))
returns decimal(10,2) deterministic
begin
        return des/temp;
end %
delimiter ;

select velocidade(200,2) as speed;

#Atividade avaliativa;
use classicmodels;

drop function valor_M;

delimiter $
create function valor_M (id_Produto varchar(70))
	returns decimal(10,2) deterministic
 BEGIN
 declare LucroPrevisto decimal(10,2);
 declare LucroReal decimal(10,2);
	SELECT
		(MSRP/BuyPrice) as LucroPrevisto,
		avg(PriceEach)/BuyPrice  as LucroReal
        
        into
         LucroPrevisto,
			LucroReal
	from 
		products 
			inner join OrderDetails using (productCode)
		where productCode = id_Produto
        
        group by BuyPrice;
        
        return LucroPrevisto - LucroReal;
 END $
delimiter ;

select valor_M('S10_1678') as Perda;

select * from products;