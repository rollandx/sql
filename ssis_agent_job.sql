/*
	Helper script to create sql server agent job that runs SSIS package from a disk file.
	The job runs manually; there is no schedule set.
*/

/* parameters */
/* --------------------------------------------*/
declare @name nvarchar(100), @desc nvarchar(100), @server nvarchar(100), @dtsx_path nvarchar(250), @dtsconfig_path nvarchar(250), @cmd nvarchar(max)
-- agent job name
set @name = N'SSIS package exec'
-- agent job description
set @desc = N'Run SSIS package'
-- sql server on which to execute the job (you'll probably want to leave this as is; "@@servername" which means current connection's server)
set @server = @@servername
-- full path on the disk where *.dtsx package is located
set @dtsx_path = N'C:\my packages\package.dtsx'
-- full path on the disk where *.dtsconfig is located
set @dtsconfig_path = N'C:\my packages\package.dtsConfig'
/* --------------------------------------------*/


DECLARE @jobId BINARY(16)
EXEC  msdb.dbo.sp_add_job @job_name=@name, 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=@desc, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=null, @job_id = @jobId OUTPUT
select @jobId


EXEC msdb.dbo.sp_add_jobserver @job_name=@name, @server_name = @server


set @cmd = N'/FILE "' + @dtsx_path + '" /CONFIGFILE "' + @dtsconfig_path + '" /MAXCONCURRENT " -1 " /CHECKPOINTING OFF /REPORTING E'
EXEC msdb.dbo.sp_add_jobstep @job_name=@name, @step_name=N'run', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_fail_action=2, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'SSIS', 
		@command=@cmd, 
		@database_name=N'master', 
		@flags=0


EXEC msdb.dbo.sp_update_job @job_name=@name, 
		@enabled=1, 
		@start_step_id=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=2, 
		@notify_level_netsend=2, 
		@notify_level_page=2, 
		@delete_level=0, 
		@description=@desc, 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=null, 
		@notify_email_operator_name=N'', 
		@notify_netsend_operator_name=N'', 
		@notify_page_operator_name=N''

