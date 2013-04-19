 
SELECT sqltext.text, session_id, total_elapsed_time, status, sql_handle, plan_handle, database_id, USER_NAME(user_id), blocking_session_id, wait_type, wait_time, wait_resource,
		total_elapsed_time, reads, writes, queryplan.query_plan
FROM sys.dm_exec_requests
	cross apply sys.dm_exec_sql_text(sql_handle) sqltext
	cross apply sys.dm_exec_query_plan(plan_handle) queryplan
where session_id > 50











-- enable dbcc page output
--	dbcc traceon (3604)
--	dbcc page (7, 1, 7932, 3)
--		dbcc page (db_id, file_id, page_id, mode)

--	select * from sys.dm_exec_sessions where session_id > 50
