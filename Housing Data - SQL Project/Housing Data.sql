-- Cleaning data in sqlqueries--------------------------------------------------------------------

SELECT *
FROM [Portfolio Project].dbo.HousingData

--- Standardizing date format-------------------------------------------------------------------------

SELECT SaleDate, CONVERT(Date, SaleDate)
FROM [Portfolio Project].dbo.HousingData

--UPDATE HousingData
--SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE HousingData
Add SaleConvertedDate Date;

UPDATE HousingData
SET SaleConvertedDate = CONVERT(Date, SaleDate)


--- Populating property address data-----------------------------------------------------------

SELECT *
FROM [Portfolio Project].dbo.HousingData
--where propertyAddress is NULL
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
FROM [Portfolio Project].dbo.HousingData a
JOIN [Portfolio Project].dbo.HousingData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET a.propertyAddress = ISNULL(a.propertyAddress, b.propertyAddress)
FROM [Portfolio Project].dbo.HousingData a
JOIN [Portfolio Project].dbo.HousingData b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


---- Breaking the address into different columns of (Address, ciy, state)-------------------------

-----Property Address-----------------------------------------------------------

SELECT
SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress) -1) as Address,
SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(propertyAddress)) as Address
FROM [Portfolio Project].dbo.HousingData

ALTER TABLE housingData
ADD propertySplitAddress nvarchar(255);

UPDATE HousingData
SET propertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', propertyAddress) -1)

ALTER TABLE HousingData
ADD propertySplitCity nvarchar(255);

UPDATE HousingData
SET propertySplitCity = SUBSTRING(propertyAddress, CHARINDEX(',', propertyAddress) +1, LEN(propertyAddress))

SELECT * 
FROM [Portfolio Project].dbo.HousingData


------ Owner address ------------------------------------------------------------------------------------

SELECT ownerAddress
FROM [Portfolio Project].dbo.HousingData

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',','.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM [Portfolio Project].dbo.HousingData

ALTER TABLE HousingData
ADD OwnerSplitAddress nvarchar(255);

UPDATE HousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(ownerAddress, ',', '.'), 3)

ALTER TABLE HousingData
ADD OwnerSplitCity nvarchar(255);

UPDATE HousingData
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE HousingData
ADD OwnerSplitState nvarchar(255);

UPDATE HousingData
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

SELECT *
FROM [Portfolio Project].dbo.HousingData


----- Change Y and N to yes and no in sold as vacant field----------------------------------------------------

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project].dbo.HousingData
Group by SoldAsVacant
order by 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
FROM [Portfolio Project].dbo.HousingData

UPDATE HousingData
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


------ Removing Duplicates-----------------------------------------------------------------------

WITH ROWNUMCTE AS
(
SELECT *, 
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY
				        UniqueID
						) row_num
FROM [Portfolio Project].dbo.HousingData
--ORDER BY ParcelID
)

DELETE
FROM ROWNUMCTE
WHERE ROW_NUM > 1


------ Deleting unused and redundant columns ----------------------------------------------------------


SELECT *
FROM [Portfolio Project].dbo.HousingData
ORDER BY [UniqueID ]

ALTER TABLE [Portfolio Project].dbo.HousingData
DROP COLUMN OwnerAddress, PropertyAddress, TaxDistrict, SaleDate


------------------------------------------------------------ END -----------------------------------------------------