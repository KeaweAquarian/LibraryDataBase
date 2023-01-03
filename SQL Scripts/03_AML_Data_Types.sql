/* Purpose: Creating User-Defined Data Types in the database AragonMunicipalLibrary2022

*/


use AragonMunicipalLibrary2022
;
go 

/*create user defined data types*/

/* create Synopsis type */

create type Synopsis 
from nvarchar(800) not null
;
go


/* create Province data type */
create type ProvinceCode
from nchar(2) not null
;
go

/* create Phone Number data type */
create type PhoneNo
from nchar(12) not null
;
go

