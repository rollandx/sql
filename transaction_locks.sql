/*
	Review currently active transactions and their locks.
	Can be used to diagnose long-running or locking operations.
*/


/* parameters */
/* --------------------------------------------*/
declare @database_name nvarchar(128)
-- database that you want to query for transactions and transaction locks
set @database_name = 'my_database'
/* --------------------------------------------*/



select * from sys.dm_tran_database_transactions where database_id = db_id(@database_name)
select * from sys.dm_tran_locks where resource_database_id = db_id(@database_name) and resource_type not in ('DATABASE')




