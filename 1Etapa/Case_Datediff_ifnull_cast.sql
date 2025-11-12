use sakila;

#utilização do datediff
select datediff('2025-05-06', '2025-04-04') * 2 +10 as resultados;
#Datediff diferença entre datas.
#Primeiro parâmetro é a data mais distante. Ou seja, data final
#segundo parâmetro é a data mais próxima. Ou seja, data inicial
# Datediff (datafinal, datainicial)

#crie uma consulta que irá retornar os dias de aluguel
#utilize a base de dados sakila.
describe rental;
-- rental_date
-- return_date
select
	datediff(return_date, rental_date) as dias
from 
	rental;
#Crie uma consulta trazendo os seguintes campos abaixos:
# codigo do cliente - customer_id
#codigo aluguel - rental_id
# Titulo do filme - title 
#taxa de reposição de filme  - replacement_cost
#tempo máximo de aluguel - rental_duration
#dias de aluguel - calculo acima
#taxa de atraso - rental_rate

select 
	customer_id,
    rental_id,
    title,
    replacement_cost,
    rental_duration,
	datediff(return_date, rental_date) as dias
from
	rental 
		inner join inventory using (inventory_id)
        inner join film using (film_id);

#Modifique a consulta acima, incluindo mais campo, chamado dias em atraso.
# Este campo deverá receber a diferença entre o dia de aluguel e tempo máxima de aluguel.
    
select 
	customer_id,
    rental_id,
    title,
    replacement_cost,
    rental_duration,
	ifnull(datediff(return_date, rental_date), 999) as dias,
    ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) as dias_atrasados
from
	rental 
		inner join inventory using (inventory_id)
        inner join film using (film_id);
        
#A função CAST do SQL serve para converter o tipo de dados de um valor.
#A função IFNULL do SQL substitui valores nulos por um valor alternativo especificado. E por padrão 999
#utilizando o CASE

select 
	customer_id,
	case
		when active = 1 then 'Ativo'
        else 'Inativo'
	end as situacao_cliente
from 
 customer;

select 
	customer_id,
    rental_id,
    title,
    replacement_cost,
    rental_duration,
	ifnull(datediff(return_date, rental_date), 999) as dias,
    ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) as dias_atrasados,
    case 
		when ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) < 0 
			or ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) = 999
				then 'caloteiro'
		else 'Gente boa'
	end as situacao_cliente
from
	rental 
		inner join inventory using (inventory_id)
        inner join film using (film_id);
        
#Modifique a consulta acima, incluindo o campo multa, que deverá obedecer os criterios a baixo:
#se o campo dia em atraso for negativo, faça: dias em atraso * taxa de aluuel * -1
#se o campo dia em atraso for 999, preencher a taxa de reposição de filme
#do contrário colocar o valor zero.

select 
	customer_id,
    rental_id,
    title,
    replacement_cost,
    rental_duration,
	ifnull(datediff(return_date, rental_date), 999) as dias,
    ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) as dias_atrasados,
    case 
		when ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) < 0 
			or ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) = 999
				then 'caloteiro'
		else 'Gente boa'
	end as situacao_cliente,
    case 
		when ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) < 0
			then ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) * rental_rate * -1
		when ifnull(rental_duration -cast(datediff(return_date, rental_date) as decimal),999) = 999
			then replacement_cost
		else 0
    end as multa
from
	rental 
		inner join inventory using (inventory_id)
        inner join film using (film_id);
        
#exercicios;
