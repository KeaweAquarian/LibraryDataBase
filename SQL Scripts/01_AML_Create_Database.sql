/* Team Project - Version 1 - Aragon Municipal Library

*/

use master
;
go 



-- create the Aragon Municipal 2022 database
create database AragonMunicipalLibrary2022
on primary
(
	-- 1) rows data logical filename
	name = 'AragonMunicipalLibrary2022',
	-- 2) rows data initial file size
	size = 12MB,
	-- 3) rows data auto growth size
	filegrowth = 8MB,
	-- 4) rows data maximum size
	maxsize = 500MB, -- unlimited
	-- 5) rows data path and file name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AragonMunicipalLibrary2022.mdf'
)
-- transaction log
log on
(
	-- 1) log logical filename
	name = 'AragonMunicipalLibrary2022_log',
	-- 2) log initial file size (1/4 the rows data file size)
	size = 3MB,
	-- 3) log auto growth size
	filegrowth = 10%,
	-- 4) log maximum size
	maxsize = 25MB, 
	-- 5) log path and file name
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AragonMunicipalLibrary2022_log.ldf'
)
;
go


