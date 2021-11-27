/*

Cleaning Data in SQL Queries

*/

Select *
From [New Portfolio Project ]..[NashvilleHousing ]
  

-------------------------------------------------------------------------------

--Standardize Date Format 

Select SaleDateConverted, CONVERT(Date,SaleDate) 
From [New Portfolio Project ]..[NashvilleHousing ]


Update [New Portfolio Project ]..[NashvilleHousing ]
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
Add SaleDateConverted Date;

Update [New Portfolio Project ]..[NashvilleHousing ]
Set SaleDateConverted = CONVERT(Date,SaleDate)



-------------------------------------------------------------------------------

--Populating Property Address data

Select *
From [New Portfolio Project ]..[NashvilleHousing ]
--Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [New Portfolio Project ]..[NashvilleHousing ] as a
JOIN [New Portfolio Project ]..[NashvilleHousing ] as b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [New Portfolio Project ]..[NashvilleHousing ] as a
JOIN [New Portfolio Project ]..[NashvilleHousing ] as b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null



-------------------------------------------------------------------------------


--Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [New Portfolio Project ]..[NashvilleHousing ]
--Where PropertyAddress is null
--Order by ParcelID

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress)) as Address

From [New Portfolio Project ]..[NashvilleHousing ]


ALTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
Add PropertySplitAddress Nvarchar(255);

Update [New Portfolio Project ]..[NashvilleHousing ]
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)



ALTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
Add PropertySplitCity Nvarchar(255);

Update [New Portfolio Project ]..[NashvilleHousing ]
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, Len(PropertyAddress))


Select *
From [New Portfolio Project ]..[NashvilleHousing ]



Select OwnerAddress
From [New Portfolio Project ]..[NashvilleHousing ]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From [New Portfolio Project ]..[NashvilleHousing ]



ALTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
Add OwnerSplitAddress Nvarchar(255);

Update [New Portfolio Project ]..[NashvilleHousing ]
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



ALTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
Add OwnerSplitCity Nvarchar(255);

Update [New Portfolio Project ]..[NashvilleHousing ]
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



ALTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
Add OwnerSplitState Nvarchar(255);

Update [New Portfolio Project ]..[NashvilleHousing ]
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


Select *
From [New Portfolio Project ]..[NashvilleHousing ]


-------------------------------------------------------------------------------

--Changing Y and N to Yes and No in 'Sold As Vacant' field 

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From [New Portfolio Project ]..[NashvilleHousing ]
Group By SoldAsVacant
Order By 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No' 
	   Else SoldAsVacant
	   END
From [New Portfolio Project ]..[NashvilleHousing ]



Update [New Portfolio Project ]..[NashvilleHousing ]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
       When SoldAsVacant = 'N' THEN 'No' 
	   Else SoldAsVacant
	   END


-------------------------------------------------------------------------------

--Removing Duplicates 

WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,LegalReference
				 Order By
				   UniqueID
				   ) row_num 

From [New Portfolio Project ]..[NashvilleHousing ]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress



Select * 
From [New Portfolio Project ]..[NashvilleHousing ]


-------------------------------------------------------------------------------

--Deleting Unused Columns 

Select * 
From [New Portfolio Project ]..[NashvilleHousing ]

AlTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

AlTER TABLE [New Portfolio Project ]..[NashvilleHousing ]
DROP COLUMN SaleDate