
-- perform select
SELECT * FROM Sales.SalesOrderDetail
where SalesOrderID = 43659

go

--		select * from sys.dm_db_index_usage_stats where database_id = DB_ID('AdventureWorks2008R2')

select o.name as table_name, i.name as index_name, user_seeks, user_scans, user_updates, last_user_seek, last_user_scan,
			last_user_update
from sys.dm_db_index_usage_stats s
	inner join sys.objects o on s.object_id = o.object_id
	inner join sys.indexes i on s.index_id = i.index_id and i.object_id = s.object_id
where s.database_id = DB_ID('AdventureWorks2008R2')
		--	and OBJECTPROPERTY(s.object_id, 'IsMsShipped') = 0