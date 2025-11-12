use classicmodels;

select * from orderdetails where ordernumber = 10100;
select quantityordered * priceEach as total from orderdetails where ordernumber = 10100;
select sum(quantityordered * priceEach) as total_valor from orderdetails where ordernumber = 10100;


#Modifique a consulta acima incluindo os seguintes campos:
# Nome do cliente;
# Total pago;
# Total calculado na nota;

select 
	customerName as cliente,
    amount as valor_pago,
    sum(quantityordered * priceEach) as valor_nota
 from 
	orderdetails
    inner join orders using (ordernumber)
    inner join customers using (customernumber)
    inner join payments using (customernumber)
 where
 year(paymentdate) = 2003
	and month (paymentdate) = month (orderdate)
	#and ordernumber = 10100
group by 
	cliente, valor_pago;

# Modifique a consulta acima, incluindo o campo de vericação. Este campo deverá segui os critérios abaixo:
# Se o valor da nota for igual ao valor pago, escrever: "Valor correto"
# Se o valor da nota for menor ao valor pago, escrever: "Pagamento maior"
#Se o valor da nota for maior ao valor pago, escrever: "Pagamento menor"

select 
	customerName as cliente,
    amount as valor_pago,
    sum(quantityordered * priceEach) as valor_nota,
    case
		when sum(quantityordered * priceEach) = amount then "Valor correto"
        when sum(quantityordered * priceEach) < amount then "Pagamento maior"
        else "Pagamento menor"
    end as verifiacao
 from 
	orderdetails
    inner join orders using (ordernumber)
    inner join customers using (customernumber)
    inner join payments using (customernumber)
 where
 year(paymentdate) = 2003
	and month (paymentdate) = month (orderdate)
group by 
	cliente, valor_pago;
