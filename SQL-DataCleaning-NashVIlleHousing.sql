
--Data cleaning in SQL

Select *
From Nashvillehosingdata

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardzing date format

SELECT SaleDate, CONVERT(DATE,SaleDate)
FROM Nashvillehosingdata

UPDATE Nashvillehosingdata
SET SaleDate = CONVERT(DATE,SaleDate)

ALTER TABLE Nashvillehosingdata
ADD SaleDate1 DATE

UPDATE Nashvillehosingdata
SET SaleDate1 = CONVERT(DATE,SaleDate)

SELECT SaleDate1
FROM Nashvillehosingdata

----------------------------------------------------------------------------------------------------------------------------------------------------

--Populate property address data

SELECT *
FROM Nashvillehosingdata
WHERE PropertyAddress is null
ORDER BY ParcelID

SELECT A.ParcelID,A.PropertyAddress,B.ParcelID,B.PropertyAddress, ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM Nashvillehosingdata A
JOIN Nashvillehosingdata B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress,B.PropertyAddress)
FROM Nashvillehosingdata A
JOIN Nashvillehosingdata B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID ] <> B.[UniqueID ]
WHERE A.PropertyAddress IS NULL

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Breaking PropertyAddress and OwnersAddress as Address,City and State

select 
substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) as PropertyAddressSplit,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as PropertyCitySplit
from Nashvillehosingdata

Alter table Nashvillehosingdata
Add PropertyAddressSplit nvarchar(255)

Alter table Nashvillehosingdata
Add PropertyCitySplit nvarchar(255)

Update Nashvillehosingdata
Set PropertyAddressSplit = substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) 

Update Nashvillehosingdata
Set PropertyCitySplit = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))


Select 
PARSENAME(Replace(OwnerAddress,',','.'),1)  OwnerStateSplit
,PARSENAME(Replace(OwnerAddress,',','.'),2) OwnerCitySplit
,PARSENAME(Replace(OwnerAddress,',','.'),3) OwnerAddressSplit 
From Nashvillehosingdata

Alter table Nashvillehosingdata
Add OwnerStateSplit nvarchar(255)

Alter table Nashvillehosingdata
Add OwnerCitySplit nvarchar(255)

Alter table Nashvillehosingdata
Add OwnerAddressSplit nvarchar(255)

Update Nashvillehosingdata
Set OwnerStateSplit = PARSENAME(Replace(OwnerAddress,',','.'),1)

Update Nashvillehosingdata
Set OwnerCitySplit = PARSENAME(Replace(OwnerAddress,',','.'),2)

Update Nashvillehosingdata
Set OwnerAddressSplit = PARSENAME(Replace(OwnerAddress,',','.'),3)

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Change 'Y' and 'N' to 'Yes' and 'No' in SoldAsVacant field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashvillehosingdata
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
       Case When SoldAsVacant = 'N' Then 'No'
	        When SoldAsVacant = 'Y' Then 'Yes'
			Else SoldAsVacant
			End
From Nashvillehosingdata

Update Nashvillehosingdata
Set SoldAsVacant = Case When SoldAsVacant = 'N' Then 'No'
	        When SoldAsVacant = 'Y' Then 'Yes'
			Else SoldAsVacant
			End
From Nashvillehosingdata

----------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicate


With RowNumCte as (
  Select *,
  ROW_NUMBER() Over (
                   Partition By
		
					ParcelId,
					LandUse,
					PropertyAddress,
					SaleDate,
					SalePrice,
					LegalReference
					Order By ParcelId
					) row_num
				
From Nashvillehosingdata
)

Select * 
From RowNumCte
Where row_num > 1


----------------------------------------------------------------------------------------------------------------------------------------------------

-- Delete unused colunm

Select *
From Nashvillehosingdata

Alter Table Nashvillehosingdata
Drop Column PropertyAddress,SaleDate,OwnerAddress,TaxDistrict

Alter Table Nashvillehosingdata
Drop Column Address,City
