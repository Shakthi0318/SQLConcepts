use training


with CTE_delete_duplicate
as
(
select *, ROW_NUMBER() over (partition by 
city order by cityName desc) as rowNumber from city_countries)
delete from CTE_delete_duplicate where rowNumber >1

select * from employess

select max(salary) as maxi from employess
select empName from employess where salary = (select
max(salary) as maxi from employess)

select empName, salary from employess where salary > (
select AVG(salary) from employess)


create table #Orders(
orderID int, 
orderName varchar(100),
shipmentStatus varchar(100),
arrival_date date)

insert into #Orders values
(101,'Shoes','Shipped', '2026-02-20')

insert into #Orders values
(102,'Shirts','OFD', '2026-02-26')
insert into #Orders values
(103,'Appli','Packing', '2026-02-25')

insert into #Orders values
(104,'psnts','Shipped', '2026-02-27')

select * from #Orders


select * from employess

Select * ,
Case 
when salary > 200 and salary < 210 then 'salary is less'
when salary > 10000 and salary <=5000 then 'salary is avag'
when salary > 3000 and salary < = 2000 then 'salary is ok'
else 'salary is ok ok'
end as Salary_status from employess


declare @id int
set @id=25
select @id as value_status

declare @id int
set @id=25
Print @id

declare @id int
set @id=10
select @id
print @id

declare @name varchar(100)
set @name = 'MAya'
select @name

declare @salary money
print @salary
set @salary

Alter procedure new_procedure
as
Begin
select empName, empDepart,city from employess
end

new_procedure

new_procedure

Alter procedure cityName
as
Begin
select * from employess where city ='BLR'
end

cityName

create table signals(
id int, name varchar(100), description varchar(100)
)

select * from signals

create procedure procedure_insert_values
as
begin
	insert into signals values(101, 'Red','stop')
	insert into signals values(102, 'Green','Go')
	insert into signals values(102, 'Yellow','ready')
end

procedure_insert_values

create procedure procedure_for_variables
@city varchar (100)
as 
begin
select * from employess where city = @city
end

procedure_for_variables 'BLR'


Alter function function_greet
(@Username varchar(100))
returns varchar(100)
begin
	return 'welcome boys...'+@Username
end

function_greet 'shakthi'

select dbo.function_greet('Shakthi')

create function function_hike(@hike money)
returns money
begin
	declare @bonus money
	set @bonus = @hike * 0.1
	return @bonus
end

select dbo.function_hike(salary)

select *
, dbo.function_hike(salary) 
as newUpdate from employess


--Transaction
create table books_details(
bookID int,
bookName varchar(100),
bookType varchar(100),
price money )

begin transaction -- starting the process or operation
insert into books_details values 
(101,'Maths', 'internal user',500)

insert into books_details values 
(102,'Drawing', 'internal user',400)

insert into books_details values 
(103,'SS', 'Extre user',300)

commit transaction -- complete the process



begin transaction -- starting the process or operation
insert into books_details values 
(104,'Qunta', 'internal user',500)

insert into books_details values 
(105,'Algo', 'internal user',400)

Rollback transaction -- complete the process


select * from books_details


create table Home_appliances
(
id int primary key,
name varchar(100),
type varchar(100),
price money )

select * from Home_appliances

insert into Home_appliances values
(101, 'TV', 'Electo', 200)
insert into Home_appliances values
(102, 'Washing machine', 'Grind', 400)
insert into Home_appliances values
(103, 'Fans', 'HomeApp', 500)
insert into Home_appliances values
(104, 'Bulb', 'Wire', 100)
insert into Home_appliances values
(104, 'Chair', 'Furin', 1000)

delete from Home_appliances

begin try
	begin transaction
	insert into Home_appliances values
		(101, 'TV', 'Electo', 200)
	insert into Home_appliances values
		(102, 'Washing machine', 'Grind', 400)
	insert into Home_appliances values
		(103, 'Fans', 'HomeApp', 500)
	insert into Home_appliances values
		(104, 'Bulb', 'Wire', 100)
	insert into Home_appliances values
		(104, 'Chair', 'Furin', 1000)
	commit transaction
end try

begin catch
		rollback transaction 
end catch