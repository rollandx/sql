/*
	Find out what permissions does user have on a server, database and object level.
	Those are effective permissions, not directly assigned ones.
	If you want to review another user's permissions, change and uncomment "execute as user ..." line.
	Database and object permissions shown are from the current database.
*/

-- review another user's permissions
--execute as user = '[username]'

select * from fn_my_permissions(NULL, 'SERVER');
select * from fn_my_permissions(NULL, 'DATABASE');
-- show permissions on a specific object
select * from fn_my_permissions('Sales.SalesOrderHeader', 'OBJECT');