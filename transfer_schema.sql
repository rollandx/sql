/*
	A script to transfer database functions, stored procedures, tables and views from one schema to another.
	Set the required parameters (@oldschema, @newschema) and execute the resulting script.
*/

/* parameters */
/* --------------------------------------------*/
declare @oldschema varchar(100)
declare @newschema varchar(100)

-- schema to transfer from
set @oldschema = 'dbo'
-- schema to transfer to
set @newschema = 'my_new_schema'
/* --------------------------------------------*/


declare @script varchar(max)
set @script = ''

select @script = coalesce('alter schema ' + @newschema + ' transfer ' + @oldschema + '.' + name, '') + ';
' + @script
from
	(select name, schema_name(schema_id)  as schema_name from sys.tables
	union
	select name, schema_name(schema_id) from sys.views
	union
	select routine_name, routine_schema from information_schema.routines) t1
where schema_name = @oldschema

select @script
-- uncomment execute the script
--	exec (@script)