/*
	Backup script for automated backup of all user databases.
	Every database except master, tempdb, model and msdb is backed up.
	Backup compression is used if available and turned on in server options.
*/

/* parameters */
/* --------------------------------------------*/
declare @backup_directory nvarchar(250)
-- folder on the disk where backup files should be saved
set @backup_directory = N'C:\sql_backups'
/* --------------------------------------------*/

declare @compress bit
select @compress = cast(value as bit) from sys.configurations where name = 'backup compression default'
declare @db_name sysname
declare backup_cursor cursor for select name from sys.databases where name not in ('master','tempdb','model','msdb')
open backup_cursor

fetch next from backup_cursor into @db_name
while @@fetch_status = 0
begin	
	declare @date varchar(20)
	set @date = CONVERT(varchar(8),GETDATE(),112) + '_' + CONVERT(varchar(8),GETDATE(),108)
	set @date = replace(@date, ':', '')

	declare @backup_file varchar(260)
	set @backup_file = @backup_directory + '\' + @db_name + '_' + @date + '.bak'
	if (@compress = 1)
		backup database @db_name to disk = @backup_file with format, init, compression, stats = 5, copy_only
	else
		backup database @db_name to disk = @backup_file with format, init, no_compression, stats = 5, copy_only

	fetch next from backup_cursor into @db_name
end
close backup_cursor
deallocate backup_cursor
