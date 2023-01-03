/* Purpose: Inserting data into table objects in the database AragonMunicipalLibrary2022
*/


use AragonMunicipalLibrary2022
;
go 

-- Manage Transactions

begin try
begin transaction 

--Insert Values

insert into [LoansAndMembers].[Member] (Member_No, F_Name, MiddleInitial, L_Name)
values
('1','John', null,'Smith'),
('2','Dan','T.', 'Bens'),
('3','Tom',null, 'Martin'),
('4','Jen',null, 'Remi'),
('5','Lori',null, 'Kent'),
('6','Ben','E.', 'Ledford'),
('7','Zoi',null, 'Richards'),
('8','Nancy',null, 'James'),
('9','Markus',null, 'Richards'),
('10','Nancy',null, 'James'),
('11','Tim',null, 'Smith'),
('12','Jacky','F.', 'Bens'),
('13','Lula',null, 'Martin'),
('14','Kevin',null, 'Remi'),
('15','Tammy',null, 'Kent'),
('16','Nick',null, 'Ledford'),
('17','Jen','K.', 'Richards'),
('18','Ben',null, 'James'),
('19','Riley',null, 'Richards'),
('20','Felix',null, 'James'),
('250','James',null, 'Dun'),
('341','Helen',null, 'Carlsbag'),
('1675','Daniel',null, 'Smool')
;


update [LoansAndMembers].[Member]
	set F_Name = 'Jack'
where Member_No = 1
;

commit transaction
end try


begin catch

	select ERROR_NUMBER() as 'Error Number', ERROR_MESSAGE() as 'Error Message'

	rollback transaction

Print '***** Transaction Error - Rolling Back Transaction *****'
end catch
;
go

-- end managed transaction


-- Manage Transactions
begin try
begin transaction 

--Insert Values

insert into [BooksAndLibraries].[Country] (CountryID, CountryName)
values
(1,'Canada')

;

insert into [BooksAndLibraries].[City] (CityID, CityName, Province, CountryID)
values
(1,'Montreal', 'QC', 1)

;

/*The entering the stored values below requires activating the user fuction CREATE FUNCTION Loansandmembers.cardexpiry() which is located in the user_defined_fuction.sql*/

insert into [LoansAndMembers].[Adult] (
	Member_No, StreetAddress, CityID, EmailAddress, PhoneNumber, DateOfBirth, CardExpiry, MailListRequest, PostalCode)
values
('1','120 Hanover Sq.', 1, '123@yahoo.com', '514-884-7521', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'h8P 2N7'),
('2','121 9th.', 1, 'jhg@yahoo.com', '514-877-7871', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'h8P 2N1'),
('3','15 10th ave.', 1, 'hgf67@yahoo.com', '514-894-7431', '2000-01-25',loansandmembers.cardexpiry(GETDATE()),'y', 'h8P 3N2'),
('4','444 Jerry St', 1, 'jyg67@yahoo.com', '514-889-7654', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'h9P 4N7'),
('5','345 hanover BLVD', 1, 'bjy@yahoo.com', '514-536-7874', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'h9P 6N2'),
('6','3235 Hightower ave', 1, 'jg76t@yahoo.com', '514-964-7865', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'G9P 7N9'),
('7','4747 RightLane', 1, 'yugh67t@yahoo.com', '514-567-7568', '2000-01-25',loansandmembers.cardexpiry(GETDATE()),'y', 'K9P 9G9'),
('8','90th ave', 1, 'h87@yahoo.com', '514-345-6521', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'h8P 3N9'),
('9','3457 30th ave', 1, 'g86jgu@yahoo.com', '514-965-8751', '2000-01-25',loansandmembers.cardexpiry(GETDATE()),'y', 'T8P 2N7'),
('10','586 Oregon St', 1, 'hiu87y@yahoo.com', '514-984-7868', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'R9M 1X5'),
('250','587 Dunas St.', 1, 'asd87y@yahoo.com', '514-256-4120', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'F5T 6W4'),
('341','526 Luna St', 1, 'a1287y@yahoo.com', '514-563-1424', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'U9S 7U8'),
('1675','386 Jeffries St', 1, 'acare50y@yahoo.com', '514-152-6942', '2000-01-25', loansandmembers.cardexpiry(GETDATE()),'y', 'L2D 9I8')
;

commit transaction
end try

begin catch

	select ERROR_NUMBER() as 'Error Number', ERROR_MESSAGE() as 'Error Message'

	rollback transaction
	Print '***** Transaction Error - Rolling Back Transaction *****'
end catch
;
go

-- Manage Transactions

begin try
begin transaction 

--Insert Values


insert into [LoansAndMembers].[Juvenile] (
	Member_No, AdultMember_No, DateOfBirth)
values
('11','1', '2010-01-25'),
('12','2', '2010-01-25'),
('13','3', '2010-01-25'),
('14','4', '2010-01-25'),
('15','5', '2010-01-25'),
('16','6', '2010-01-25'),
('17','7', '2010-01-25'),
('18','8', '2010-01-25'),
('19','9', '2010-01-25'),
('20','10', '2003-01-25')
;


insert into BooksAndLibraries.Category(
	CategoryID,CategoryName)
	values
	(1,'SciFi'),
	(2,'Mystery'),
	(3,'Classics'),
	(4,'Action'),
	(5,'Comedy'),
	(6,'Fantasy'),
	(7,'Science'),
	(8,'Mechanics'),
	(9,'Computers')
	;

insert into [BooksAndLibraries].[Title] (
	[TitleID] , [Title], CategoryID)
values
(1,'Moby Dick',4),
(2,'Dancing',5 ),
(3,'Homer',3),
(4,'Ring of Fire',6 ),
(5,'Sailing the Seas',4 ),
(6,'Air Force 1',4),
(7,'Live Love Laugh',5),
(8,'How to Do Everything',8 ),
(9,'Databases for Dummies',9 ),
(10,'Circus Circus',5),
(11,'The Foundation',1),
(12,'Jason Bourne',4 ),
(13,'Sherlock Holmes',2),
(14,'Game of Thrones',6 ),
(15,'Pride and Prejudice',3 ),
(16,'War of Worlds',1),
(17,'Plato',3),
(18,'Cars and Planes',8 ),
(19,'JAVA is the Best',9 ),
(20,'Learn Android',9)
;

insert into [BooksAndLibraries].[PublishingHouse] (
	[PublishingHouseID], [PublishingHouseName],  [CityID])
values
( 1, 'AOS Publishing Inc.', 1 ),
(2, 'Bob Publishing Inc.', 1 ),
( 3, 'Coolblishing Inc.', 1 ),
( 4, 'Nice Publishing Inc.', 1 ),
( 5, 'Big Publishing Inc.', 1  ),
( 6, 'Heavy Publishing Inc.', 1 ),
( 7, 'Rockstar Publishing Inc.', 1 ),
( 8, 'Party Publishing Inc.', 1  ),
( 9, 'House Publishing Inc.', 1  ),
( 10, 'Fire Publishing Inc.', 1 )
;

insert into [BooksAndLibraries].[Translation] (
	 [TranslationID], [Translation])
values
( 1, 'fr' ),
( 2, 'en' )

;
insert into [BooksAndLibraries].[Item] (
	[ISBN],[PublishingHouseID], [TitleID],  [TranslationID], [Edition], Cover)
values
(001, 1, 11,  1, 1, 'H' ),
(002, 9, 12, 2, 1, 'H' ),
(003, 1, 13 , 1, 2, 'H'),
(004, 2, 14,  2, 4, 'S' ),
(005, 4, 15,  1, 2, 'H' ),
(500, 1, 1,  1, 1, 'H' ),
(501, 9, 2, 2, 1, 'H' ),
(502, 1, 3 , 1, 2, 'H'),
(503, 2, 4,  2, 1, 'S' ),
(504, 4, 5,  1, 2, 'H' ),
(505, 2, 6, 2, 3, 'H'),
(506, 3, 7,  1, 2, 'S'),
(507, 3, 8,  2, 1, 'H' ),
(508, 3, 9, 1, 2, 'H' ),
(509, 6, 10,  2, 1, 'H'),
(1001, 3, 16,  1, 2, 'S'),
(1002, 3, 17,  2, 1, 'H' ),
(1003, 3, 18, 1, 2, 'H' ),
(1004, 6, 19,  2, 1, 'H'),
(1005, 6, 20,  2, 1, 'H')
;

insert into [BooksAndLibraries].author (
	AuthorID,F_Name,L_Name)
values
(1,'James','Buchanan'),
(2,'Jane','Canede'),
(3,'John','Basil'),
(4,'Lester','Pennington' ),
(5,'Stewart','Bert' ),
(6,'Jules','Verne'),
(7,'HG','Wells'),
(8,'Bill','Overhouse' ),
(9,'Asterix','Elesterol'),
(10,'Evan','Corider'),
(11,'Isaac','Asimov'),
(12,'Benie','Jeens' ),
(13,'Alfie','Smith'),
(14,'Orle','Canves'),
(15,'Earl','Corns'),
(16,'Verica','Emali'),
(17,'Jason','Carnegie'),
(18,'Evander','Holy'),
(19,'Ert','Kennie'),
(20,'Warner','Davis')
;


insert into BooksAndLibraries.Authorship(
	ISBN, AuthorID)
values
(001,1 ),
(002,2 ),
(003,3),
(004,4 ),
(005,5),
(500,6 ),
(501,7 ),
(502, 8),
(503,9 ),
(504,10 ),
(505,11 ),
(506,12 ),
(507,13 ),
(508,14 ),
(509,15 ),
(1001,16),
(1002,17 ),
(1003,18 ),
(1004,19 ),
(1005,20 )
;





insert into [BooksAndLibraries].[Library] (
	[LibraryID], [LibraryName], [Address], [CityID], [PhoneNumber], [Fax], [Email] )
values
('Ara01', 'AragonMunicipalLibrary', '132 7e Ave', 1, '514-884-7412', '5148867598', 'AragonMunicipalLibrary@yahoo.com' )

;

insert into [BooksAndLibraries].[Copy] (
	[ISBN],[CopyID] , [LibraryID], [OnLoan], [LoanAble])
values
(001,1, 'Ara01', 'n', 'y' ),
(002,1, 'Ara01', 'n', 'y' ),
(003,1, 'Ara01', 'y', 'y' ),
(004,1, 'Ara01', 'n', 'y' ),
(005,1, 'Ara01', 'y', 'y' ),
(500,1, 'Ara01', 'n', 'y' ),
(500,2, 'Ara01', 'n', 'y' ),
(500,3, 'Ara01', 'y', 'y' ),
(501,1, 'Ara01', 'n', 'y' ),
(502,1, 'Ara01', 'n', 'y' ),
(503,1, 'Ara01', 'n', 'y' ),
(504,1, 'Ara01', 'y', 'y' ),
(505,1, 'Ara01', 'n', 'y' ),
(505,2, 'Ara01', 'y', 'y' ),
(506,1, 'Ara01', 'n', 'y' ),
(507,1, 'Ara01', 'n', 'n' ),
(508,1, 'Ara01', 'y', 'y' ),
(508,2, 'Ara01', 'n', 'n' ),
(509,1, 'Ara01', 'n', 'y' ),
(1001,1, 'Ara01', 'n', 'y' ),
(1002,1, 'Ara01', 'n', 'y' ),
(1003,1, 'Ara01', 'n', 'y' ),
(1004,1, 'Ara01', 'y', 'y' ),
(1005,1, 'Ara01', 'n', 'y' )

;


insert into [LoansAndMembers].[Reservation] (
	[Member_No] , [ISBN], [DateRequested], [DateFulfilled])
values
( 1, 500,  '2022-01-01 11:30:00', '2022-01-25 11:30:00' ),
( 2, 508, '2022-01-10 11:30:00', '2022-01-26 11:30:00' ),
( 3, 503,'2022-02-01 11:30:00', '2022-02-25 11:30:00' ),
( 1, 505, '2022-03-01 11:30:00', '2022-03-25 11:30:00' ),
(5, 504,  '2022-03-01 12:30:00', '2022-03-20 11:30:00' ),
(8, 508,  '2022-04-01 11:30:00', '2022-04-25 11:30:00' ),
(3, 507,  '2022-05-01 11:30:00', '2022-05-10 11:30:00' ),
(11, 505,  '2022-06-01 11:30:00', NULL ),
(5, 504,  '2022-06-01 11:30:00', NULL ),
(8, 500,  '2022-06-05 11:30:00', NULL ),
(250, 506,  '2022-05-02 11:30:00', NULL ),
(341, 503,  '2022-05-09 11:30:00', NULL ),
(1675, 502,  '2022-04-05 11:30:00', NULL )
;


insert into [LoansAndMembers].[Loan] (
	  [ISBN], [CopyID], [Member_No], [DateCheckedOut], [DateReturned] )
values
( 500, 1, 1,  '2021-01-25 11:30:00', '2021-02-04 11:30:00' ),
( 508,1, 2,  '2021-01-26 11:30:00', '2021-02-04 11:30:00' ),
( 503, 1,3,  '2021-02-25 11:30:00', '2021-03-25 11:30:00' ),
( 505,2, 1,  '2021-03-25 1:30:00', '2021-04-02 11:30:00' ),
(504, 1, 5,  '2022-03-20 11:30:00', '2022-05-20 11:30:00' ),
(508, 1, 8,  '2022-04-25 11:30:00', '2022-05-25 11:30:00' ),
(507, 1, 3,   '2022-05-10 1:30:00', '2022-05-20 11:30:00' ),
(505, 1, 11, '2022-05-10 10:30:00', NULL ),
(504, 1, 5, '2022-05-17 11:30:00', NULL ),
(500, 3,8, '2022-06-10 11:30:00', NULL )
;

commit transaction
end try

begin catch

	select ERROR_NUMBER() as 'Error Number', ERROR_MESSAGE() as 'Error Message'

	rollback transaction
	Print '***** Transaction Error - Rolling Back Transaction *****'
end catch
;
go
