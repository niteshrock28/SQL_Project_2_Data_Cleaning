
--Update Date Column/Create a new one

select * from
PortfolioProject..NashvilleHousing

select SaleDate, CONVERT(Date, SaleDate)
 from PortfolioProject..NashvilleHousing

 --update NashvilleHousing
 --set SaleDate = CONVERT(Date, SaleDate)

 alter table PortfolioProject..NashvilleHousing
 add SaleDateConverted Date;

  update PortfolioProject..NashvilleHousing
 set SaleDateConverted = CONVERT(Date, SaleDate)

 --populate property address data

 select * 
 from PortfolioProject..NashvilleHousing
 where PropertyAddress is null

 select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, ISNULL(a.propertyaddress, b.propertyaddress)
 from PortfolioProject..NashvilleHousing a
 join PortfolioProject..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  update a 
  set propertyaddress = ISNULL(a.propertyaddress, b.propertyaddress)
  from PortfolioProject..NashvilleHousing a
  join PortfolioProject..NashvilleHousing b
    on a.ParcelID = b.ParcelID
    and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null

  --Breaking out address in individual columns(address, city, state)

  select 
  SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1) as propertySplitaddress,
  substring(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress)) as propertySplitCity
  from PortfolioProject..NashvilleHousing

  ----add these 2 columns and update it

 alter table PortfolioProject..NashvilleHousing
 add propertySplitaddress nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set propertySplitaddress = SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress) -1)

 alter table PortfolioProject..NashvilleHousing
 add propertySplitCity nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set propertySplitCity = substring(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))

 select * from
PortfolioProject..NashvilleHousing

 --Splitting the string with the help of PARSENAME

 SELECT
 parsename(replace(OwnerAddress, ',', '.'), 3),
 parsename(replace(OwnerAddress, ',', '.'), 2),
 parsename(replace(OwnerAddress, ',', '.'), 1)
 from PortfolioProject..NashvilleHousing

 alter table PortfolioProject..NashvilleHousing
 add OwnerSplitaddress nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set OwnerSplitaddress = parsename(replace(OwnerAddress, ',', '.'), 3)

 alter table PortfolioProject..NashvilleHousing
 add OwnerSplitcity nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set OwnerSplitcity = parsename(replace(OwnerAddress, ',', '.'), 2)

 alter table PortfolioProject..NashvilleHousing
 add OwnerSplitstate nvarchar(255);

 update PortfolioProject..NashvilleHousing
 set OwnerSplitstate = parsename(replace(OwnerAddress, ',', '.'), 1)

  select * from
PortfolioProject..NashvilleHousing


--Change Y and N to Yes and No in SoldAsVacant column

select count((soldasvacant)), soldasvacant from
PortfolioProject..NashvilleHousing
group by soldasvacant
order by 1

select Soldasvacant,
 (case when Soldasvacant = 'Y' then 'Yes'
       when Soldasvacant = 'N' then 'No'
       else Soldasvacant
       end)
from PortfolioProject..NashvilleHousing

Update PortfolioProject..NashvilleHousing
 set Soldasvacant = case when Soldasvacant = 'Y' then 'Yes'
       when Soldasvacant = 'N' then 'No'
       else Soldasvacant
       end


--Remove Duplicates

with CTE as
(
select *,
ROW_NUMBER() over (partition by
					parcelid,
					propertyaddress,
					saleprice,
					saledate,
					legalreference
					order by Uniqueid) as row_num

from PortfolioProject..NashvilleHousing
)


delete
from CTE
where row_num > 1


--Delete Unused Columns

 select * from
PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table PortfolioProject..NashvilleHousing
drop column SaleDate
























