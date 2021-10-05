DROP LOGIN sqladmin;
GO
CREATE LOGIN sqladmin WITH PASSWORD = 'ComplexPassw0rd#';
GO
EXEC sp_addsrvrolemember @loginame = 'sqladmin', @rolename = 'sysadmin';
GO