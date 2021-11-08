# Optimize and manage migration with Azure VM

## Overview

## Explore Azure and use SQL IaaS Agent extension

If not already in use, enable SQL IaaS Agent extension
Explore the portal and az CLI
Enable auto manage backups per the previous backup db and log schedule
    First enable backup checksum from sp_configure and explain why
Enable auto updates
Use AHB
Pricing calculator to see the price diff also with reserved instances concept

## Implement best practices

### Secure SQL Server in Azure Virtual Machine

Enable JIT for RDP or SSH
Disable SQL port because client will join Azure network
Apply all OS updates and any SQL updates

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

### Use SQL Insights

## Verify workload and application