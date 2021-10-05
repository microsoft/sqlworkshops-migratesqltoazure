# Migrate SQL Server to Azure Virtual Machine

Because of app compat issues we must use SQL Server 2016 but want to move to Azure. So we will deploy a lift and shift method to move to a SQL Server 2016 instance deployed in Azure Virtual Machine.

Since our business allows some down time we will migrate "offline" to Azure by taking a full backup of the SQL Server 2016 user database and restore it in Azure Virtual Machine.

However, we also need to migrate SQL Server instance objects including the SQL Server agent jobs in the prereqs and the SQL Server admin login called sqladmin.

DBA need access to ERRORLOGs which works in the VM just like SQL Server.

Once the migration is complete, in the next module we will optimize and manage the SQL Server 2016 deployment.

## Deploy the target Azure VM

TODO: mention you can automate this process with Azure templates.

1. Use Azure SQL in the portal to choose SQL Server 2016 SP2 Std on Windows 2016 Datacenter.

Use azuresql_choose_sql_edition.png as the image.

TODO: Talk about the benefits of using this approach.

Once you have chosen the SQL and Windows combination, select Create

2. Go through portal deployment options

Main screen - Use azure_port_create_vm_main.png as the image

Use existing RG from Azure storage account
Pick a VM name. It can be the same name as your current server or another one. This becomes the computer name of the Windows Server and @@SERVERNAME.
Choose same region as Azure storage account
No infrastructure because we are not going to setup HA for this VM (like clustering or AGs)
Image preselected since we chose this in the previous screen. BUG FIX: Change this to choose Engine only option.
Don't pick Spot Instance
For size, we should choose the size recommended during Assessment which is XXXX. Note the cost is ~1,097.92/month
Fill out an admin. This will be a local Windows admin account for the VM and will be auto added as a sysadmin to SQL Server.
Leave the RDP port public (we will secure the VM in the next module)
Note the option for Licensing for AHB. Since you already have a license for Windows Server for your VM and are migrating you can select this. Notice in the portal option for Size the price changed to $560.64/month)

Select Next:Disks at the bottom of the screen

Leave the defaults and select Networking

Leave all the defaults for this screen. Notice a new virtual network will be created as part of creating the VM. If you had an existing vnet in Azure and wanted to include this VM in that vnet you could specify that here.

Select Next: Management

Leave all the defaults. We will explore some of these later in the next module. Note the option at the bottom for Windows for Automatic updates. This allows Automatic patching for the OS to occur on this VM for critical and security updates. Leave this on. The warning at the bottom is only for patching across availability sets which we are not using for this VM.

Use azure_portal_create_vm_management.png as the image

Select Next: Advanced

Leave the defaults
TODO: Talk a bit about what could be done here and can you do it later?

Select Next: SQL Server settings

Use azure_portal_create_vm_sql_settings.png as the image

Leave security and Networking along. Talk about enabling mixed mode auth in tbe next module.

For storage, select Change configuration

Getting storage as the best as possible will save you time later. This is where we will do some optimization while migrating

TODO: Need to incorporate the DMA suggestions and take screenshot again

Using Data Warehousing option will separate data and log, put tempdb on separate local storage, and enable trace flag 610 to help optimize any bulk loading operations.

Even though we had a 4TB drive, after examining the size of db and log, anticipated growth, and the fact that we separate drives now, we can provision a 2TB drive for data and 1TB for log.

If these sizes later are not correct, you can always expand with no migration. Or you can reduce the size by creating new azure disks and moving the database files over to the new disk.

Use azure_portal_create_vm_sql_storage.png for the image

SQL Server license

Leave this alone for now. We will talk more in the optimizing module about it and how it can save you money

Leave automated patching enabled which is for SQL Server security updates.

Leave Automated backup and R Services disabled. We will talk about Automated backups in the next module.

Mention Tags but don't use them.

Select Review+Create. A final validation of your options is then executed. If that passes you will get a screen where you can select Create to start a deployment of the VM.

The deployment time can vary but usually 10-15 minutes.

## Verify deployment

1. Select Go to resource to see the VM.

Put info in here about look at some of the basics of the VM

1. After deployment, use RDP to verify guest.
 
Check SSMS is installed


Check disk drives are setup as deployed from the portal
Check SQL 2016 SP2 is installed SP2 CU17 is actually installed which is the latest CU that includes all security updates. By the time you use this workshop it could be SP3 (which was just released in sept 2021)

Check trace flags

610 and 1117 actually set (1117)

2. Create a new folder on the OS drive called c:\scripts

## Backup the SQL Server 2016 database

1. Login in to your VM with SQL Server 2016 as sysadmin SQL login

2. Setup a backup location in Azure

Create an Azure storage account
Using the Azure portal Create a new resource. Use image tpch_create_azure_storage.png
Choose Storage account
    Choose your subscription
    Create a new resource group if you have not done so. You will use this again when creating the target VM to migrate to
    Choose a storage account name
    Pick an appropriate region where you have access rights and quota
    Choose Standard storage. Standard storage is required for SQL backup to URL
    Choose the redundancy option based on your compliant needs. Most customers can choose geo-redundant (TODO: Which regions are chosen for geo?)
    Select Review+Create and then Create
    Your storage account is complete when the portal screen says "Your deployment is complete"
    Go to the storage account and create a new Container called sqlbackups. You can leave public access level to private. I

3. Use the SSMS wizard to backup a full db to Azure storage

Right-click the tpch database and select Backup as a task. Use the ssms_backup_to_url_menu.png image. 

Select Destination as URL and select Add. Then select New to choose a new container as the destination. Use the ssms_back_to_url_new_container.png image.

Select Sign-in to sign into your Azure account. Your account may require additional authentication methods to sign-in.

Click on the Create button to create a SAS key which gives SQL Server permissions to access the Azure Storage account container. The SAS key is specific to the container not the entire storage account. Use the ssms_backup_to_url_connect_to_azure.png image.

After the "connect to Azure" dialog box. the Azure storage container will be filled in with a proposed backup file name based on the current date and time. Select OK.

You are now back to the main Backup Up Database screen where the URL filename is filled in. Select OK to backup the database. The Progress of the backup is displayed in the lower left hand side of the screen. It should take around 10mins or so to backup the db to Azure.

4. Verify the backup file is in Azure storage using the portal.

Using the portal you can look at your sqlbackups container and verify the backup file exists. Use the tpch_backup_in_azure_storage.png image.

## Generate scripts for SQL instance objects

1. Generate script for SQL login

You should already have the script to recreate the SQL login from the pre-reqs

2. Generate script for SQL Agent jobs

TODO:

3. Save these files on your local drive as you will copy these into the new VM

## Migrate SQL logins

1. Use SSMS to allow mixed mode auth and reboot

1. In your local VM, select the SQL login script and "Copy"

2. Switch to the new VM and copy the file into the c:\scripts folder

3. connect to SSMS with Windows auth

4. Execute the sql login script

## Restore DB

1. Using our optimize while migrating strategy let's enable IFI

5. disconnect from SSMS and log in with the sqladmin account

6. Use SSMS to restore the db from Azure Storage

7. Verify the database has been restored

## Add SQL Agent job for update stats

We will use SQL IaaS ext for auto backups
