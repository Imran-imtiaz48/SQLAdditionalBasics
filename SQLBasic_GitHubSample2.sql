--1)Select all column and all rows of a particular table in the given database
-- here we are selecting dimension.Employee table

select * from dimension.Employee

--2)Select only needed column from the above table

select Employee,[Preferred Name], [WWI Employee ID] from dimension.Employee

--3)Select using a Numeric Criterion
 select Employee,[Preferred Name], [WWI Employee ID] from dimension.Employee
 where [Employee Key]<10

--4)Select Using a String Crterion

select Employee,[Preferred Name], [WWI Employee ID] from dimension.Employee
where [Preferred Name]='Hudson'

--5)Select using AND/OR
select Employee,[Preferred Name], [WWI Employee ID] from dimension.Employee
where [Preferred Name]='Hudson' and [WWI Employee ID]=13

select Employee,[Preferred Name], [WWI Employee ID] from dimension.Employee
where [Preferred Name]='Hudson' or [WWI Employee ID]=13

--6)Sorting data using ascending and descending

select * from dimension.Employee /*By default it is ascending*/

select * from dimension.Employee
order by [WWI Employee ID] desc

select * from dimension.Employee
order by Employee,[Employee Key] desc /*Using multiple columns for descending a table*/


--7) Using user friendly ALIAS feature to give temporary alternative names to columns

select [Preferred Name] as NickName,[WWI Employee ID] as ID,[Valid To] AS Validity from dimension.Employee
order by NickName

--8) Display unique records from the table using DISTINCT Keyword
Select distinct [Employee],[WWI Employee ID]
from [Dimension].[Employee]

--9)Searching Using A wildcard for pattern searching

Select distinct [Employee],[WWI Employee ID]
from [Dimension].[Employee]
where Employee LIKE '%E' /* Selects all the employees with the ending character 'e' */

Select distinct [Employee],[WWI Employee ID]
from [Dimension].[Employee]
where Employee LIKE 'E%' /* Starting with 'E'*/


Select distinct [Employee],[WWI Employee ID]
from [Dimension].[Employee]
where Employee LIKE '_E%' /*Names with 2nd character as 'E' */



Select distinct [Employee],[WWI Employee ID]
from [Dimension].[Employee]
where Employee LIKE'[^A]%'/* Names that does not start with A*/


--10)Creating Runtime Calculated columns


select * from [Fact].[Sale]

select [WWI Invoice ID],[Quantity],([Unit Price]-5) as DiscountedRate,[Tax Rate],[Profit]
from [Fact].[Sale]


--11) Creating a Case Statement on a Column
select [WWI Invoice ID],[Quantity],([Unit Price]-5) as DiscountedRate,[Tax Rate],[Profit],
(case
when[Total Excluding Tax]> 40 and [Total Excluding Tax]<80
then 'medium profit'
when[Total Excluding Tax]> 80 and [Total Excluding Tax]<150
then 'Good profit'
else 'loss'
end) as Profit
from [Fact].[Sale]


--12) Join data from two selects using Union and Union all


select [Customer],[Valid From],[Valid To] from [Dimension].[Customer]

go /* to see  both the tables togther*/

select [Employee],[Valid From],[Valid To] from [Dimension].[Employee]

/* Joining all the columns above from the above 2 tables */

select [Customer],[Valid From],[Valid To] from [Dimension].[Customer]

union /* the datatypes and the no. of columns from both the table should be same, union doesnt display duplicate records-
       see no of rows at the bottom are 614*/

select [Employee],[Valid From],[Valid To] from [Dimension].[Employee]


/* Using Union all*/

select [Customer],[Valid From],[Valid To] from [Dimension].[Customer]

union all /* the datatypes and the no. of columns from both the table should be same,Union all shows duplicate records-
       see no of rows at the bottom are 616*/

select [Employee],[Valid From],[Valid To] from [Dimension].[Employee]




--13) INNER JOIN- Showing matching data from two columns

select * from[Fact].[Purchase]
go
select * from [Dimension].[Supplier]

select * from[Fact].[Purchase]
inner join [Dimension].[Supplier] on [Fact].[Purchase].[Supplier Key]=[Dimension].[Supplier].[Supplier Key]



--14) Left and Right joins- Shows all the record from one table and only matching records from both the tables

select * from[Fact].[Purchase]
left join [Dimension].[Supplier] on [Fact].[Purchase].[Supplier Key]=[Dimension].[Supplier].[Supplier Key]
/* 8,367 rows-selects all the rows from Purchase table and only the matching from both tables*/

select * from[Fact].[Purchase]
right join [Dimension].[Supplier] on [Fact].[Purchase].[Supplier Key]=[Dimension].[Supplier].[Supplier Key] 
/* 8,388 rows- Selects all the rows from Supplier table and matching rows from both the tables*/

select * from[Fact].[Purchase]
full outer join [Dimension].[Supplier] on [Fact].[Purchase].[Supplier Key]=[Dimension].[Supplier].[Supplier Key] 
/*8388 rows,all the unmatching records from both tables along with the matching records */ 




--16) Writing a complex SQL statments using  Inner Join to display columns from various tables


select [Customer],[Buying Group],[Quantity],[Profit],[Bill To Customer],[City],[Region]from  [Fact].[Sale]
inner join [Dimension].[Customer] on [Fact].[Sale].[Customer Key]=[Dimension].[Customer].[Customer Key]
inner join [Dimension].[City] on [Fact].[Sale].[City Key]=[Dimension].[City].[City Key]
order by Profit asc
 go
--17) Display aggregate values  from a table using Group By function

select [Buying Group],sum(Profit) as totalprofit,count(Quantity) as quantitysold from  [Fact].[Sale]
inner join [Dimension].[Customer] on [Fact].[Sale].[Customer Key]=[Dimension].[Customer].[Customer Key]
inner join [Dimension].[City] on [Fact].[Sale].[City Key]=[Dimension].[City].[City Key]
Group by [Buying Group]


--18) Using Having clause along with Group By

select [Buying Group],sum(Profit) as totalprofit,count(Quantity) as quantitysold from  [Fact].[Sale]
inner join [Dimension].[Customer] on [Fact].[Sale].[Customer Key]=[Dimension].[Customer].[Customer Key]
inner join [Dimension].[City] on [Fact].[Sale].[City Key]=[Dimension].[City].[City Key]
Group by [Buying Group]
having sum(Profit)>28000000

--19) Understanding Self Join

--Inserting data into newly created table called 'NewDimensionCustomer'
SELECT*
INTO NewDimensionCustomer /*Table is created at the same time*/
from[Dimension].[Customer]


select  top 5 * from [dbo].[NewDimensionCustomer] /*Selecting top 5 rows*/

alter table [dbo].[NewDimensionCustomer] /* adding new column Referred by' to the table*/
add Referred_By nvarchar(50)

select top 5 customer,Referred_By,[Customer Key], [WWI Customer ID]from [dbo].[NewDimensionCustomer]

update NewDimensionCustomer    /* inserting  values into empty Reffered BY column*/

set [Referred_By]= 3 where [Customer Key]=0
update NewDimensionCustomer
set [Referred_By]= 2 where [Customer Key]=5
update NewDimensionCustomer
set [Referred_By]= 4 where [Customer Key]=3
update NewDimensionCustomer
set [Referred_By]= 1 where [Customer Key]=2
update NewDimensionCustomer
set [Referred_By]= 0 where [Customer Key]=1



select top 5 customer,Referred_By,[Customer Key], [WWI Customer ID]from [dbo].[NewDimensionCustomer]




/* Creating self join in the same table to display Referred by column with Names */
go

select top 5 t1.customer as CustomerName,
       isnull(t2.customer,'walkin') as ReferenceName
	   from [dbo].[NewDimensionCustomer] as t1
	   inner join [dbo].[NewDimensionCustomer] as t2
	   on t1.Referred_By=t2.[Customer Key]

	  


--20) SUBQUERIES

select * from [Dimension].[Customer] 
where [Customer].[Customer Key] in(
select [Fact].[Order].[Customer Key]
from [Fact].[Order]
) order by [Customer Key]

go
 
select [Fact].[Order].[Customer Key],[Fact].[Order].[WWI Order ID]
from [Fact].[Order]
order by [Customer Key]

select distinct * from [Dimension].[Customer]
select distinct * from [Fact].[Order]

--The customer table above has only 403 rows starting from 1-to 402
--while order table has 231,412 rows. all the rows present in customer table with customer_key are present inside order table having same customer_key


-- Lets try another example

select * from [Fact].[Sale]
where [Fact].[Sale].[Salesperson Key]
in(
select [Fact].[Order].[Salesperson Key]
from [Fact].[Order])
order by [Salesperson Key],[Stock Item Key]

go

--fact_order has 231,412 rows while fact_sale has 228,265 rows which are all present in fact_order with same salesperson key

-- Lets cross check that a particular row existes in both tables
select * from [Fact].[Sale]
where [City Key] =103228 and [Stock Item Key]=227


select * from [Fact].[Order]
WHERE [City Key]=103228 AND [Stock Item Key]=227




--another example

select * from[dbo].[NewDimensionCustomer]
where [dbo].[NewDimensionCustomer].[Postal Code] in(    /* since only one postal code is common between two tables we only get 1 result*/
select [dbo].[NewSupplier].[Postal Code]
from [dbo].[NewSupplier]
)

select * from[dbo].[NewDimensionCustomer]
select * from [dbo].[NewSupplier]





--)Co-Related Sub Queries
--if the inner querry depends upon the outer querry for the value then it is called corelated sub querry


 
select * from [Dimension].[Stock Item]

select [WWI Stock Item ID],[Stock Item],[Unit Price] from [Dimension].[Stock Item]
order by [Unit Price] desc

select [Stock Item],[Unit Price] from [Dimension].[Stock Item] as t1
where 3=(select count(*)
from [Dimension].[Stock Item] as t2
where t2.[Unit Price]>=t1.[Unit Price])
order by [Unit Price]



select distinct t1.[WWI Stock Item ID],t1.[Stock Item],t1.[Unit Price] from [Dimension].[Stock Item] as t1
order by [Unit Price] desc


--22) Aggregate Functions -MIN,MAX,AVG,SUM


SELECT [Stock Item],[Unit Price] from [Dimension].[Stock Item]


SELECT MIN([Unit Price]) as minimum,max([Tax Rate]) as maximum,avg([Unit Price]) as average,sum([Unit Price]) as total
from [Dimension].[Stock Item]



--23) Finding between Numeric values
/*This can be done in 2 ways*/

SELECT [Stock Item],[Unit Price] from [Dimension].[Stock Item]
where [Unit Price]>=50
and [Unit Price]<=150
order by [Unit Price]


SELECT [Stock Item],[Unit Price] from [Dimension].[Stock Item]
where [Unit Price] between 50 and 150




--24) Dump table data into new table (SELECT INTO)

SELECT * 
INTO NewDimensionCity
from[Dimension].[City] /* Dumps all the data,all the columns into new table 'NewDimensionCity' from the existing table city */

--25) Getting top 2 values from the table

select * from[Dimension].[Customer]
select top 2 * from [Dimension].[Customer] /* selects top 2 rows from the table */

select top 2 * from [Dimension].[Customer]
order by [Customer Key] desc          /* selects bottom 2 rows from the table */


--26)Bulk Insert data into an empty table
/* creating an empty backup table called NewSupplier*/

select *
into NewSupplier
FROM [Dimension].[Supplier]


delete [dbo].[NewSupplier]

SELECT * FROM NewSupplier /* THIS TABLE IS NOW EXISTING FOR BULK INSERT*/



INSERT INTO [dbo].[NewSupplier]
SELECT * FROM [Dimension].[Supplier]

select * from  [dbo].[NewSupplier]








 



