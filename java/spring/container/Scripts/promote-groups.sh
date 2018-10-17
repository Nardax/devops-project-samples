#!/bin/sh
./delete-groups-by-tag.sh Environment=deprecated
echo "Querying for production resource groups."
groups=$(az group list --tag Environment=production --query "[].name" --output tsv)
for name in $groups
do
	echo "Updating tags for resource group:" $name
	az group update --name $name --tags Environment=deprecated
done
echo "Querying for pre production resource groups."
groups=$(az group list --tag Environment=pre-production --query "[].name" --output tsv)
for name in $groups
do
	echo "Updating tags for resource group:" $name
	az group update --name $name --tags Environment=production
done