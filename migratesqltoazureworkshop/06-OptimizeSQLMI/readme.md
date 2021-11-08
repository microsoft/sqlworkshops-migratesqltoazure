# Optimize migration to Azure SQL Managed Instance

## Explore Azure SQL Managed Instance

Setup a jumpbox
Look over the Azure portal and az cli
Look at differences for SSMS, DMVs, ...

## Implement best practices

## Use AHB

In the portal select Compute+Storage on the left hand side. Look at the Cost Summary and the estimated cost/month.

In the option called Azure Hybrid Benefit select the checkbox for I already have a SQL Server license. Note the huge reduction in cost. Select the I confirm checkbox and hit Apply.

## Configure a maintenance window

## Secure Azure SQLMI

### Disable public endpoint
### Use Azure AAD
### Setup auditing

## Configure HADR

### Review the SLA
### LTR
### Perform a COPY_ONLY backup
### Use a read only connection
### Test a failover

See system dbs now part of the failover including SQL Agent jobs

### Setup an auto-failover group

## Use the power of Azure

### Microsoft Defender for SQL
### SQL Insights

## Verify application

### Connect HammerDB to MI and observe performance

### Application considerations

https://docs.microsoft.com/en-us/sql/dma/dma-assess-app-data-layer?view=sql-server-ver15