/* Purpose: Creating User Defined Triggers in the database AragonMunicipalLibrary2022
*/



use AragonMunicipalLibrary2022
;
Go


/* Check that only y or n can be marked for OnLoan and LoanAble*/
CREATE trigger trg_CheckYAndNValues
on [BooksAndLibraries].[Copy]
for insert, update
as
	begin
		
		declare @Loanable as char(1),
				@OnLoan as char(1)
		

		select @Loanable = i.LoanAble from inserted i;
			select @OnLoan = i.OnLoan from inserted i;
		
		

		if(@Loanable not in ('y', 'n') or @OnLoan not in ('y', 'n'))
			begin
				raiserror('Loanable and onLoan fields may only contain y or n values', 16, 10);
				ROLLBACK TRANSACTION;
				RETURN;
			end
	end
;
go

/* Test Value */
insert into [BooksAndLibraries].[Copy] (
	[ISBN],[CopyID] , [LibraryID], [OnLoan], [LoanAble])
values
(500,8, 'Ara01', 'r', 'y' )

;
go



--A trigger to check if a book has been correctly marked as returned when a new attempt to check out it made.


CREATE TRIGGER trig_BookIncorrectlyReturned  
ON [LoansAndMembers].[Loan]
AFTER INSERT, UPDATE 
AS
BEGIN
     	declare @CopyID as int,
		        @OnLoan as char(1),
				@ISBN as int;
				
	select @CopyID = i.CopyID from inserted i;
	select @ISBN = i.ISBN from inserted i;
	select @OnLoan = c.OnLoan from [BooksAndLibraries].[Copy] c
     WHERE CopyID = @CopyID
	 and ISBN = @ISBN

    IF  (@OnLoan = 'y' )
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('This book has not been correctly returned', 16, 1)
    END
END
GO

/*Test value for trig_ItemIncorrectlyReturned passed correctly.*/

insert into [LoansAndMembers].[Loan] (
	 [ISBN], [CopyID], [Member_No], [DateCheckedOut], [DateReturned] )
values
( 500,3,10, GETDATE(), NULL )
;
go

-- Members can only reserve 4 books max at a time.
CREATE TRIGGER trg_limit_reserve4
ON [LoansAndMembers].[Reservation]
AFTER INSERT, UPDATE 
AS
BEGIN
     	declare @ReservationCount as int,
		        @Member_No   as int;
				
    SELECT @Member_No = i.Member_No from inserted i;
	SELECT @ReservationCount = SUM(Member_No) FROM [LoansAndMembers].[Reservation]
where Member_No = @Member_No
and [DateFulfilled] is NULL;

	    IF  (@ReservationCount >= 4*@Member_No )
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Reservation limit exceeded', 16, 1)
    END
END
GO



-- Members can only borrow 4 books max at a time.
CREATE TRIGGER trg_limit_loan4
ON [LoansAndMembers].loan
AFTER INSERT, UPDATE 
AS
BEGIN
     	declare @LoanCount as int,
		        @Member_No   as int;
				
				
    SELECT @Member_No = i.Member_No from inserted i;
	SELECT @LoanCount =  SUM(Member_No) FROM [LoansAndMembers].[Loan]
where Member_No = @Member_No
and DateReturned is NULL;

	    IF  (@LoanCount >= 4*@Member_No )
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Checkout limit exceeded', 16, 1)
    END
END
GO


-- Members can only reserve the same book once. 
CREATE TRIGGER [LoansAndMembers].trg_CanOnlyReserveBookOnce
ON [LoansAndMembers].[Reservation]
AFTER INSERT, UPDATE 
AS
BEGIN
     	declare @ISBN as int;
		  declare @ReservationCountSame as int;
		    declare @Member_No as int,
				@ISBN2 as int;
		SELECT @ISBN = i.ISBN from inserted i;
	    SELECT @Member_No = i.Member_No from inserted i;
    SELECT @ISBN2 = R.ISBN from [LoansAndMembers].[Reservation] as R
	  select @ReservationCountSame = SUM(ISBN) FROM [LoansAndMembers].[Reservation]
      where ISBN = @ISBN
	  and Member_No = @Member_No
	  and DateFulfilled is not null

	    IF  (@ReservationCountSame > @ISBN )
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('You have already reserved this book.', 16, 1)
    END
END
GO



--A trigger to check if a book is loanable upon checkout.
CREATE TRIGGER trig_ItemIsNotLoanable  
ON [LoansAndMembers].[Loan]
AFTER INSERT, UPDATE 
AS
BEGIN

		declare @CopyID as int,
		        @ISBN as int,
		        @LoanAble as char(1);
			
	select @CopyID = i.CopyID from inserted i;	
	select @ISBN = i.ISBN from inserted i;
	select @LoanAble = c.LoanAble from [BooksAndLibraries].[Copy] c 
	where CopyID = @CopyID
    	and ISBN = @ISBN;

    IF ( @LoanAble = 'n')
    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('This book is not loanable, check condition.', 16, 1)
    END
END
GO

/*Test value for trig_ItemIncorrectlyReturned passed correctly.*/

insert into [LoansAndMembers].[Loan] (
	 [ISBN], [CopyID], [Member_No], [DateCheckedOut], [DateReturned] )
values
( 508, 2,8, '2022-06-14 11:30:00', NULL )
;
go

/*Trigger to check if the adult's account associated with a juvenile is valid or expired. */

CREATE TRIGGER trg_CheckAdultAccount
ON [LoansAndMembers].[Loan]
AFTER insert, UPDATE   
AS   
BEGIN
      declare @Member_No as int,
			  @AdultMember_No as int,
			  @CardExpiry Datetime;
	  select @Member_No = i.Member_No from inserted i;
	  select @AdultMember_No = j.[AdultMember_No] from [LoansAndMembers].[Juvenile] as j
	  where Member_No =  @Member_No ;
	  Select @CardExpiry = a.[CardExpiry] from [LoansAndMembers].[Adult] as a
	  where Member_No =@AdultMember_No;

IF  ( @CardExpiry < getDate() )  

    BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Associated adult card has expired', 16, 1)
    END
END
GO

-- Test the trigger. 
-- Create expired adult account
update [LoansAndMembers].[Adult]
set  CardExpiry = '2022-01-01 12:35:29' 
Where [Member_No] = 1
;
go
-- test associated juvenile account
insert into [LoansAndMembers].[Loan] (
	 [ISBN], [CopyID], [Member_No], [DateCheckedOut], [DateReturned] )
values
( 505,1,11, GETDATE(), NULL )
;
go


/* Trigger to notify librarians when a returned book is on the reserved list and what the member_No is of the person that has been waiting longest.*/
CREATE TRIGGER trg_NotifyLibrarianBookIsReserved  
ON [LoansAndMembers].[Loan] 
AFTER UPDATE   
AS   
BEGIN
      declare @DateReturned as datetime,
	          @DateFulfilled as datetime,
			  @DateRequested as datetime,
	          @CopyID as int,
			  @CopyID2 as int,
			  @ISBN as int;
	  select @DateReturned = i.DateReturned from inserted i;
	  select @CopyID = i.CopyID from inserted i;
	  select @ISBN = i.ISBN from inserted i;
	  select @DateFulfilled = r.[DateFulfilled] from [LoansAndMembers].[Reservation] as r
	  where ISBN = @ISBN ;
	  select @DateRequested = r.[DateRequested] from [LoansAndMembers].[Reservation] as r
	  where ISBN = @ISBN ;

      IF ( @DateReturned  is not null
        and @DateFulfilled is null)  
	    BEGIN
		declare @MemberName as VARCHAR(60),
		        @MinDate as date;
       select @MinDate = MIN (@DateRequested) 
        FROM [LoansAndMembers].[Reservation]
		where ISBN = @ISBN ;
	   select @MemberName  = [Member_No]
        FROM [LoansAndMembers].[Reservation]
		where ISBN = @ISBN
		and [DateRequested] = @MinDate ;
        RAISERROR ('Book is on requested list. Notify client member %s' , 16, 1, @MemberName)

	END
END
;  
GO 

-- Test trg_NotifyLibrarianBookIsReserved.  
UPDATE [LoansAndMembers].[Loan]
SET [DateReturned] = getDate()
WHERE ISBN = 505 and CopyID = 1;  
GO 

