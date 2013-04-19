/*
	Cleanup database - delete all rows from every table.
	Script tries to delete rows from every table without consideration for foreign key references so there could be
	errors connected to that ("The DELETE statement conflicted with the REFERENCE constraint...").
	The script loops until there are no more "reference" errors.
*/

set nocount on
print 'deleting...'
go

declare @ref_errors int
while @ref_errors > 0 or @ref_errors is null
begin
	set @ref_errors = 0
	print 'run'
	declare cur cursor for 
		select name as table_name from sys.tables where type = 'U'

	declare @table_name varchar(max)

	open cur

	fetch next from cur into @table_name
	while @@fetch_status = 0
	begin
		begin try
			exec ('delete ' + @table_name)
		end try
		begin catch
			if error_number() = 547
				set @ref_errors = @ref_errors + 1
			else
				print error_message()
		end catch

		fetch next from cur into @table_name
	end

	close cur
	deallocate cur
end

print 'deleted...'
