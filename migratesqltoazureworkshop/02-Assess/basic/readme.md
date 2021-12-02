# Discover and Assess SQL Server

## Assessing a basic migration for SQL Server 2016

1. All prereqs must be complete

2. Since this is a lift and shift to Azure VM there is no reason to run DMA to assess for any compat issues. But we can use DMA to assess a workload and configuration to get recommendations on the right VM size and storage.

3. Run HammerDB with 16 virtual users. Leave all other defaults. Turn on Transactions and you will see the test takes about mins with an avg of 10000 QpH.

You can read more about using this assessment tool at https://docs.microsoft.com/en-us/sql/dma/dma-sku-recommend-sql-db?view=sql-server-ver15

4. In a new powershell command window run **assesssql2016.ps1** which runs these commands:

SqlAssessment.exe PerfDataCollection --sqlConnectionStrings "Data Source=.;Initial Catalog=master;Integrated Security=True;" --outputFolder c:\migrate --perfQueryIntervalInSec 5 --numberOfIterations 24

Normally you would let the tool run longer to asses your workload but for purposes of this exercise I will only run the workload for a few minutes. The perfQueryIntervalInSec indicates how often performance information will be collected. The numberOfIterations determine how many iterations before performance data is persisted. So after 120 seconds, performance data is persisted to be used for the assessment.

5. When all users for HammerDB are done (about 2mins), hit enter in the powershell window to finish the collection.

5. Now Run SQL Assessment to get sku recommendations from the script **getrecommendationssql2016.ps1** which runs the following command:

SqlAssessment.exe GetSkuRecommendation --targetPlatform AzureSqlVirtualMachine --outputFolder c:\migrate

We know we want the assessment to target SQL Server in Azure Virtual Machine which matches the targetPlatform parameter.

6. The results will be displayed in the console but also available in an HTML file in the same directory where you ran the migration (in this case c:\migrate). The name of the HTML file is SkuRecommendationReport.html

The results for this execution should look similar to the following

:::image type="content" source="../../../graphics/basic_migration_sku_recommendation_report.png" alt-text="basic_migration_sku_recommendation_report":::

The report shows Compute Sizing as the VM size choice based on a minimum recommended 1:8 core/memory ratio. Storage sizing shows how to configure Azure Premium Storage for data, log, and tempdb. The Justification and Requirements View buttons give more details on the recommendations.

In this case the SKU tool recommended a Standard_E16as_v4 which falls in line with our recommendations of using the E series. One of the sizes we typically recommend because of its better I/O performance and local storage is the Standard_E16ds_v4 VM sizes. We have recently released E5 series of VMs so our tools will be updated to reflect recommending these new sizes.

