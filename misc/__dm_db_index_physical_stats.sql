
select t2.name, t3.name, t1.*
from sys.dm_db_index_physical_stats(DB_ID(), null, null, null, 'limited') t1
		inner join sys.objects t2 on t1.object_id = t2.object_id
		inner join sys.indexes t3 on t1.object_id = t3.object_id and t1.index_id = t3.index_id


ALTER INDEX ALL ON test.dbo.[fragemall] REBUILD
ALTER INDEX ALL ON test.dbo.[fragemall_int] REBUILD
ALTER INDEX ALL ON test.dbo.[fragemall_nsi] REBUILD
