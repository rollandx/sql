
use AdventureWorks2012
go

select * from sys.dm_db_missing_index_groups
select * from sys.dm_db_missing_index_group_stats
select * from sys.dm_db_missing_index_details

-- drop indexes (so that we get a recommendations :))
drop index AK_SalesOrderDetail_rowguid on sales.salesorderdetail 
drop index IX_SalesOrderDetail_ProductID on sales.salesorderdetail 
alter table sales.salesorderdetail drop constraint PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID

-- perform select - simulate queries that would run 
SELECT 
    *
FROM Sales.SalesOrderDetail inner join Sales.SalesOrderHeader on Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
where UnitPrice < 200 and OrderQty > 1
go
SELECT *
FROM Sales.SalesOrderDetail inner join Sales.SalesOrderHeader on Sales.SalesOrderDetail.SalesOrderID = Sales.SalesOrderHeader.SalesOrderID
where Status = 5 and ProductID = 776

go

-- check for suggested indexes
SELECT 
	mid.statement
,	create_index_statement	=	'CREATE NONCLUSTERED INDEX IDX_NC_' + t.table_name
	+ replace(replace(replace(ISNULL(mid.equality_columns,'') , '], [' ,'_'),'[','_'),']','') 
	+ replace(replace(replace(ISNULL(mid.inequality_columns,''), '], [' ,'_'),'[','_'),']','') 
	+ ' ON ' + statement 
	+ ' (' + ISNULL (mid.equality_columns,'') 
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END 
    + ISNULL (mid.inequality_columns, '')
	+ ')' 
	+ ISNULL (' INCLUDE (' + mid.included_columns + ')', '')  
,	unique_compiles, migs.user_seeks, migs.user_scans, last_user_seek, avg_total_user_cost
, avg_user_impact, mid.equality_columns,  mid.inequality_columns, mid.included_columns, t.table_catalog
FROM sys.dm_db_missing_index_groups mig
	INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
	INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
	INNER JOIN INFORMATION_SCHEMA.tables t 
		on t.table_name = replace(replace(substring(substring(statement, charindex('.', statement)+2, len(statement)), charindex('.', substring(statement, charindex('.', statement)+1, len(statement))), len(statement)),'[',''),']','')
		and t.table_schema = replace(replace(substring(	substring(		statement	,	charindex('.', statement)+2	,	len(statement)	),	0,	charindex('.', 		substring(		statement	,	charindex('.', statement)+2	,	len(statement)	)	)),'[',''),']','')
		and db_name() = t.table_catalog
		and db_ID() = mid.database_id
-- WHERE (datediff(week, last_user_seek, getdate())) < 6
--	AND		migs.unique_compiles > 1
--	or		migs.avg_user_impact > 90
order by avg_user_impact * avg_total_user_cost desc 

-- (re) create indexes
CREATE NONCLUSTERED INDEX IDX_NC_SalesOrderDetail_ProductID ON
	 [AdventureWorks2012].[Sales].[SalesOrderDetail] ([ProductID]) 
	  INCLUDE ([SalesOrderID], [SalesOrderDetailID], [CarrierTrackingNumber],
	 [OrderQty], [SpecialOfferID], [UnitPrice], [UnitPriceDiscount], [LineTotal], [rowguid], [ModifiedDate])

CREATE NONCLUSTERED INDEX IDX_NC_SalesOrderDetail_OrderQty_UnitPrice 
	 ON [AdventureWorks2012].[Sales].[SalesOrderDetail] ([OrderQty], [UnitPrice]) 
	  INCLUDE ([SalesOrderID], [SalesOrderDetailID], 
	 [CarrierTrackingNumber], [ProductID], [SpecialOfferID], [UnitPriceDiscount], [LineTotal], [rowguid], [ModifiedDate])