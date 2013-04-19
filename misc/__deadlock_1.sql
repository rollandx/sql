
------------ prepare
USE TEMPDB

drop table dbo.foo
drop table dbo.bar

CREATE TABLE dbo.foo (col1 INT)
INSERT dbo.foo SELECT 1

CREATE TABLE dbo.bar (col1 INT)
INSERT dbo.bar SELECT 1

-----------

-- step 1
BEGIN TRAN
UPDATE tempdb.dbo.foo SET col1 = 1


-- step 3
UPDATE tempdb.dbo.bar SET col1 = 1






commit tran