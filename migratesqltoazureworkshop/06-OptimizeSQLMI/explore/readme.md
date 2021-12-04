# Explore Azure SQL Managed Instance

1. Use the Azure portal to show all the various options including:

The main portal page
Compute+storage options = We could use Premium tier to get the original memory we had
Metrics
Export template

2. How do you use command line options

Bring up the cloud shell

Run az sql mi --help

Then show what the options are

3.  Connect to SSMS and look at the sql config and admin tasks

Look at tempdb files
Set 'max degree of parallelism' to 1
Show the dbcompat of our db
Show the query store
Show sys.dm_exec_requests and sys.dm_os_memory_clerks
Run DBCC CHECKDB(tpcc)
Show system health session exists

4. Show a jompbox

Show you can connect without using the public endpoint using an Azure VM "jumpbox"