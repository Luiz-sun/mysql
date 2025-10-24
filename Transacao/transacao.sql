use classicmodels;

select *from payments;

select * from products;

select * from customers;
start transaction;

delete from payments;

update customers set city ='Belo Horizonte';

update products set quantityInStock = 3000;

delete from customers where creditlimit = 0;

rollback;

commit;