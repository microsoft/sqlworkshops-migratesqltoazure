# Optimize and manage migration with Azure VM

## Overview

## Explore Azure and use SQL IaaS Agent extension

If not already in use, enable SQL IaaS Agent extension
Explore the portal and az CLI
Enable auto manage backups per the previous backup db and log schedule
    First enable backup checksum from sp_configure and explain why
Enable auto updates

## Secure, apply updates, and Azure Hybrid Benefit (AHB)

Enable JIT for RDP
Disable SQL port because client will join Azure network
Apply all Windows updates and any SQL updates

## Implement best practices

### Secure SQL Server in Azure Virtual Machine

### Optimizing storage

Notice read-only caching is setup for the "data" drive. This is a best practice and can significantly boost read performance but not harm data write performance (based on how SQL Server does data writes). The log doesn't have caching due to sequential mostly write nature.

The OS drive has read/write caching on which is the right choice for the OS drive.

### Optimize system databases

Add tempdb files
Move system dbs to data disk

### Review all our best practices

https://docs.microsoft.com/en-us/azure/azure-sql/virtual-machines/windows/performance-guidelines-best-practices-checklist#overview

## Setup and configure HADR

### Backup/Restore

### Failover Cluster

### Always On Availability Groups

### SQL Server on Linux

## Use the power of Azure

### Setup Microsoft Defender for SQL

### Setup SQL Assessment

TODO: coming in public preview. Checking with Ebru.

### Use SQL Insights

## Verify workload and application

    Install HammerDB

    This is run locally
    
    Use the same driver script settings for 8 virtual users. Run workload and observe when done similar performance as with the SQL 2016 VM.
    Put in here any app impact issues to consider