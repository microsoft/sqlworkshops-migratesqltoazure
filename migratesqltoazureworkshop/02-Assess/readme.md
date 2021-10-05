# Discover and Assess SQL Server

## Using Azure Migrate to discover SQL Server

For the first rev of the workshop this will be a description only of how Azure Migrate works to discover and assess SQL Server on VMWare. Point to any public video that can be watched to see the experience.

Future revs of the workshop should be able to used Azure Migrate for the remaining exercises in this module instead of DMA.

## Assessing a basic migration for SQL Server 2016

1. All prereqs must be complete

2. Since this is a lift and shift to Azure VM there is no reason to run DMA to assess for any compat issues. But we can use DMA to assess a workload and configuration to get recommendations on the right VM size and storage.

3. Run HammerDB with 12 virtual users. Leave all other defaults.

4. In a new powershell command window run assesssql2016.ps1 which runs these commands:

SqlAssessment.exe PerfDataCollection --sqlConnectionStrings "Data Source=.;Initial Catalog=master;Integrated Security=True;" --outputFolder c:\demos

5. When all users for HammerDB are done (about 10mins), hit enter in the powershell window to finish the collection.

5. Now Run SQL Assessment to get sku recommendations like the following:

SqlAssessment.exe GetSkuRecommendation --targetPlatform AzureSqlVirtualMachine --outputFolder c:\demos

6. Review the results to look at the virtual machine sizes. Put in details here about how to look at these.

## Assessing a more complex migration for SQL Server 2019

Setup an AG with a single readable sync secondary
TODO: Complete