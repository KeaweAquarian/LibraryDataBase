/* Purpose: Creating User Defined Procedures in the database AragonMunicipalLibrary2022
*/



use AragonMunicipalLibrary2022
;
go 


-- Usage Report No 1. Calculate the amount of Loans the library did in 2021 

create procedure loansandmembers.TotalLoansIn2021
as
SELECT
	COUNT(loanID) as 'Total Loans in 2021'
	FROM LoansAndMembers.Loan
	WHERE year(DateCheckedOut) = 2021
	
;
go



-- Usage Report #2 What percentage of the membership borrowed at least one book? 


create procedure loansandmembers.whatPercentageMembershipBorrowedOneOrMoreBooks
as
	select 
	ROUND(
	cast(count(distinct [LoansAndMembers].[Loan].member_no) as float) 
	/ 
	cast(count(distinct [LoansAndMembers].[Member].member_no) as float) 
	* 100
	, 2
	) 
	as 'The percentage of membership that borrowed at least one book'
	FROM
	[LoansAndMembers].[Loan]
	FULL OUTER JOIN
	[LoansAndMembers].[Member]
	ON [LoansAndMembers].[Loan].member_no = [LoansAndMembers].[Member].member_no
;
go


-- Usage report 3. What was the greatest number of books borrowed by any one individual?

create procedure loansandmembers.greatestNumOfBooks
as
Select NumberOfLoans as [Greatest Num of Loans] from (
select top 1 M.Member_No,M.F_Name,M.L_Name,COUNT(L.Member_No) as NumberOfLoans
from LoansAndMembers.Loan as L
	inner join LoansAndMembers.Member as M
	on (L.Member_No=M.Member_No)
group by M.Member_No, M.F_Name, M.L_Name
order by NumberOfLoans desc

)as MaxNumOfLoans
go


-- Usage Report #4 What percentage of the books was loaned out at least once last year?
--assuming percentage of items(ISBN's) not copies.


create procedure loansandmembers.whatPercentageBooksLoanedOnceLastYear
as
select 
	cast(COUNT(distinct(loansandmembers.loan.ISBN))as float)
	/
	(select cast(count(BooksAndLibraries.item.ISBN)as float) from BooksAndLibraries.item)
from LoansAndMembers.Loan
where year(LoansAndMembers.loan.datecheckedout)=year(DATEADD(YEAR, -1, GETDATE()))
go


--Usage Question #5 Percentage of all loans that would become overdue
--Ignoring books currently on loan which are not overdue yet.



create procedure loansandmembers.PercentageOverdue
as
select 
	CONVERT(Decimal(4,2), COUNT(case when datediff(dd,datecheckedout,datereturned)>14 then 1 end)+COUNT(case when datereturned is null AND loansandmembers.datedue(datecheckedout)<GETDATE() then 1 end))
	/CONVERT(Decimal(4,2),count(loanID)-COUNT(case when datereturned is null AND loansandmembers.datedue(datecheckedout)>GETDATE() then 1 end))*100
from LoansAndMembers.Loan
go





--Usage report #6. What is the average length of a loan? 
--not including books still out on loan


create procedure loansandmembers.averageLengthOfLoan
as
	select AVG(datediff(dd,DateCheckedOut,DateReturned)) as 'Average Length of Loans in days'
	from LoansAndMembers.Loan 
;
	
go





--7. What are the library's peak hours for loans?



create procedure booksandlibraries.findLibraryPeakHoursLoans
as
	select top 1
	DATEPART(HOUR, DateCheckedOut) as [Peak Hour]
	from [LoansAndMembers].[Loan]
	group by  DATEPART(HOUR, DateCheckedOut)
	order by count(DATEPART(HOUR, DateCheckedOut)) desc
go



/* The two procedures below are to automate the process of emailing members when their cards are set to expire 30 days out. Procedure 1 'SendEmailNotification' 
selects all the emails and member numbers from the Adult table that have cards that are going to expire in 30 days. The second procedure 'ScheduleEmailsRimindersDaily' 
schedules a loop that runs the first procedure everyday. A third procedure is also added to initiate the schedule procedure if the system is shutdown.
 It is assumed that the library's network admin has already set up the libraries email system and the Database Mail must be enabled using the Database 
Mail Configuration Wizard, or sp_configure. */
USE AragonMunicipalLibrary2022 ;  
GO  

-- Email all members whose card will expire in 30 days.
CREATE PROCEDURE SendEmailNotification
AS
BEGIN 
DECLARE @Email nvarchar(50),
        @Member_No INT;


DECLARE cursorElement CURSOR FOR
            SELECT  EmailAddress, [Member_No]
            FROM    [LoansAndMembers].[Adult]
			WHERE   (DateDiff(day, convert(date, getDate()), CardExpiry) = 30)


OPEN cursorElement
FETCH NEXT FROM cursorElement INTO @Email, @Member_No

WHILE ( @@FETCH_STATUS = 0 )
BEGIN
    EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'Aragon Libraey Administrator',  
    @recipients = @Email,  
    @body = 'Your library card will expire in 30 days.',  
    @subject = 'Library card expiring' ; 

    FETCH NEXT FROM cursorElement INTO @Email, @Member_No
END         
CLOSE cursorElement
DEALLOCATE cursorElement

END
go


-- Schedule the procedure to run everyday.
CREATE PROCEDURE ScheduleEmailsRemindersDaily
AS
BEGIN  
    SET NOCOUNT ON;
    --  For executing the stored procedure at 11:00 P.M
    declare @ExecutionTime dateTime
    set @ExecutionTime = '23:00:00'

    while 1 = 1
    begin

        waitfor time @ExecutionTime

        begin
            --Name for the stored proceduce you want to call on regular bases
            execute [dbo].[SendEmailNotification];
        end
    end
END
GO

USE master;
GO
-- Sets ScheduleEmailsRimindersDaily to run if the system is shutdown.
sp_procoption    @ProcName = 'ScheduleEmailsRemindersDaily',
                @OptionName = 'startup',
                @OptionValue = 'on'





/* Like the procedures above the next two automate the process of emailing members when their library books are 7 days overdue  past the 14 days they have on a loan. Procedure 1 'SendEmailBookOverDue' 
selects all the emails and member numbers from the Adult table that have library books that are  7 days past due and no return date has been entered. The second procedure 'ScheduleSendEmailBookOverDue' 
schedules a loop that runs the first procedure everyday. A third procedure is also added to initiate the schedule procedure if the system is shutdown.
 It is assumed that the library's network admin has already set up the libraries email system and the Database Mail must be enabled using the Database Mail Configuration Wizard, or sp_configure. */

USE AragonMunicipalLibrary2022 ;  
GO  
-- Email all members whose books are overdue by 7 days.
 CREATE PROCEDURE SendEmailBookOverDue
 AS
BEGIN 
DECLARE @Email nvarchar(50),
        @Member_No INT;


DECLARE cursorElement CURSOR FOR
            SELECT  EmailAddress, A.Member_No
            FROM LoansAndMembers.Adult as A
		INNER JOIN LoansAndMembers.Loan as L 
				ON (A.Member_No = L.Member_No)
			WHERE   (DateDiff(day, [DateCheckedOut], convert(date, getDate())) = 21)
			and [DateReturned] is null


OPEN cursorElement
FETCH NEXT FROM cursorElement INTO @Email, @Member_No

WHILE ( @@FETCH_STATUS = 0 )
BEGIN
    EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'Aragon Libraey Administrator',  
    @recipients = @Email,  
    @body = 'Your library books are now overdue by 7 days.',  
    @subject = 'You have Library books overdue' ; 

    FETCH NEXT FROM cursorElement INTO @Email, @Member_No
END         
CLOSE cursorElement
DEALLOCATE cursorElement

END
go


-- Schedule the procedure to run everyday.
CREATE PROCEDURE ScheduleSendEmailBookOverDue
 AS
BEGIN  
    SET NOCOUNT ON;
    --  For executing the stored procedure at 11:00 P.M
    declare @ExecutionTime dateTime
    set @ExecutionTime = '23:00:00'

    while 1 = 1
    begin

        waitfor time @ExecutionTime

        begin
            --Name for the stored proceduce you want to call on regular bases
            execute [dbo].[SendEmailBookOverDue];
        end
    end
END
GO





-- Convert juvenile accounts to adult accounts when they turn 18.
 CREATE PROCEDURE pro_ConvertJuvenileAccountToAdult18
 AS
BEGIN 
DECLARE @Member_No INT,
         @CityID int,
		 @DateOfBirth date,
		@CardExpiryDate datetime;

            SELECT @CardExpiryDate = dateadd(year,1,getDate())
DECLARE cursorElement CURSOR FOR
            SELECT   J.Member_No, A.CityID, J.DateOfBirth
            FROM LoansAndMembers.Juvenile as J
		INNER JOIN LoansAndMembers.Adult as A 
				ON (J.AdultMember_No = A.Member_No)
			WHERE   (DateDiff(year, J.[DateOfBirth], convert(date, getDate())) >= 18)		
OPEN cursorElement
FETCH NEXT FROM cursorElement INTO  @Member_No, @CityID, @DateOfBirth

WHILE ( @@FETCH_STATUS = 0 )
BEGIN
insert into [LoansAndMembers].[Adult] (
	Member_No, CityID, DateOfBirth, CardExpiry)
values
(@Member_No, @CityID, @DateOfBirth, @CardExpiryDate)

;
    FETCH NEXT FROM cursorElement INTO @Member_No, @CityID
END         
CLOSE cursorElement
DEALLOCATE cursorElement

END
go

-- Schedule the procedure to run everyday.
   CREATE PROCEDURE ScheduleConvertJuvenileAccountToAdult18
 AS
BEGIN  
    SET NOCOUNT ON;
    --  For executing the stored procedure at 11:00 P.M
    declare @ExecutionTime dateTime
    set @ExecutionTime = '23:00:00'

    while 1 = 1
    begin

        waitfor time @ExecutionTime

        begin
            --Name for the stored proceduce you want to call on regular bases
            execute [dbo].[ScheduleConvertJuvenileAccountToAdult18];
        end
    end
END
GO


