use sakila;

select * from film;

select film_id, title from film order by title asc;
create or replace view vw_film
as 
select film_id, title from film order by title asc;

select * from vw_film;
/*------------------*/

delimiter @
create procedure Nome_city (in param_city varchar(50), in param_cotigo int)
begin
	select country_id as Cotigo, city as Nome from country
    inner join city using (country_id);
end@
delimiter ;

select * from procedure Nome_city