# Migrate SQL Server to Azure SQL Managed Instance

In this module you will perform exercises to migrate the advanced scenario from SQL Server 2019 to Azure SQL Managed Instance.

From the requirements and assessment in Module 2, Azure SQL Managed Instance is the right target for the migration.

There are two aspects for the migration that are required for the migration:

- The Business Critical service tier is required for the Azure SQL Managed Instance deployment because the current SQL Server 2019 installation uses an Always On Availability Group.
- An online migration required which is supported using Azure Data Studio.

##  Deploy an Azure SQL Managed Instance

Follow the readme.md in the **deploy** folder.

## Online migration to Azure SQL Managed Instance

Follow the readme.md in the **onlinemigation** folder

**Tip**: If your databases use TDE before the migration, you should first migrate certificates. See more at https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/tde-certificate-migrate?tabs=azure-powershell

