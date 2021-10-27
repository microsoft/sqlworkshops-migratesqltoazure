# Migrate SQL Server to Azure SQL Managed Instance

##  Deploy an Azure SQL Managed Instance

deploy per recommendations from assessment
I'll use a 8vCore BC but I'm going to use more storage because I know I need to grow so will choose 512Gb of storage.

2. Migrate certificates for TDE protected databases if TDE is enabled

https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/tde-certificate-migrate?tabs=azure-powershell

2. Backup your db on the source SQL Server

Setup a locally shared folder
Execute a full db backup
You MUST use the WITH CHECKSUM option
Make sure the MSSQLSERVER service has read/write access to the share

BACKUP DATABASE tpcc TO DISK = 'c:\sqlbackups\tpcc.bak' WITH INIT, CHECKSUM;
GO

3. Verify you can connect to SQLMI with SSMS on your source machine

Setup SSMS to connect to SQLMI
Use either vnet or public endpoint

4. Create an Azure storage account for online backups

I created an azure storage account in the same RG as my azure sql mi

2. Migrate online with ADS

a. Deploy ADS on the source SQL Server
b. Install the Azure SQL migration extension
c. Connect to the source SQL server and select Migrate to Azure SQL
d. Go through the screens to setup and access the full backup

shir has to be installed as part of this
Also if you use a domain account you must connect to the local server with the server name and not .

If this fails for any reason and you need to clear the status you must delete local files at c:\users\<login>\appdata\roaming\azuredatastudio.

3. Backup the transaction log on the source SQL Server
 
BACKUP LOG tpcc TO DISK = 'c:\sqlbackups\tpcc_log.bak' WITH INIT, CHECKSUM;
GO

4. Monitor the log backup was restored and applied

Our services poll for backups so there can be a delay of a few minutes to see the log appear as restoring.

Look at the portal and the Migrate extension

5. See the db is restoring from SSMS

## Perform cutover to MI

1. Use extension to do a cutover

2. Backup tail of the log

BACKUP LOG tpcc TO DISK = 'c:\sqlbackups\tpcc_tail_log.bak' WITH INIT, CHECKSUM;
GO

3. Perform cutover

4. Mpnitor cutover sucessful

5. Use SSMS to monitor db now online

1. ## Migrate other objects

1. Migrate Windows logins to AAD

2. Migrate SQL Agent job for index reorg

3. Migrate XEvent session

4. Migrate SSIS agent job
