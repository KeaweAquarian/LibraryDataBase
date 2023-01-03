/* Purpose: Applying Data Integrity to the Table Objects in the database  AragonMunicipalLibrary2022

*/


use AragonMunicipalLibrary2022
;
go 


/***** Table No. 1 - BooksandLibraries.Library *****/
-- Foreign key constraints

ALTER TABLE BooksandLibraries.Library
	add constraint fk_Libraries_City foreign key (CityID)
		references BooksandLibraries.City (CityID)
;
go

--default
ALTER TABLE BooksandLibraries.Library
			add constraint df_Library default ('Aragon Municipal Library') for LibraryName
;
go

--checks
alter table BooksandLibraries.Library
ADD CONSTRAINT Lbrary_ValidPhone
CHECK (PhoneNumber LIKE '[0-9][0-9][0-9] [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
OR PhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
;
go


/***** Table No. 2 - BooksandLibraries.City *****/

-- Foreign key constraints

ALTER TABLE BooksandLibraries.City
	add constraint fk_City_Country foreign key (CountryID)
		references BooksandLibraries.Country (CountryID)
;
go
--default constraints
ALTER TABLE BooksandLibraries.City
			add constraint df_CityName default ('Montreal') for CityName
;
go


ALTER TABLE BooksandLibraries.City
			add constraint df_Province default ('QC') for Province
;
go
/***** Table No. 3 - BooksandLibraries.Country *****/
--No further constraints

/***** Table No. 4 - BooksandLibraries.Item *****/

--foreign key

Alter table Booksandlibraries.item
add  CONSTRAINT fk_item_title FOREIGN KEY (TitleID)
    REFERENCES Booksandlibraries.Title(TitleID);

Alter table booksandlibraries.item
add  CONSTRAINT fk_item_publishing FOREIGN KEY (PublishinghouseID)
    REFERENCES booksandlibraries.PublishingHouse (PublishinghouseID);

Alter table booksandlibraries.item
add  CONSTRAINT fk_item_translation FOREIGN KEY (translationID)
    REFERENCES booksandlibraries.translation (translationID);



/***** Table No. 5 - BooksandLibraries.Copy *****/
--foreign keys

Alter table booksandlibraries.copy
add  CONSTRAINT fk_copy_item FOREIGN KEY (ISBN)
    REFERENCES booksandlibraries.item (ISBN);

	Alter table booksandlibraries.copy
add  CONSTRAINT fk_copy_libraryID FOREIGN KEY (LibraryID)
    REFERENCES booksandlibraries.library (LibraryID);
	
/***** Table No. 6 - BooksandLibraries.Title *****/
-- Foreign key constraints


alter table BooksandLibraries.Title
	add constraint fk_Title_Category foreign key (CategoryID) references BooksandLibraries.Category (CategoryID)
;
go


/***** Table No. 7 - BooksandLibraries.Category *****/
-- No further constraints

/***** Table No. 8 - BooksandLibraries.PublishingHouse *****/
-- Foreign key constraints

alter table BooksandLibraries.PublishingHouse
	add constraint fk_PublishingHouse_City foreign key (CityID) references BooksandLibraries.City (CityID)
;
go

/***** Table No. 9 - BooksandLibraries.TitleAuthor *****/
-- Foreign key constraints

Alter table booksandlibraries.authorship
add  CONSTRAINT fk_authorship_item FOREIGN KEY (ISBN)
    REFERENCES booksandlibraries.item (ISBN);

Alter table booksandlibraries.authorship
add  CONSTRAINT fk_authorship_authorID FOREIGN KEY (authorID)
    REFERENCES booksandlibraries.author (authorID);

	/***** Table No. 10 - BooksandLibraries.Author *****/
-- No constraints

	/***** Table No. 11 - BooksandLibraries.Translation *****/
-- No constraints

/***** Table No. 12 - LoansAndMembers.Member *****/
--no constraints


/***** Table No. 13 - LoansAndMembers.Loan *****/
-- Foreign key constraints

alter table LoansAndMembers.Loan
	add constraint fk_Loan_Copy1 foreign key (ISBN, CopyID) references BooksandLibraries.Copy (ISBN, CopyID)
;
go

alter table LoansAndMembers.Loan
	add constraint fk_Loan_Member foreign key (Member_No) references LoansAndMembers.Member (Member_No)
;
go

--check constraints
alter table LoansAndMembers.Loan
	add constraint ck_DateLoaned_DateReturned check (DateReturned > DateCheckedOut)
;
go

alter table LoansAndMembers.Loan
	add constraint ck_DateLoaned check (DateCheckedOut<=GETDATE())
;
go

alter table LoansAndMembers.Loan
	add constraint ck_returned check (DateReturned<=GETDATE())
;
go


/***** Table No. 14 - LoansAndMembers.Reservation *****/
-- Foreign key constraints

alter table LoansAndMembers.Reservation
	add constraint fk_Reservation_Item foreign key (ISBN) references BooksandLibraries.Item (ISBN)
;
go
alter table LoansAndMembers.Reservation
	add constraint fk_Reservation_Member foreign key (member_No) references LoansAndMembers.Member (Member_No)
;
go


/***** Table No. 15 - LoansAndMembers.Adult *****/
-- Foreign key constraints


alter table LoansAndMembers.Adult
	add constraint fk_Adult_Member foreign key (Member_No) references LoansAndMembers.Member (Member_No)
;
go

alter table LoansAndMembers.Adult
	add constraint fk_Adult_City foreign key (CityID) references BooksAndLibraries.City (CityID)
;
go

--check constraints
alter table LoansAndMembers.Adult
ADD CONSTRAINT Adult_ValidPhone
CHECK (PhoneNumber LIKE '[0-9][0-9][0-9] [0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'
OR PhoneNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
;
go



/***** Table No. 16 - LoansAndMembers.Juvenile *****/
-- Foreign key constraints

alter table LoansAndMembers.Juvenile
	add constraint fk_Juvenile_Adult foreign key (AdultMember_No) references LoansAndMembers.Adult (Member_No)
;
go

alter table LoansAndMembers.Juvenile
	add constraint fk_Juvenile_Member foreign key (Member_No) references LoansAndMembers.Member (Member_No)
;
go