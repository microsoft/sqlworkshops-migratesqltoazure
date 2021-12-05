# Perform an online migration from IaaS to PaaS

In this exercise you will perform an online migration for SQL Server in Azure Virtual Machine to Azure SQL Managed Instance.

The exact steps for this exercise are under construction. The concept is to use the backups that have been created from configuring Automatic Backups in Module 4 for an online migration. Since the backups already exist in Azure Storage you can use Azure Data Studio (ADS) without having to install the Self-hosted Integration Runtime. 

ADS can support restoring a full backup to Azure SQL Managed Instance from existing Azure Storage and then restore transaction log backups as they are created.

The cutover process is very similar to the process as in Module 5 which included an online migration from SQL Server to Azure SQL Managed Instance.