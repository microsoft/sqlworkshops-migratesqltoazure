# Deploy the target Azure Virtual Machine for migration

In this exercise you will deploy an Azure Virtual Machine that comes with SQL Server from the Azure Marketplace. You will then perform some basic verification of the deployment.

## Deploy the target Azure VM

Note: The instructor may have the VM already deployed since it can take 10 minutes or longer to deploy the VM

1. Use the marketplace to deploy the SQL Server in Azure Virtual Machine with SQL Server 2016 Standard Edition with Windows Server 2016 using the size of Standard E16as_v4 and other requirements from the assessment in Module 2

2.  Main deploy blade choices

- Use a new RG called tpchrg
- Pick a VM name. It can be the same name as your current server or another one. This becomes the computer name of the Windows Server and @@SERVERNAME.
- Choose a region closest to your on-premises deployment.
- No infrastructure because we are not going to setup HA for this VM (like clustering or AGs)
- Image preselected since we chose this in the previous screen. BUG FIX: Change this to choose Engine only option.
- Don't pick Spot Instance
- For size, we should choose the size recommended during Assessment which is E16as_v4 - 16 Available vCPU. Note the cost is ~1200/month.
- Fill out an admin. This will be a local Windows admin account for the VM and will be auto added as a sysadmin to SQL Server.
- Leave the RDP port public (we will secure the VM in the next module)
- Note the option for Licensing for AHB. Since you already have a license for Windows Server for your VM and are migrating you can select this. Notice in the portal option for Size the price changed to ~$700/month)
- Select Next:Disks at the bottom of the screen

3. VM Disks and Networking

- Leave the defaults and select Networking

- Leave all the defaults for this screen. Notice a new virtual network will be created as part of creating the VM. If you had an existing vnet in Azure and wanted to include this VM in that vnet you could specify that here.

4. VM Management and Advanced

- Select Next: Management
- Leave all the defaults but talk about some options here
- Select Next: Advanced
- Leave the defaults

5. SQL Server settings

- Select Next: SQL Server settings
- Leave security and Networking along. Talk about enabling mixed mode auth in tbe next module.
- For storage, select Change configuration
- Getting storage as the best as possible will save you time later. This is where we will do some optimization while migrating
- Using Data Warehousing option will separate data and log, put tempdb on separate local storage, and enable trace flag 610 to help optimize any bulk loading operations.
- Even though we had a 4TB drive, after examining the size of db and log, anticipated growth, and the fact that we separate drives now, we can provision a 2TB drive for data and 1TB for log.
- If these sizes later are not correct, you can always expand with no migration. Or you can reduce the size by creating new azure disks and moving the database files over to the new disk.
- SQL Server license
- Leave this alone for now. We will talk more in the optimizing module about it and how it can save you money
- Leave automated patching enabled which is for SQL Server security updates.
- Leave Automated backup and R Services disabled. We will talk about Automated backups in the next module.

6. Tags, Review, and Create

- Mention Tags but don't use them.
- Select Review+Create. A final validation of your options is then executed. If that passes you will get a screen where you can select Create to start a deployment of the VM.
- The deployment time can vary but usually 10-15 minutes.

## Verify deployment

1. Show the main properties after the VM is deployed (or with the one already deployed)

- Show other resources that are created with the VM including the virtual network and storage
- Show the Export Template under automation as a way to use Azure templates to automate the building of another VM just like this one.
- We will explore later more options including setting SQL Server options

**Tip**: If you want to communicate with this VM using its private IP create your resource inside the same virtual network.

2. After deployment, use RDP to verify the deployment
 
- Check SSMS is installed and connect locally to the instance
- Check disk drives are setup as deployed from the portal
- Check SQL 2016 SP2 is installed SP2 CU17 is actually installed which is the latest CU that includes all security updates. By the time you use this workshop it could be SP3 (which was just released in sept 2021)
- Check trace flag 610 is set
- Apply latest windows updates. They may require a VM restart