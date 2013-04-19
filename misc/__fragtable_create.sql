
--RUN ENTIRE SCRIPT
if exists (select * from information_schema.TABLES where table_name = 'fragemall_nsi')
DROP TABLE dbo.fragemall_nsi
go
CREATE TABLE dbo.fragemall_nsi
	(
	fragid uniqueidentifier NOT NULL DEFAULT newsequentialID(),
	fragtext varchar(4000) NOT NULL
	)  
GO
ALTER TABLE dbo.fragemall_nsi ADD CONSTRAINT
	PK_fragemall_nsi PRIMARY KEY CLUSTERED 
	(
	fragid
	) WITH(FILLFACTOR = 100) 
go
CREATE NONCLUSTERED INDEX IDX_NC_fragemall_nsi
ON dbo.fragemall_nsi (FRAGTEXT) WITH(FILLFACTOR =100)
GO


--Insert roughly 131072k records

	insert into dbo.fragemall_nsi (fragtext) 
	select replicate(char(round(rand()*100,0)),round(rand()*100,0))
go
declare @x integer
set @x = 1 
while @x < 18
begin
	insert into dbo.fragemall_nsi (fragtext) 
	select replicate(char(round(rand()*100,0)),round(rand()*100,0))
	from fragemall_nsi
set @x = @x + 1
end
go
select count(1) from dbo.fragemall_nsi

go


--RUN ENTIRE SCRIPT
if exists (select * from information_schema.TABLES where table_name = 'fragemall_int')
DROP TABLE dbo.fragemall_int
go
CREATE TABLE dbo.fragemall_int
	(
	fragid int NOT NULL IDENTITY(1,1),
	fragtext varchar(4000) NOT NULL
	)  
GO
ALTER TABLE dbo.fragemall_int ADD CONSTRAINT
	PK_fragemall_int PRIMARY KEY CLUSTERED 
	(
	fragid
	) WITH(FILLFACTOR =100)
go
CREATE NONCLUSTERED INDEX IDX_NC_fragemall_int
ON dbo.fragemall_int (FRAGTEXT) WITH(FILLFACTOR =100)
GO


--Insert roughly 131072k records

	insert into dbo.fragemall_int (fragtext) 
	select replicate(char(round(rand()*100,0)),round(rand()*100,0))
go
declare @x integer
set @x = 1 
while @x < 18
begin
	insert into dbo.fragemall_int (fragtext) 
	select replicate(char(round(rand()*100,0)),round(rand()*100,0))
	from fragemall_int
set @x = @x + 1
end
go
select count(1) from dbo.fragemall_int

go


--RUN ENTIRE SCRIPT
if exists (select * from information_schema.TABLES where table_name = 'fragemall')
DROP TABLE dbo.fragemall
go
CREATE TABLE dbo.fragemall
	(
	fragid uniqueidentifier NOT NULL,
	fragtext varchar(4000) NOT NULL
	)  
GO
ALTER TABLE dbo.fragemall ADD CONSTRAINT
	PK_fragemall PRIMARY KEY CLUSTERED 
	(
	fragid
	) WITH(FILLFACTOR =100)
go
CREATE NONCLUSTERED INDEX IDX_NC_fragemall
ON dbo.fragemall (FRAGTEXT) WITH(FILLFACTOR =100)
GO


--Insert roughly 131072k records

	insert into dbo.fragemall (fragid, fragtext) 
	select newid(), replicate(char(round(rand()*100,0)),round(rand()*100,0))
go
declare @x integer
set @x = 1 
while @x < 18
begin
	insert into dbo.fragemall (fragid, fragtext) 
	select newid(), replicate(char(round(rand()*100,0)),round(rand()*100,0))
	from fragemall
set @x = @x + 1
end
go
select count(1) from dbo.fragemall
