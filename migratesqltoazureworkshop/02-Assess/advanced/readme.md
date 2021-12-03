# Discover and Assess SQL Server

All prereqs must be complete

1. Assess aspects of the current SQL Server 2019 installation:

- Show number of cores through Task Manager
- Show in SSMS the size of the database and transaction log for the tpch database and that they are on different drives
- Show tempdb is on a separate drive with 12 files
- Show @@VERSION including edition
- Show windows login from the domain
- Show SQL Agent jobs to backup db, log, reorg indexes, and run CHECKDB in the form of maintenance plans
- Show maxdop is set 1
- Show there is an extended event session with a file target
- Show there is a separate drive for backups
- Show the database is part of an Always On Availability Group

## Assessing a more complex migration for SQL Server 2019

1. Run DMA to assess your SQL Server to migrate for Azure SQL Managed Instance

Create an assessment project for a target of Azure SQL Managed Instance

The assessment doesn't find any issues with database compatibility. It does find an issue for feature parity because I'm using trace flags 1117 and 1118. Azure SQL Managed Instance doesn't support these two trace flags. Fortunately these trace flags are holdovers from older versions of SQL Server are not needed any further. They were probably turned on for tempdb but the functionality for these trace flags are enabled by default for tempdb in Azure SQL Managed Instance (and have been since SQL Server 2016).

You can read more details on the rules DMA uses for assessments for migrations to Azure SQL Managed Instance at: https://docs.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-sql-managed-instance-assessment-rules

2. To perform a SKU assessment run the workload using HammerDB with TPCC

32 virtual users. Timed test for 2 minutes no ramp up. The average TPS was between 300-400K

3. Run the SKU assessment tool using the script **assesssql2019.ps1** which runs the following command:

`SqlAssessment.exe PerfDataCollection --sqlConnectionStrings "Data Source=.;Initial Catalog=master;Integrated Security=True;" --outputFolder c:\migrate --perfQueryIntervalInSec 5 --numberOfIterations 24`

Normally you would let the tool run longer to asses your workload but for purposes of this exercise I will only run the workload for a few minutes. The perfQueryIntervalInSec indicates how often performance information will be collected. The numberOfIterations determine how many iterations before performance data is persisted. So after 120 seconds, performance data is persisted to be used for the assessment.

4. Look at the disk seconds/transfer on the drive with the tlog. Notice this a very low ms latency which matches our requirements for a low-latency OLTP application.

5. Show Task Manager and Performance Dashboard reports for core usage.

6. When all users for HammerDB are done (about 2mins), hit enter in the powershell window to finish the collection.

7. Now Run SQL Assessment to get sku recommendations from the script **getrecommendationssql2019.ps1** which runs the following command:

`SqlAssessment.exe GetSkuRecommendation --targetPlatform AzureSqlManagedInstance --outputFolder c:\migrate --scalingFactor 200`

We know we want the assessment to target SQL Server in Azure SQL Managed Instance which matches the targetPlatform parameter. We also use the scalingFactor parameter which tells the tool to "scale up" the recommendation because we know the workload test isn't completely representative of the required vCores. In this advanced scenario we know the HammerDB workload for 2 minutes doesn't fully represent the needed resources of the application.

7. The results will be displayed in the console but also available in an HTML file in the same directory where you ran the migration (in this case c:\migrate). The name of the HTML file is SkuRecommendationReport.html

The results for this execution should look similar to the following

:::image type="content" source="../../../graphics/advanced_migration_sku_recommendation_report.png" alt-text="advanced_migration_sku_recommendation_report":::

The report recommends a Service Tier of General Purpose but that may not line up with requirements of the Advanced migration scenario. This is due to the following reasons:

- The tool currently doesn't look at HA requirements such as the existence of an Always On Availability Group
- The tool currently doesn't offer a way to look at low latency transaction log requirements which is part of this workload.

Because of these requirements our plan will be to use the Business Critical Service Tier. The compute size seems accurate based on our workload and scaling factor. The Storage Size is not accurate because it only accounts for the size of the current workload sample database. Our requirements call for larger sizes so we will use those when deploying the Azure SQL Managed Instance.