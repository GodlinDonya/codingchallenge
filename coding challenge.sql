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

insert into customers values(1,'John', 'Doe', 'johndoe@example.com', '555-555-5555'),(2, 'Jane', 'Smith', 'janesmith@example.com' ,'555-123-4567'),(3, 'Robert', 'Johnson' ,'robert@example.com', '555-789-1234'),(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),(5 ,'David', 'Lee', 'david@example.com', '555-987-6543'),(6, 'Laura', 'Hall' ,'laura@example.com', '555-234-5678'),(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),(8 ,'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),(9, 'William', 'Taylor','william@example.com', '555-321-6547'),(10 ,'Olivia', 'Adams', 'olivia@example.com', '555-765-4321')insert into lease values(1, 1, 1, '2023-01-01', '2023-01-05', 'Daily'),(2,2,2, '2023-02-15', '2023-02-28','Monthly'),(3, 3, 3, '2023-03-10', '2023-03-15', 'Daily'),(4 ,4 ,4, '2023-04-20', '2023-04-30' ,'Monthly'),(5 ,5, 5, '2023-05-05', '2023-05-10', 'Daily'),(6, 4 ,3, '2023-06-15', '2023-06-30', 'Monthly'),(7,7, 7, '2023-07-01', '2023-07-10', 'Daily'),(8, 8, 8, '2023-08-12', '2023-08-15', 'Monthly'),(9, 3, 3, '2023-09-07', '2023-09-10', 'Daily'),(10 ,10, 10, '2023-10-10', '2023-10-31', 'Monthly')insert into lease values(11,2,1,'2024-02-01',getdate(),'Monthly')insert into lease values(12,2,1,'2024-11-11',getdate(),'Monthly')insert into lease values(13,3,4,'2024-11-11','2024-12-12','Monthly')insert into payments values(1, '2023-01-03', 200.00),(2 ,'2023-02-20', 1000.00),(3, '2023-03-12', 75.00),(4 ,'2023-04-25', 900.00),(5, '2023-05-07', 60.00),(6 ,'2023-06-18', 1200.00),(7 ,'2023-07-03', 40.00),(8 ,'2023-08-14', 1100.00),(9 ,'2023-09-09', 80.00),(10, '2023-10-25' ,1500.00)--1. Update the daily rate for a Mercedes car to 68.update Vehiclesset dailyRate=68where make = 'mercedes'select * from Vehicles--2. Delete a specific customer and all associated leases and payments.delete from customerswhere customerid=1--3. Rename the "paymentDate" column in the Payment table to "transactionDate".exec sp_rename 'payments.paymentdate','transactiondate','column'select * from payments--4. Find a specific customer by email.select customerid,CONCAT_WS (' ',firstname,lastname) as [Customer Name]from customerswhere email='johndoe@example.com'--5. Get active leases for a specific customer.select l.leaseid,l.startdate,l.enddate,l.leasetypefrom lease ljoin customers con l.customerid=c.customeridwhere c.customerid=4 and enddate>=getdate()--6. Find all payments made by a customer with a specific phone number.select p.paymentid,p.transactiondate,p.amountfrom payments pjoin lease lon l.leaseid=p.leaseidjoin customers con c.customerid=l.customeridwhere c.phonenumber='555-876-5432'--7. Calculate the average daily rate of all available cars.select avg(dailyrate) as [Average]from Vehicleswhere [status]=1--8. Find the car with the highest daily rate.select top 1 make,modelfrom Vehiclesorder by dailyRate desc--9. Retrieve all cars leased by a specific customerselect v.vehicleid,v.make,v.modelfrom Vehicles vjoin lease l onl.vehicleid=v.vehicleidjoin customers c onc.customerid=l.customeridwhere c.customerid=2--10. Find the details of the most recent leaseselect top 1 * from leaseorder by startdate desc--11. List all payments made in the year 2023.select * from paymentswhere year(transactiondate)='2023'--12. Retrieve customers who have not made any payments.select CONCAT_WS(' ',firstname,lastname) as [Customer Names]from customers cleft join lease lon l.customerid=c.customeridleft join payments pon p.leaseid=l.leaseidwhere p.paymentid is null--13. Retrieve Car Details and Their Total Payments.select v.vehicleid,v.make,v.model,sum(p.amount) as [total payment]from Vehicles vjoin lease lon l.vehicleid=v.vehicleidjoin payments pon p.leaseid=l.leaseidgroup by v.vehicleid,v.make,v.model--14. Calculate Total Payments for Each Customer.select c.customerid,CONCAT_WS(' ',c.firstname,c.lastname) as [Names],sum(p.amount) as [total payment]from customers cjoin lease lon l.customerid=c.customeridjoin payments pon p.leaseid=l.leaseidgroup by c.customerid,c.firstname,c.lastname--15. List Car Details for Each Lease.select v.vehicleid,v.make,v.model,l.leaseidfrom Vehicles vjoin lease lon l.vehicleid=v.vehicleid--16. Retrieve Details of Active Leases with Customer and Car Information.select c.customerid,v.vehicleid,CONCAT_ws(' ',c.firstname,c.lastname) as [name],v.make,v.modelfrom lease ljoin customers con l.customerid=c.customeridjoin Vehicles von v.vehicleid=l.vehicleidwhere enddate>=getdate()--17. Find the Customer Who Has Spent the Most on Leases.select top 1 c.customerid,c.firstname,c.lastname,sum(p.amount) as [total]from customers cjoin lease lon l.customerid=c.customeridjoin payments pon p.leaseid=l.leaseidgroup by c.customerid,c.firstname,c.lastnameorder by total desc--18. List All Cars with Their Current Lease Information.

select v.vehicleid,v.model,v.make,l.leaseid,l.startdate,l.enddate
from Vehicles v
 join lease l on
l.vehicleid=v.vehicleid
where l.enddate>=getdate()


