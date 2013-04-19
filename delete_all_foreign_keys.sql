/*
	Delete all database foreign keys.
*/

declare cur cursor for
	select object_name(parent_object_id) as table_name, name from sys.foreign_keys

declare @table_name varchar(max)
declare @constraint_name varchar(max)

open cur

fetch next from cur into @table_name, @constraint_name

while @@fetch_status = 0
begin
	print @table_name + ' - ' + @constraint_name
	exec ('alter table [' + @table_name + '] drop constraint [' + @constraint_name + ']')
	print ''
	print ''

	fetch next from cur into @table_name, @constraint_name
end

close cur
deallocate cur
