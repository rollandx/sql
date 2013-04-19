
-- select top 10 * from fragemall_int order by NEWID();

begin tran;

update fragemall_int
set fragtext = 'test'
where fragid = 63241

-- commit tran


-- select * from fragemall_int

/*

SELECT 
		wt.wait_type
	,	wt.wait_duration_ms
	,	SPID	=	wt.session_id
	,	st.text
FROM 
	sys.dm_os_waiting_tasks wt 
LEFT JOIN 
	sys.dm_exec_requests er
	on wt.waiting_task_address = er.task_address 
	OUTER APPLY sys.dm_exec_sql_text(er.sql_handle) st
where wt.wait_type NOT LIKE '%SLEEP%' 
	and wt.wait_type <> 'SQLTRACE_BUFFER_FLUSH' -- system trace, not a cause for concern
	and wt.wait_type <> 'ONDEMAND_TASK_QUEUE' -- background task that handles requests, not a cause for concern
	and er.session_id > 50
ORDER BY wait_duration_ms desc

*/