# Prereqs for Migrate SQL Server to Azure Workshop

## Basic migration scenario  - SQL Server 2016

1. Deploy a VM with Windows Server 2016 Datacenter and SQL Server 2016 SP2

- I used Azure to simulate an on-premises VM
- 16 VCPUs with 64Gb ram (In Azure this is Standard D16as_v4)
- OS disk 127Gb
- D: for tempdb 127Gb
- Data drive is 4TB
- Install SSMS (I used latest which is 18.9.2)
- Install DMA 5.4
- Put this folder in the system path
- C:\Program Files\Microsoft Data Migration Assistant\SqlAssessmentConsole

- Deploy HammerDB for Windows from https://github.com/TPC-Council/HammerDB/releases/download/v4.2/HammerDB-4.2-Win-x64-Setup.exe
- Enabled locked pages in memory but not IFI
- Create a SQL Server login called sqladmin (complex password of your choice) and make it a member of the sysadmin system role.
- Get an account with an Azure subscription. Being a member of the Contributor role will give you the necessary permissions to complete the exercises.

2. Use HammerDB to deploy a 10 scale db for TPC-H

Use your sqladmin new SQL login to run this.

This can take way too long using the HammerDB tool. We may need to go smaller here on the db size or come up with scripts and text files to load this faster.

Ideally we would script this and create bcp files or a BACPAC.

When this is done you need to do a full db backup, log backup, and shrinkdatabase twice. Now the db will be around 18Gb and the log 8Mb. To avoid autogrow go back and change the log size to about 1Gb.

4. Setup SQL Agent jobs to maintain stats and manage backups. These are based on maintenance plans. To simplify the example I created three maintenance plans all setup for on-demand (normally they would be scheduled)

a. One executes a full backup to the G:
b. The 2nd runs CHECKDB (physical only) and then does a log backup
c. The 3rd update stats (fullscan) on all tables

We will only use the last two jobs during our exercises

## Complex migration scenario SQL Server 2019

VM with SQL Server 2019 EE joined to a Windows domain
    Ideally do this. Right now I just have a single VM
enable ifi and locked pages
HammerDB to create TPCC
    I used 500 warehouses with 16 virtual users to build the db. I first created a database called tpcc with 50Gb data and 12gb log that is empty before I built the db with  HammerDB
    Ran DBCC SHIRNKDATABASE which put the tlog back to 10Gb

Find a startup trace flag that might get flagged by DMA
Optionally
    AG with a readable sync secondary configured
    Windows auth login from the domain as a sysadmin

TSQL Agent job to reorg all indexes of db

Optionally - BONUS only if time
    SSIS package to perform basic export of data to a flat file

Full db backup SQL Agent job to a separate storage drive run weekly
Diff db backup SQL Agent job to a separate storage drive run daily
Log backup SQL Agent job to a separate storage drive to run every 30 mins

XEvent trace to a file target on data drive run on-demand to perform 
"profile" queries

SSMS used to run Query Store reports.

Live profiling used

dbcompat 150

RTO requirements are X

RPO requirements are X