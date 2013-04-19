
/*
	Use this command to remove all the data from SQL Server’s data cache (buffer) 
	between performance tests to ensure fair testing (so that there is no cached data in memory between test iterations which could skew results).
	checkpoint flushes dirty in-memory pages and transaction log info to disk
	dropcleanbuffers deletes all clean in-memory pages (which, after checkpoint, should be everything).
*/
checkpoint
go
dbcc dropcleanbuffers

/*
	Used to clear out the stored procedure execution plan from cache.
	Causes stored procedure recompilation upon the next request.
*/
dbcc freeproccache
