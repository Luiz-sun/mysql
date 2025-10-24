/*ACID -> Isolamento -> Transação 
            |-> Starte transaction 
				    -- to
                    |Update
                    |Delete
                    |Insert
                    -- T1 commit/rollback
*/

use classicmodels;

select * from payments;

start transaction;

delete from payments;