# Migrate SQL Server to Azure Virtual Machine

Because of app compat issues we must use SQL Server 2016 but want to move to Azure. So we will deploy a lift and shift method to move to a SQL Server 2016 instance deployed in Azure Virtual Machine.

Since our business allows some down time we will migrate "offline" to Azure by taking a full backup of the SQL Server 2016 user database and restore it in Azure Virtual Machine.

However, we also need to migrate SQL Server instance objects including the SQL Server agent jobs in the prereqs and the SQL Server admin login called sqladmin.

DBA need access to ERRORLOGs which works in the VM just like SQL Server.

Once the migration is complete, in the next module we will optimize and manage the SQL Server 2016 deployment.

In this module you will do the following:

## Deploy an Azure Virtual Machine

Follow the readme.md instructions in the **deploy** folder.

## Perform an offline migration of SQL Server to Azure Virtual Machine

Follow the readme.me instructions in the **offlinemigrate** folder
