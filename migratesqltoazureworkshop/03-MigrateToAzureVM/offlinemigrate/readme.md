# Offline migration of SQL Server to Azure Virtual Machine

In this exercise you will perform an offline migration of SQL Server to Azure Virtual Machine.

- You will backup your database from the source SQL Server to Azure Blob Storage
- You will then connect to the new deployed Azure Virtual Machine and restore that backup from the same Azure Blob Storage container.
- You will migrate any other objects such as logins or SQL Agent jobs.

## Backup the SQL Server 2016 database to Azure Storage

1. Login in to your VM with SQL Server 2016

2. Setup a backup location in Azure

- Create an Azure storage account
- Using the Azure portal Create a new resource.
- Choose Storage account
    - Choose your subscription
    - Create a new resource group if you have not done so. You will use this again when creating the target VM to migrate to
    - Choose a storage account name
    - Pick an appropriate region where you have access rights and quota
    - Choose Standard storage. Standard storage is required for SQL backup to URL
    - Choose the redundancy option based on your compliant needs. Most customers can choose geo-redundant.
    - Select Review+Create and then Create
    - Your storage account is complete when the portal screen says "Your deployment is complete"
    - Go to the storage account and create a new Container called sqlbackups. You can leave public access level to private.

3. Use the SSMS wizard to backup a full db to Azure storage

- Right-click the tpch database and select Backup as a task.

- Select Destination as URL and select Add. Then select New to choose a new container as the destination.

- Select Sign-in to sign into your Azure account. Your account may require additional authentication methods to sign-in.

- Click on the Create button to create a SAS key which gives SQL Server permissions to access the Azure Storage account container. The SAS key is specific to the container not the entire storage account.

- After the "connect to Azure" dialog box. the Azure storage container will be filled in with a proposed backup file name based on the current date and time. Select OK.

- You are now back to the main Backup Up Database screen where the URL filename is filled in. Select OK to backup the database. The Progress of the backup is displayed in the lower left hand side of the screen. It should take around 10mins or so to backup the db to Azure.

4. Verify the backup file is in Azure storage using the portal.

Using the Azure portal you can look at your sqlbackups container and verify the backup file exists.

## Restore the database from Azure Storage

1. Using our *optimize while migrating* strategy let's enable Instant File Initialization with local policies and restart SQL Server.

2. Disconnect from SSMS and log in with the sqladmin account

3. Use SSMS to restore the db from Azure Storage. 

Select Restore Database from SSMS Object Explorer

b. Choose the database backup file from Azure Storage via URL

c. Click Add to be able to select the Azure Storage container location and file

d. Connect to your Azure subscription and select the storage account and container.

Sign-in to your Azure subscription. Your organization may have certain requirements to sign-in like MFA.

Choose the storage account you used to backup the database from your source VM and the container. Choose Create for a SAS key to be used to access the backup file. Then click OK.

You can then click OK on the dialog box titles Select a Backup location at the storage container and key are now filled in

e. Choose the backup file

You will now be put into an "explorer" experience to choose your backup file. Select Containers and your container name. Your backup file should be listed in the right-hand pane.

Select it and click OK.

f. Your backup file will be filled in for the Backup media on the screen Select backup device. Click OK.

g. Your backup details are now filled in on the Restore Database screen. Click OK to restore the backup.

You should see a progress bar and % at the top of the screen.

Use ssms_restore_database_progress.png as the image

When done you will see a dialog box that says Database 'tpch' restored successfully. Click OK.

4. Verify the database has been restored

There are many ways to do this. Two quick things to check

The size of the files.

F:\data\tpch.mdf should be around 17,272,832 kb
G:\log\tpch_log.ldf should be around 1,024,000 kb

5. SSMS Object Explorer should have customer, lineitem, nation, orders, part, partsupp, region, and supplier tables.

## Migrate other objects

### Generate scripts

1. Generate script for SQL login

You should already have the script to recreate the SQL login from the pre-reqs

2. Save these files on your local drive and "copy and paste" them into the c:\scripts folder of the new VM.

### Migrate SQL logins

1. Use SSMS to allow mixed mode auth and restart SQL Server

2. connect to SSMS with Windows auth

3. Execute the sql login script

### Add SQL Agent job for automatic backups

We will use SQL IaaS ext for auto backups in the next module so you don't need to export those backup jobs.

### Add SQL Agent job for auto update stats

This is a full SQL Server so you can either recreate your new maintenance plan to update stats or script out from the source SQL Server and apply it.