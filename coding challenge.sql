create database CarRental
use carrental
create table Vehicles(
vehicleid int primary key,
make varchar(50),
model varchar(50),
[year] int,
dailyRate decimal,
[status] int,
passengercapacity int,
enginecapacity int)

alter table vehicles
alter column [status] bit

create table customers(
customerid int primary key,
firstname varchar(50),
lastname varchar(50),
email varchar(50) unique,
phonenumber varchar(50)
)

create table lease(
leaseid int primary key,
vehicleid int foreign key references vehicles(vehicleid),
customerid int foreign key references customers(customerid),
startdate date,
enddate date,
leasetype varchar(50)
)

create table payments(
paymentid int identity primary key,
leaseid int,
paymentdate date,
amount decimal
)
insert into vehicles values (1,'Toyota','camry',2022,50.00,1,4,1450),(2,'Honda','Civic',2023,45.00,1,7,1500),
(3,'ford','focus',2022,48.00,0,4,1400),(4,'nisan','altima',2023,52.00,1,7,1200),
(5,'chevrolet','malibu',2022,47.00,1,4,1800),(6,'hyundai','sonata',2023,49.00,0,7,1400),
(7,'BMW','3 series',2023,60.00,1,7,2499),(8,'mercedes','c class',2022,58.00,1,8,2599),
(9,'audi','a4',2022,55.00,0,4,2500),(10,'lexus','Es',2023,54.00,1,4,2500)

insert into customers values(1,'John', 'Doe', 'johndoe@example.com', '555-555-5555'),

select v.vehicleid,v.model,v.make,l.leaseid,l.startdate,l.enddate
from Vehicles v
 join lease l on
l.vehicleid=v.vehicleid
where l.enddate>=getdate()

