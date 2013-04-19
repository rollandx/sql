


-- all statements
select sq.text, s.* from sys.dm_exec_query_stats s
	OUTER APPLY sys.dm_exec_sql_text (s.sql_handle) as sq
order by s.total_worker_time desc

-- execution plans
select t.text, p.query_plan, s.*
from sys.dm_exec_query_stats s
	 cross apply sys.dm_exec_sql_text(s.sql_handle) t
	 cross apply sys.dm_exec_query_plan (s.plan_handle) p
order by s.sql_handle

-- top queries by cpu usage
select x.CpuRank, x.PhysicalReadsRank, x.DurationRank, x.runtime, x.usecounts, x.tot_cpu_ms, x.tot_duration_ms, x.total_physical_reads,
		x.stmt_text, x.query_plan
from 
	(SELECT 
			PlanStats.CpuRank, PlanStats.PhysicalReadsRank, PlanStats.DurationRank, 
			CONVERT (varchar, getdate(), 126) AS runtime,
			p.usecounts, p.size_in_bytes / 1024 AS size_in_kb, 
			PlanStats.total_worker_time/1000 AS tot_cpu_ms, PlanStats.total_elapsed_time/1000 AS tot_duration_ms, 
			PlanStats.total_physical_reads, PlanStats.total_logical_writes, PlanStats.total_logical_reads,
			  LEFT (CASE 
				WHEN pa.value=32767 THEN 'ResourceDb' 
				ELSE ISNULL (DB_NAME (CONVERT (sysname, pa.value)), CONVERT (sysname,pa.value))
			  END, 40) AS dbname,
			  sql.objectid, 
			  CONVERT (nvarchar(50), CASE 
				WHEN sql.objectid IS NULL THEN NULL 
				ELSE REPLACE (REPLACE (sql.[text],CHAR(13), ' '), CHAR(10), ' ')
			  END) AS procname, 
			  REPLACE (REPLACE (SUBSTRING (sql.[text], PlanStats.statement_start_offset/2 + 1, 
				  CASE WHEN PlanStats.statement_end_offset = -1 THEN LEN (CONVERT(nvarchar(max), sql.[text])) 
					ELSE PlanStats.statement_end_offset/2 - PlanStats.statement_start_offset/2 + 1
				  END), CHAR(13), ' '), CHAR(10), ' ') AS stmt_text,
			  plan_text.query_plan
		FROM 
		(
			  SELECT 
				stat.plan_handle, statement_start_offset, statement_end_offset, 
				stat.total_worker_time, stat.total_elapsed_time, stat.total_physical_reads, 
				stat.total_logical_writes, stat.total_logical_reads, 
				ROW_NUMBER() OVER (ORDER BY stat.total_worker_time DESC) AS CpuRank, 
				ROW_NUMBER() OVER (ORDER BY stat.total_physical_reads DESC) AS PhysicalReadsRank, 
				ROW_NUMBER() OVER (ORDER BY stat.total_elapsed_time DESC) AS DurationRank 
			  FROM sys.dm_exec_query_stats stat 
		) AS PlanStats 
			INNER JOIN sys.dm_exec_cached_plans p ON p.plan_handle = PlanStats.plan_handle 
			OUTER APPLY sys.dm_exec_plan_attributes (p.plan_handle) pa 
			OUTER APPLY sys.dm_exec_sql_text (p.plan_handle) AS sql
			inner join sys.databases d on d.database_id = pa.value
			cross apply sys.dm_exec_query_plan (p.plan_handle) plan_text
		WHERE (PlanStats.CpuRank < 50 OR PlanStats.PhysicalReadsRank < 50 OR PlanStats.DurationRank < 50)
		  AND pa.attribute = 'dbid' 
		  and d.database_id > 4
	) x
ORDER BY tot_cpu_ms DESC

-- clear plan cache
DBCC FREEPROCCACHE 
-- clear data memory buffers
DBCC DROPCLEANBUFFERS
