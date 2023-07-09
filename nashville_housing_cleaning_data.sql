/*
cleaning data in sql
*/

-- populate property address data
/*
from the query below we can find out for the same parcel ID, they have the same property address
so parcel ID and property address are linked.
*/

-- set empty value to null

Update nashville_housing.nashville_housing_data
set PropertyAddress =  null
where PropertyAddress = '';


SELECT * FROM nashville_housing.nashville_housing_data
order by ParcelID;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
FROM nashville_housing.nashville_housing_data a
JOIN nashville_housing.nashville_housing_data b
ON a.ParcelID = b.ParcelID
and a.UniqueID != b.UniqueID
WHERE a.PropertyAddress is null;

Update a
set PropertyAddress = ifnull(a.PropertyAddress, b.PropertyAddress)
FROM nashville_housing.nashville_housing_data a
JOIN nashville_housing.nashville_housing_data b
ON a.ParcelID = b.ParcelID
and a.UniqueID != b.UniqueID
WHERE a.PropertyAddress is null;

-- breaking out property address
SELECT SUBSTRING_INDEX(PropertyAddress,',',1)
FROM nashville_housing.nashville_housing_data;

ALTER TABLE nashville_housing.nashville_housing_data
ADD Address varchar(255) NULL
AFTER PropertyAddress;

UPDATE nashville_housing.nashville_housing_data
SET Address = SUBSTRING_INDEX(PropertyAddress,',',1);

ALTER TABLE nashville_housing.nashville_housing_data
ADD PropertyAddressCity varchar(255) NULL
AFTER PropertyAddress;

UPDATE nashville_housing.nashville_housing_data
SET PropertyAddressCity = SUBSTRING_INDEX(PropertyAddress,',',-1);

-- split owner address
SELECT
SUBSTRING_INDEX(OwnerAddress,',',1) AS OwnerAddressSplitAddress,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',-2), ',', 1) AS OwnerAddressSplitCity,
SUBSTRING_INDEX(OwnerAddress,',',-1) AS OwnerAddressSplitProvince
FROM nashville_housing.nashville_housing_data;

ALTER TABLE nashville_housing.nashville_housing_data
Add OwnerSplitAddress varchar(255);

UPDATE nashville_housing.nashville_housing_data
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress,',',1);

ALTER TABLE nashville_housing.nashville_housing_data
Add OwnerSplitCity varchar(255);

UPDATE nashville_housing.nashville_housing_data
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress,',',-2), ',', 1);

ALTER TABLE nashville_housing.nashville_housing_data
Add OwnerSplitProvince varchar(255);

UPDATE nashville_housing.nashville_housing_data
SET OwnerSplitProvince = SUBSTRING_INDEX(OwnerAddress,',',-1);

-- Change Y and N to Yes and No in "sold or vacant" field


Select Distinct(SoldAsVacant)
From nashville_housing.nashville_housing_data;

UPDATE nashville_housing.nashville_housing_data
SET SoldAsVacant = "Yes"
Where SoldAsVacant = "Y";

UPDATE nashville_housing.nashville_housing_data
SET SoldAsVacant = "No"
Where SoldAsVacant = "N";

-- remove duplicate

WITH RowNumCTE AS (
Select *, 
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
                 SalePrice,
                 LegalReference
                 ORDER BY
					UniqueID
                    ) row_num
From nashville_housing.nashville_housing_data

)
DELETE
From RowNumCTE
Where row_num >1;
-- order by PropertyAddress


-- delete unused columns

select *
From nashville_housing.nashville_housing_data;


ALTER TABLE nashville_housing.nashville_housing_data
	DROP COLUMN OwnerAddress, 
	DROP COLUMN TaxDistrict,
    DROP COLUMN Propertyaddress;










