
/*
--Purpose: Creating user defined functions in the database AragonMunicipalLibrary2022
*/



Use AragonMunicipalLibrary2022;
go

--calculate due date

CREATE FUNCTION Loansandmembers.datedue(
	@datecheckedout Datetime
)
RETURNS datetime AS
BEGIN
	DECLARE @datedue datetime;
	SET @datedue = dateadd(day,14,@datecheckedout);
    RETURN @datedue;
END;

--calculate cardexpiry
go

CREATE FUNCTION Loansandmembers.cardexpiry(
	@dateregistered Datetime
)
RETURNS datetime AS
BEGIN
	DECLARE @cardexpiry datetime;
	SET @cardexpiry = dateadd(year,1,@dateregistered);
    RETURN @cardexpiry;
END;

go

CREATE FUNCTION Loansandmembers.fullname(
	@F_Name nvarchar(60), @MiddleInitial nvarchar(60) ,@L_Name nvarchar(60))
RETURNS nvarchar(60) AS
BEGIN
	DECLARE @fullname nvarchar(60);
	SET @fullname = LTRIM(RTRIM(REPLACE(@F_Name+' '+ ISNULL(@MiddleInitial,'')+' '+ @L_Name,'  ',' ')));
    RETURN @fullname;
END;
GO



/* This function is used when a member's card is run. The card number is the @Member_No which automatically calls this function displaying for the libraian all of the members information and loan history,
 highliting both the members card status and each of their loans with the CardStatus column and the Loan status column.
The funtion can be called displaying the selected innformation grouped first by LoanStatus Overdue first then the DateCheckedOut of each title sorted in DESC order
 so that the librarians can see the most overdue items first by calling:
		select *
		from [LoansAndMembers].MembersAccountTF (Member_No)
				
				order by LoanSatus ASC, DateCheckedOut DESC		   
		;
		go

*/

create function [LoansAndMembers].MembersAccountTF
(
	-- declare parameters
	@Member_No as int
)
-- function return data type
returns table
as
	return
		(

	SELECT M.Member_No, M.F_Name, M.L_Name, A.StreetAddress, A.PostalCode, A.PhoneNumber, A.CardExpiry,
		'CardSatus' =  
case
     when GETDATE() >= DateAdd(day, 30, convert(date, CardExpiry, 0))  then 'Card Expired' 
	  else 'Card valid'
	  end,
	L.DateCheckedOut, DateAdd(day, 14, convert(date, DateCheckedOut, 0)) as DateDue, T.Title, L.CopyID,
	'LoanSatus' =  
case
     when GETDATE() >= DateAdd(day, 14, convert(date, DateCheckedOut, 0)) and
	 [DateReturned]is null then 'Overdue' 
	  else 'Valid loan'
	  end
	FROM LoansAndMembers.Member as M
		INNER JOIN LoansAndMembers.Loan as L 
				ON (M.Member_No = L.Member_No)
				INNER JOIN [LoansAndMembers].[Adult] as A
				ON (A.Member_No = L.Member_No)
		       INNER JOIN BooksAndLibraries.Item as I
			   ON (L.ISBN = I.ISBN) 
			   Inner join BooksAndLibraries.Title as T
			   on (I.TitleID=T.TitleID)
    where L.Member_No = @Member_No

	)
	;
	go