/* Purpose: Creating view objects in the database AragonMunicipalLibrary2022

*/



use AragonMunicipalLibrary2022
;
go 

 -- #1 create a Mailing List incuding member full name and complete address


create view Loansandmembers.MailingList
AS
	SELECT M.F_Name, M.MiddleInitial, M.L_Name, A.StreetAddress, C.CityName, C.Province, A.PostalCode
	FROM LoansAndMembers.Member as M
		INNER JOIN LoansAndMembers.Adult as A 
			ON (A.Member_No = M.Member_No)
		       INNER JOIN BooksAndLibraries.City as C
			   ON (C.CityID = A.CityID) 
			   where A.MailListRequest='y'
;
go

-- #2 Query that returns book details for ISBN's 1, 500 and 1001, ordered by ISBN.

SELECT I.ISBN, TL.translation, I.cover, T.title, C.copyID, C.OnLoan
FROM  BooksAndLibraries.Item as I
	INNER JOIN BooksAndLibraries.Title as T
		ON (T.titleID = I.titleID)
			INNER JOIN BooksAndLibraries.Copy as C
				ON (C.ISBN = I.ISBN)
				inner join BooksAndLibraries.Translation as TL
				ON (TL.TranslationID=I.TranslationID)
WHERE I.ISBN in (1, 500, 1001)
ORDER BY ISBN asc
;
go



-- #3 Query that returns reservations of members 250, 341, 1675.

SELECT loansandmembers.fullname(M.F_Name,M.MiddleInitial,M.L_Name) as [Full Name], R.ISBN, R.DateRequested 
FROM LoansAndMembers.Member as M
	left join LoansAndMembers.Reservation as R
	on (M.Member_No = R.Member_No)
WHERE M.Member_No IN ('1','250', '341', '1675')
ORDER BY M.Member_No asc;
go

-- #4 create a view that returns the full name and address for all adults.


create view loansandmembers.adultwideView
AS
	SELECT M.F_Name, ISNULL(M.MiddleInitial,'') as MiddleInitial, M.L_Name, A.StreetAddress, C.CityName, C.Province, A.PostalCode
	FROM LoansAndMembers.Member as M
		INNER JOIN LoansAndMembers.Adult as A 
				ON (A.Member_No = M.Member_No)
		       INNER JOIN BooksAndLibraries.City as C
			   ON (C.CityID = A.CityID) 
;
go


-- #5 Create a view that lists the name & address for all juveniles.


create view loansandmembers.childwideView
AS
	SELECT M.F_Name, M.L_Name, A.StreetAddress, C.CityName, C.Province, A.PostalCode
    FROM LoansAndMembers.Member as M
	INNER JOIN LoansAndMembers.Juvenile as J
        		ON(J.Member_No = M.Member_No)
		INNER JOIN LoansAndMembers.Adult as A
				ON(A.Member_No = J.AdultMember_No)
		   INNER JOIN BooksAndLibraries.City as C
            ON (C.CityID = A.CityID)
;
go


-- #6 Create a view that lists complete information about each copy.

create view booksandlibraries.CopywideView
AS
	SELECT C.*,I.Cover,I.Edition,P.PublishingHouseName,TL.Translation,I.YearPublished, T.*
    FROM BooksAndLibraries.copy as C
	inner join BooksAndLibraries.Item as I
	on (C.ISBN=I.ISBN)
	inner join BooksAndLibraries.Title as T
	on (I.TitleID=T.TitleID)
	inner join BooksAndLibraries.PublishingHouse as P
	on (P.PublishingHouseID=I.PublishingHouseID)
	inner join BooksAndLibraries.Translation as TL
	on (TL.TranslationID=I.TranslationID)
;
go

-- Create a view that lists complete information about each loanable copy.

create view booksandlibraries.LoanableView
as 
select *
from booksandlibraries.CopywideView as CV
where CV.loanable='y'
go


-- Create a view that lists complete information about each copy on shelf.

create view booksandlibraries.onShelfView
as 
select *
from booksandlibraries.CopywideView as CV
where CV.OnLoan='n'
go



--9. Create a view that lists information about each copy on loan.


create view LoansAndMembers.OnLoanView
AS
	SELECT M.Member_No, M.F_Name, M.L_Name, L.DateCheckedOut, LoansAndMembers.datedue(L.DateCheckedOut) as DateDue, T.Title, L.CopyID
	FROM LoansAndMembers.Member as M
		INNER JOIN LoansAndMembers.Loan as L 
				ON (M.Member_No = L.Member_No)
				and L.DateReturned is null
		       INNER JOIN BooksAndLibraries.Item as I
			   ON (L.ISBN = I.ISBN) 
			   Inner join BooksAndLibraries.Title as T
			   on (I.TitleID=T.TitleID)

;
go


--Query the above view and show loans with overdue loans first in chrono order

select * from LoansAndMembers.OnLoanView
order by getdate()-DateCheckedOut desc
;
go


--10. Create a view that lists information about each overdue copy.

create view LoansAndMembers.OverDueView
as
select *
from LoansAndMembers.OnLoanView
where loansandmembers.datedue(datecheckedout)<GETDATE()
;
go


