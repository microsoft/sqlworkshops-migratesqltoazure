# Discover and Assess SQL Server

## Using Azure Migrate to discover SQL Server

For the first rev of the workshop this will be a description only of how Azure Migrate works to discover and assess SQL Server on VMWare. Point to any public video that can be watched to see the experience.

Future revs of the workshop should be able to used Azure Migrate for the remaining exercises in this module instead of DMA.

## Assessing a basic migration for SQL Server 2016

1. All prereqs must be complete

2. Since this is a lift and shift to Azure VM there is no reason to run DMA to assess for any compat issues. But we can use DMA to assess a workload and configuration to get recommendations on the right VM size and storage.

3. Run HammerDB with 16 virtual users. Leave all other defaults. Turn on Transactions and you will see the test takes about mins with an avg of 10000 QpH.

You can read more about using this assessment tool at https://docs.microsoft.com/en-us/sql/dma/dma-sku-recommend-sql-db?view=sql-server-ver15

4. In a new powershell command window run assesssql2016.ps1 which runs these commands:

SqlAssessment.exe PerfDataCollection --sqlConnectionStrings "Data Source=.;Initial Catalog=master;Integrated Security=True;" --outputFolder c:\demos --numberOfIterations 10

We use iterations of 10 because the tool will then persist performance data after 5 minutes.

5. When all users for HammerDB are done (about 5mins), hit enter in the powershell window to finish the collection.

5. Now Run SQL Assessment to get sku recommendations like the following:

SqlAssessment.exe GetSkuRecommendation --targetPlatform AzureSqlVirtualMachine --outputFolder c:\demos

6. Review the results to look at the virtual machine sizes. Put in details here about how to look at these.

## Assessing a more complex migration for SQL Server 2019

1. Use HammerDB with TPCC

32 virtual users. Timed test for 5 minutes no ramp up. The average TPS was between 300-400K

2. Run DMA to assess your SQL Server to migrate for Azure SQL MI

Here are the rules

https://docs.microsoft.com/en-us/azure/azure-sql/migration-guides/managed-instance/sql-server-to-sql-managed-instance-assessment-rules

2. Run the SKU assessment tool during a 5 minute test run

TODO: The tool right now says GP service tier is fine for MI but my log I/O latency needs are more than that. Per the docs https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/resource-limits. GP is about 5-10ms where BC is 1-2ms

TODO: I used a scaling factor of 150 because I believe I may need to scale for the future so it recommended a 8vCore CPU.

The results look like this

`
PS C:\demos> .\getskurecommendation.ps1
Starting SKU recommendation...

Performing aggregation for instance tpccsql2019...
Aggregation complete. Calculating SKU recommendations...
Instance name: tpccsql2019
SKU recommendation: Azure SQL Managed Instance:
Compute: GeneralPurpose - 16 cores
Storage: 32 GB
Recommendation reasons:
        According to the performance data collected, we estimate that your SQL server instance has a requirement for 3.84 vCores of CPU. For greater flexibility, based on your scaling factor of 250.00%, we are making a recommendation based on 9.60 vCores. Based on all the other factors, including memory, storage, and IO, this is the smallest compute sizing that will satisfy all of your needs.
        This SQL Server instance requires 9.36 GB of memory, which is within this SKU's limit of 81.60 GB.
        This SQL Server instance requires 10.88 GB of storage for data files. We recommend provisioning 32 GB of storage, which is the closest valid amount that can be provisioned that meets your requirement.
        This SQL Server instance requires 103.49 milliseconds of IO latency, which is within the limits of the General Purpose service tier.
        Assuming the database uses the Full Recovery Model, this SQL Server instance requires 26,217 IOPS for data and log files. Based on the current file size you can get 500 IOPS if you migrate as-is, otherwise please increase the file size to get more IOPS.
        This is the most cost-efficient offering among all the performance eligible SKUs.


Finishing SKU recommendations...
SKU recommendation report saved to c:\demos\SkuRecommendationReport.html.

You can also look at a HTML version of the output

Show the HTML report here

