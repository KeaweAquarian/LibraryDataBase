/* Purpose: Creating Index Objects in the database  AragonMunicipalLibrary2022

*/


use AragonMunicipalLibrary2022
;
go 




create nonclustered index ncl_Title on BooksandLibraries.Title (Title)
;
go

create nonclustered index ncl_Category on BooksandLibraries.Category (CategoryName)
;
go




create nonclustered index ncl_Author on BooksandLibraries.Author (L_Name)
;
go

create nonclustered index ncl_MemberLastName on LoansAndMembers.Member (L_Name)
;
go

;
go

create nonclustered index ncl_PublishingHouse on BooksandLibraries.PublishingHouse (PublishingHouseName)
;
go

