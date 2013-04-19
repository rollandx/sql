/*
	Reseed all identity columns in every table in a database.
	Can be used if there are gaps between current maximum value in an identity column and the next identity value (for instance if there are rows deleted from the end of the table).
*/

declare cur cursor for 
	select obj.name as table_name from
			sys.objects obj
			inner join sys.columns col on obj.object_id = col.object_id
	where
		col.is_identity = 1
		and obj.type = 'U'

declare @table_name varchar(max)

open cur

fetch next from cur into @table_name

while @@fetch_status = 0
begin
	print @table_name
	exec ('dbcc checkident (''' + @table_name + ''', reseed)')
	print ''
	print ''

	fetch next from cur into @table_name
end

close cur
deallocate cur
