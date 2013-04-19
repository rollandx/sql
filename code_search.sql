/*
	Search inside sp, functions, triggers, views for a specific text.
	Can be used to see the impact of changing a database object (you can review affected code).
	Define the text to be found by setting @searchFor
*/

declare @searchFor varchar(max)
set @searchFor = 'sys'

print 'searching for ''' + @searchFor + ''''

select object_name(object_id) name, definition from sys.sql_modules
where definition like '%' + @searchFor + '%'
order by name

