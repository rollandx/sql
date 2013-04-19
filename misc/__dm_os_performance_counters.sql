
select object_name, counter_name, instance_name, cntr_value from sys.dm_os_performance_counters order by object_name


select distinct object_name, counter_name, instance_name, cntr_value from sys.dm_os_performance_counters
where	-- object_name in ('SQLServer:Buffer Manager', 'SQLServer:Databases', 'SQLServer:Locks', 'SQLServer:Memory Manager', 'SQLServer:Plan Cache')
		 -- and instance_name = 'test'
	counter_name in ('Page lookups/sec','Page reads/sec', 'Page writes/sec', 'Lock Timeouts/sec', 'Number of Deadlocks/sec')
	and (instance_name = '' or instance_name = '_Total')
order by object_name, counter_name


dbcc dropcleanbuffers
go

select distinct object_name, counter_name, instance_name, cntr_value from sys.dm_os_performance_counters
where	-- object_name in ('SQLServer:Buffer Manager', 'SQLServer:Databases', 'SQLServer:Locks', 'SQLServer:Memory Manager', 'SQLServer:Plan Cache')
		 -- and instance_name = 'test'
	counter_name in ('Page lookups/sec','Page reads/sec', 'Page writes/sec', 'Lock Timeouts/sec', 'Number of Deadlocks/sec')
	and (instance_name = '' or instance_name = '_Total')
order by object_name, counter_name

select * from fragemall

select distinct object_name, counter_name, instance_name, cntr_value from sys.dm_os_performance_counters
where	-- object_name in ('SQLServer:Buffer Manager', 'SQLServer:Databases', 'SQLServer:Locks', 'SQLServer:Memory Manager', 'SQLServer:Plan Cache')
		 -- and instance_name = 'test'
	counter_name in ('Page lookups/sec','Page reads/sec', 'Page writes/sec', 'Lock Timeouts/sec', 'Number of Deadlocks/sec')
	and (instance_name = '' or instance_name = '_Total')
order by object_name, counter_name
