
------------------------------------SQL QUERIES I USED TO CLEAN THE HOUSING DATA--------------------------------

--------------------------------------------------------------------------------------------------------------------------
--LOOKING AT THE DATASET

Select *
From Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------

-- THE DATE FORMAT WAS INCONSISTENT SO I DECIDED TO STANDARDIZE THE DATE FORMAT


Select saleDate, CONVERT(Date,SaleDate)
From Nashville_Housing


Update Nashville_Housing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE Nashville_Housing
Add SaleDateConverted Date;

Update Nashville_Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- I DECIDED TO POPULATE THE PROPERTY ADDRESS DATA TO MAKE SURE I WAS NOT MISSING ANY VALUES 

Select *
From Nashville_Housing
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing a
JOIN Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Nashville_Housing a
JOIN Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------


-- THE ADDRESS COLUMN WAS CROWDED AND DIFFICULT TO READ SO I BROKE IT DOWN INTO INDIVIDUAL COLUMNS (Address, City, State)


Select PropertyAddress
From Nashville_Housing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Nashville_Housing


ALTER TABLE Nashville_Housing
Add PropertY_Address Nvarchar(255);

Update Nashville_Housing
SET Property_Address = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Nashville_Housing
Add Property_City Nvarchar(255);

Update Nashville_Housing
SET Property_City = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Nashville_Housing



-----ALTERNATE WAY TO BREAK A COLUMN INTO SEPARATE COLUMNS

Select OwnerAddress
From Nashville_Housing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Nashville_Housing



ALTER TABLE Nashville_Housing
Add Owner_Address Nvarchar(255);

Update Nashville_Housing
SET Owner_Address = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Nashville_Housing
Add Owner_City Nvarchar(255);

Update Nashville_Housing
SET Owner_City = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Nashville_Housing
Add Owner_State Nvarchar(255);

Update Nashville_Housing
SET Owner_State = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Nashville_Housing




--------------------------------------------------------------------------------------------------------------------------


-- CHANGING "Y" and "N" to ""Yes" and "No" in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Nashville_Housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Nashville_Housing


Update Nashville_Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- REMOVING DUPLICATES FROM THE DATASET

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Nashville_Housing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Nashville_Housing



---------------------------------------------------------------------------------------------------------

-- DELETING UNUSED COLUMNS

Select *
From Nashville_Housing


ALTER TABLE Nashville_Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
