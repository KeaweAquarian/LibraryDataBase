/* Purpose: Creating Table objects in the database AragonMunicipalLibrary2022

*/

use AragonMunicipalLibrary2022
;
go 


/* ***** Table No. 1 - BooksandLibraries.Library ***** */
create table BooksAndLibraries.Library 
(
	
	LibraryID nchar(5) not null,	-- PK
	LibraryName nvarchar(40) not null,
	Address nvarchar(60) not null,	-- Street Number and Street Name 
	CityID int not null,
	PhoneNumber PhoneNo not null,		-- Phone number includes country code and / or area code
	Fax PhoneNo null,		-- Fax number includes country code and / or area code
	Email nvarchar(60) not null,
	Website nvarchar(60) null,		-- Library URL
	constraint pk_LibraryID primary key clustered (LibraryID asc)
)
;
go


/* ***** Table No. 2 - BooksandLibraries.City ***** */


create table BooksandLibraries.City 
(
    CityID int not null, --PK
	CityName nvarchar(30) not null,
	Province ProvinceCode not null,
	CountryID int not null,
	constraint pk_CityId primary key clustered (CityID asc)
)
;
go

/* ***** Table No. 3 - BooksandLibraries.Country ***** */



create table BooksandLibraries.Country 
(

	CountryID int not null, --PK
	CountryName nvarchar(255) not null,
	constraint pk_CountryId primary key clustered (CountryID asc)
)
;
go


/***** Table No. 4 - BooksandLibraries.Item *****/


create table BooksandLibraries.Item
(
	ISBN bigint not null, -- Primary key
	TitleID int not null, --FK
	PublishingHouseID int NOT NULL, -- FK
	TranslationID tinyint not null, --FK -- language id, i.e. 1 for english
	YearPublished date NULL,
	Edition tinyint not null,
	Cover nchar(1) not NULL, -- H for hardcover, S for soft
	
	constraint pk_ISBN primary key clustered (ISBN asc)
)
;
go


/***** Table No. 5 - BooksandLibraries.Copy *****/


create table BooksandLibraries.Copy
(
	ISBN bigint not null, -- Primary key, Foreign Key
	CopyID tinyint not null, -- Primary key, number of copies of a given book item
	LibraryID nchar(5) not null,	-- FK
	OnLoan nchar(1) not null, --  y or n
	Condition nvarchar(60) null, --description of condition
    LoanAble nchar(1) NOT NULL, -- y or n
	constraint pk_ISBN_CopyId primary key clustered (ISBN, CopyID asc)
)
;
go


/***** Table No. 6 - BooksandLibraries.Category *****/


CREATE TABLE BooksandLibraries.Category
(
	CategoryID nvarchar(6) NOT NULL, -- Primary Key
	CategoryName nvarchar(40) NOT NULL,
 
	CONSTRAINT pk_category PRIMARY KEY Clustered
	(
		CategoryID asc
	)
)
;
go



/***** Table No. 7 - BooksandLibraries.Title *****/


CREATE TABLE BooksandLibraries.Title
(
	TitleID int not null, --PK
	CategoryID nvarchar(6) not NULL, -- FK
	Title nvarchar (255) NOT Null,
	Synopis Synopsis NULL,

	
	CONSTRAINT pk_TitleID PRIMARY KEY CLUSTERED 
		(
			TitleID ASC
		)

	
)
; 
go
/***** Table No. 7 - BooksandLibraries.Title *****/

create table BooksandLibraries.Translation
(	
	TranslationID tinyint not null, --pk
	Translation nvarchar(30) not null --full description of language, i.e English, French

	constraint pk_TranslationID primary key clustered
	 (
	 TranslationID asc
	 ) 
	 
);
go



/***** Table No. 8 - BooksandLibraries.PublishingHouse *****/

CREATE TABLE BooksandLibraries.PublishingHouse
(
	PublishingHouseID int NOT NULL, -- PK
	PublishingHouseName nvarchar(200) NOT NULL, 
	CityID int NOT NULL, -- FK
	CONSTRAINT pk_PublishingHouse PRIMARY KEY CLUSTERED 
	(
		PublishingHouseID ASC
	)
)
;
go


/***** Table No. 9 - BooksandLibraries.TitleAuthor  *****/


CREATE TABLE BooksandLibraries.Authorship
(
    ISBN bigint not null, -- PK, FK
	AuthorID int NOT NULL, -- PK, FK
		CONSTRAINT pk_authorship PRIMARY KEY 
	(
		ISBN, AuthorID ASC
	)
)
;
go





/***** Table No. 10 - BooksandLibraries.Author  *****/


CREATE TABLE BooksandLibraries.Author
( 
	AuthorID int NOT NULL, --PK
	F_Name varchar(60) NOT NULL,
	L_Name varchar(60) NOT NULL,
	DateBirth date NULL,
	constraint pk_AuthorID primary key clustered (AuthorID asc)
) 
;
GO


/***** Table No. 11 - LoansAndMembers.Member  *****/


CREATE TABLE LoansAndMembers.Member 
(
	Member_No int NOT NULL, -- PK
	L_Name nvarchar(60) NOT NULL,
	F_Name nvarchar(60) NOT NULL,
	MiddleInitial nvarchar(60) NULL,
	Photograph varbinary(max) NULL,
	
	constraint pk_Member_No primary key clustered (Member_No asc)
) 
;
GO



/***** Table No. 13 - LoansAndMembers.Loan  *****/

drop table LoansAndMembers.Loan

CREATE TABLE LoansAndMembers.Loan
(
     LoanID int IDENTITY(1,1) not null,	-- PK
	 ISBN bigint not null, -- FK
	 CopyID tinyint not null, -- FK
     Member_No int NOT NULL, -- FK
	 DateCheckedOut datetime NOT NULL, 
	 DateReturned datetime NULL, -- if book hasn't been returned, this will be null.
	CONSTRAINT pk_LoanID PRIMARY KEY  CLUSTERED 
	(	
		
		LoanID asc
	) 
)
;
GO



/***** Table No. 15 - LoansAndMembers.Reservation  *****/


CREATE TABLE LoansAndMembers.Reservation
( 
    ReservationID int identity(1, 1) not null,	-- PK 
	Member_No int NOT NULL, -- FK
    ISBN bigint not null, -- FK
	DateRequested datetime NOT NULL,
	DateFulfilled datetime NULL, --date when book was loaned by the reserving member. Null means the member is still waiting.

	CONSTRAINT pk_ReservationID PRIMARY KEY  CLUSTERED 
	(
		ReservationID asc
	) 
)
;
GO

/***** Table No. 16 - LoansAndMembers.Adult  *****/


CREATE TABLE LoansAndMembers.Adult
( 
	Member_No int NOT NULL, -- PK, FK
	
	StreetAddress nvarchar(255) not null, 
    CityID int not null,
	PostalCode nvarchar(10) not null,
	EmailAddress nvarchar(50) not NULL, 
	PhoneNumber PhoneNo NULL, 
    DateOfBirth  DATE NOT NULL,
	CardExpiry datetime NOT NULL,
	MailListRequest nchar(1) not null,
	constraint pk_AdultMember_No primary key clustered (Member_No asc)

)
;
GO

/***** Table No. 17 - LoansAndMembers.Juvenile  *****/


CREATE TABLE LoansAndMembers.Juvenile
( 
	Member_No int NOT NULL, -- PK, FK
    AdultMember_No int NOT NULL, -- FK, this is the member number of the guardian adult for this juvenile.
    DateOfBirth  DATE NOT NULL,
	
	CONSTRAINT pk_JuvenileMember_No PRIMARY KEY  CLUSTERED 
	(
		Member_No asc
	) 
)
;
GO

