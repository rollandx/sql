

select * from sys.dm_os_wait_stats
order by wait_time_ms desc


select top 10
	wait_type
,	wait_time_s =  wait_time_ms / 1000.  
,	Pct			=	100. * wait_time_ms/sum(wait_time_ms) OVER()
from sys.dm_os_wait_stats
where wait_type NOT LIKE '%SLEEP%' 
	and wait_type <> 'SQLTRACE_BUFFER_FLUSH' -- system trace, not a cause for concern
	and wait_type <> 'ONDEMAND_TASK_QUEUE' -- background task that handles requests, not a cause for concern
	and wait_type not like 'FT_%' -- full text search
order by Pct desc



-- dbcc sqlperf ('sys.dm_os_wait_stats', clear);
