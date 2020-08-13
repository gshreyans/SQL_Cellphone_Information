use db_SQLCaseStudies

--Q1

select Distinct 
[State] 
from 
FACT_TRANSACTIONS T1
left join
DIM_LOCATION T2
on 
T1.IDLocation=T2.IDLocation
where 
year(convert(date,Date,105))>=2005

--Q2

select Top 1 State,
count(State) 
as 
[Count] 
from 
FACT_TRANSACTIONS T1
left join
DIM_LOCATION T2
on 
T1.IDLocation=T2.IDLocation
left join
DIM_MODEL T3
on 
T1.IDModel=T3.IDmodel 
left join
DIM_MANUFACTURER T4
on 
T4.IDManufacturer=T3.IDManufacturer
where
Manufacturer_Name='Samsung' 
and 
Country='US'
group by
State
order by
[Count]
desc

--Q3

select State,
ZipCode,Model_Name,
count(*) 
as 
[No of Transactions] 
from 
FACT_TRANSACTIONS T1
left join
DIM_LOCATION T2
on 
T1.IDlocation=T2.IDlocation
left join
DIM_MODEL T3
on 
T3.IDModel=T1.IDModel
group by
State,ZipCode,Model_Name
order by
[No of Transactions]
desc


--Q4

select Top 1 IDModel,
Model_Name 
from 
DIM_MODEL
order by
Unit_price

--Q5

select Manufacturer_Name,T1.IDModel,
avg(TotalPrice) 
as 
[Avg]
from 
FACT_TRANSACTIONS T1
left join
DIM_LOCATION T2
on 
T1.IDLocation=T2.IDLocation
left join
DIM_MODEL T3
on 
T1.IDModel=T3.IDmodel 
left join
DIM_MANUFACTURER T4
on 
T4.IDManufacturer=T3.IDManufacturer
where 
Manufacturer_Name 
in 
(select top 5 Manufacturer_Name
from 
FACT_TRANSACTIONS T1
left join
DIM_LOCATION T2
on 
T1.IDLocation=T2.IDLocation
left join
DIM_MODEL T3
on 
T1.IDModel=T3.IDmodel 
left join
DIM_MANUFACTURER T4
on 
T4.IDManufacturer=T3.IDManufacturer
group by
Manufacturer_Name
order by
Sum(Quantity)
desc
)
group by
Manufacturer_Name,T1.IDModel
order by
[Avg]

--Q6

select Customer_Name,
avg(TotalPrice) 
as 
[Average Price] 
from 
FACT_TRANSACTIONS T1
left join
DIM_CUSTOMER T2
on 
T1.IDCustomer=T2.IDCustomer
where
year(convert(date,Date,105))='2009'
group by
Customer_Name
having
avg(TotalPrice)>500

--Q7

select TT1.IDModel,
'2008' 
as 
[Year],
TT1.QTY,
'2009' 
as 
[Year],
TT2.QTY,
'2010' 
as 
[Year],
TT3.QTY 
from (
select Top 5 IDmodel,
sum(Quantity) 
as 
[QTY] 
from 
FACT_TRANSACTIONS
where 
year(convert(date,Date,105))='2008'
group by
IDModel
order by
QTY
desc
)
TT1
inner join
(
select Top 5 IDmodel,
sum(Quantity) 
as 
[QTY] 
from 
FACT_TRANSACTIONS
where 
year(convert(date,Date,105))='2009'
group by
IDModel
order by
QTY
desc
)
TT2
on 
TT1.IDModel=TT2.IDModel
inner join
(
select Top 5 IDmodel,
sum(Quantity) 
as 
[QTY] 
from 
FACT_TRANSACTIONS
where 
year(convert(date,Date,105))='2010'
group by
IDModel
order by
QTY
desc
)
TT3
on 
TT2.IDModel=TT3.IDModel

--Q8

select * from 
(
select Top 1 * from
(
select  top 2 *,'2009'
as 
[Year] 
from 
(
select  Manufacturer_Name,
sum(TotalPrice) 
as
[Sales]
from 
FACT_TRANSACTIONS T1
left join
DIM_MODEL T2
on 
T1.IDModel =T2.IDModel
left join
DIM_MANUFACTURER T3
on
T2.IDManufacturer=T3.IDManufacturer
where
year(convert(date,Date,105))='2009'
group by
Manufacturer_Name
) 
TT
order by
Sales
desc
) 
TT2
order by
Sales
) 
TT4
union all
select * 
from 
(
select Top 1 * 
from 
(
select  top 2 *,'2010'
as 
[Year] 
from 
(
select  Manufacturer_Name,
sum(TotalPrice) 
as
[Sales]
from 
FACT_TRANSACTIONS T1
left join
DIM_MODEL T2
on 
T1.IDModel =T2.IDModel
left join
DIM_MANUFACTURER T3
on 
T2.IDManufacturer=T3.IDManufacturer
where
year(convert(date,Date,105))='2010'
group by
Manufacturer_Name
) 
TT
order by
Sales
desc
) 
TT2
order by
Sales
) 
TT5


--Q9

select * from 
(
select distinct Manufacturer_Name 
from 
FACT_TRANSACTIONS T1
left join
DIM_MODEL T2
on 
T1.IDModel =T2.IDModel
left join
DIM_MANUFACTURER T3
on 
T2.IDManufacturer=T3.IDManufacturer
where
year(convert(date,Date,105))='2010'
) 
TT
except 
select distinct Manufacturer_Name 
from 
FACT_TRANSACTIONS T1
left join
DIM_MODEL T2
on 
T1.IDModel =T2.IDModel
left join
DIM_MANUFACTURER T3
on 
T2.IDManufacturer=T3.IDManufacturer
where
year(convert(date,Date,105))='2009'

--Q10

select TT1.*,
TT2.*,
((tt2.Avg_Sales-tt1.Avg_Sales)/tt1.Avg_Sales)*100 as [%Change],
TT3.*, 
((tt3.Avg_Sales-tt2.Avg_Sales)/tt2.Avg_Sales)*100 as [%Change],
TT4.*,
((tt4.Avg_Sales-tt3.Avg_Sales)/tt3.Avg_Sales)*100 as [%Change],
TT5.*,
((tt5.Avg_Sales-tt4.Avg_Sales)/tt4.Avg_Sales)*100 as [%Change],
TT6.*,
((tt6.Avg_Sales-tt5.Avg_Sales)/tt5.Avg_Sales)*100 as [%Change],
TT7.*,
((tt7.Avg_Sales-tt6.Avg_Sales)/tt6.Avg_Sales)*100 as [%Change],
TT8.*,
((tt8.Avg_Sales-tt7.Avg_Sales)/tt7.Avg_Sales)*100 as [%Change]
from (
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2003' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2003'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT1
full join 
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2004' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2004'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT2 
on TT1.Customer_Name=TT2.Customer_Name
full join
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2005' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2005'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT3
on TT2.Customer_Name=TT3.Customer_Name
full join
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2006' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2006'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT4
on TT3.Customer_Name=TT4.Customer_Name
full join
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty], '2007' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2007'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT5
on TT4.Customer_Name=TT5.Customer_Name
full join
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2008' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2008'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT6
on TT5.Customer_Name=TT6.Customer_Name
full join
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2009' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2009'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT7
on TT6.Customer_Name=TT7.Customer_Name
full Join
(
select Top 10 Customer_Name, avg(TotalPrice) as [Avg_Sales],avg(Quantity) as [Avg_Qty],'2010' as [Year] 
from FACT_TRANSACTIONS T1
left join 
DIM_CUSTOMER T2
on 
T1.IDCustomer =T2.IDCustomer
where year(convert(date,Date,105))='2010'
group by
Customer_Name
order by
sum(TotalPrice)
desc
) 
TT8
on TT7.Customer_Name=TT8.Customer_Name

