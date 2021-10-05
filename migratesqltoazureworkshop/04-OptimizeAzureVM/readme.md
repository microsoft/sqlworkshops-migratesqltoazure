# Optimize and manage migration with Azure VM

## Secure connectivity

Enable JIT for RDP
Disable SQL port because client will join Azure network

## Examine storage

Notice read-only caching is setup for the "data" drive. This is a best practice and can significantly boost read performance but not harm data write performance (based on how SQL Server does data writes). The log doesn't have caching due to sequential mostly write nature.

The OS drive has read/write caching on which is the right choice for the OS drive.

## Apply all the latest updates

Apply all Windows updates

## Use SQL IaaS ext

Enable auto manage backups per the previous backup db and log schedule
Enable auto updates

## Create new tempdb files 

## Consider moving system dbs, model and msdb, to data disk

## Estimate costs and apply AHB

## Look at the Security Center

## Verify workload

    Install HammerDB
    
    Use the same driver script settings for 8 virtual users. Run workload and observe when done similar performance as with the SQL 2016 VM.

## Review all our best practices

https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist#overview

## Explore advanced options for Azure VMs

Look at various options in the portal
Azure Advisor?