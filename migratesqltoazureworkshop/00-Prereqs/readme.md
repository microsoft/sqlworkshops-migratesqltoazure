# Prereqs for Migrate SQL Server to Azure Workshop

## Basic migration scenario  - SQL Server 2016

1. Deploy a VM with Windows Server 2016 Datacenter and SQL Server 2016 SP2

- I used Azure to simulate an on-premises VM
- 16 VCPUs with 64Gb ram (In Azure this is Standard D16as_v4)
- OS disk 127Gb
- Data drive is 2TB for data, log
- Tempdb is on the OS drive
- Backup drive is 500Gb
- Install latest SSMS
- Install latest DMA version
- Put this folder in the system path
- C:\Program Files\Microsoft Data Migration Assistant\SqlAssessmentConsole

- Deploy HammerDB for Windows from https://github.com/TPC-Council/HammerDB/releases/download/v4.2/HammerDB-4.2-Win-x64-Setup.exe
- Enabled locked pages in memory and IFI
- Create a SQL Server login called sqladmin (complex password of your choice) and make it a member of the sysadmin system role.
- Get an account with an Azure subscription. Being a member of the Contributor role will give you the necessary permissions to complete the exercises.

2. Use HammerDB to deploy a 10 scale db for TPC-H

This can take a few hours to build the db. Because the log can grow fairly large when you use the tool to build the db, I recommend you shrink the database after the build completes. I then went back and modified the log size to 1Gb. Database should be around 50Gb.

4. Setup SQL Agent jobs to maintain stats and manage backups. These are based on maintenance plans. To simplify the example I created three maintenance plans all setup for on-demand (normally they would be scheduled)

a. One executes a full backup to backup drive
b. The 2nd one goes a log backup to backup drive
c. The 3rd update stats (fullscan) on all tables

## Advanced migration scenario SQL Server 2019

Install SQL Server 2019 Enterprise Edition
    Joined to Windows domain
    Deploy a failover cluster with 2 nodes.
    SQL installed on both nodes and a SQL failover cluster installed

enable ifi and locked pages

HammerDB to create TPCC
    I used 500 warehouses with 16 virtual users to build the db. I first created a database called tpcc with 50Gb data and 12gb log that is empty before I built the db with HammerDB
    Ran DBCC SHIRNKDATABASE which put the tlog back to 10Gb

Create an availability group with the tpcc database in it. Setup the 2nd node as a sync secondary replica.

TSQL Agent job to reorg all indexes of db

Full db backup SQL Agent job to a separate storage drive run weekly
Log backup SQL Agent job to a separate storage drive to run every 30 mins

XEvent trace to a file target on data drive run on-demand to perform 
"profile" queries

SSMS used to run Query Store reports.

Live profiling used

dbcompat 150