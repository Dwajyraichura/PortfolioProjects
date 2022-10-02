-- 1
--Number of unicorn companies 

Select count(*) as Num_Of_Unicorn_Company
From UnicornCompany

--2
--Total number unicorns per country

Select Country,count(*) as Total_Number_Unicorns
From UnicornCompany
Group by Country
Order by 2 desc

--3
--Top_10_StartUp_Destinations

Select Top 10 City, count(*) Top_10_StartUp_Destinations
From UnicornCompany
Group by City
Order by 2 desc

--4
--Count of StartUps per year

Select Year_Founded,count(*) as No_Of_StartUps_Per_Year
From UnicornCompany
Group by Year_Founded
Order by 2 

--5
--Top 5 StartUps Industries

Select Top 5 Industry,count(*) as Top_5_Unicorn_Industries
from UnicornCompany
Group by Industry
Order by 2 desc
