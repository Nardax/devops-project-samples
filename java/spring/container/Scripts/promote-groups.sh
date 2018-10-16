#!/bin/sh
echo "Querying for production resource groups"
groups=$(az group list --tag Environment=prod --query "[].name" --output tsv)
for name in $groups
do
	echo "updating tags for resource group:" $name
	az group update --name $name --tags Environment=depreciated
done
echo "Querying for pre production resource groups"
groups=$(az group list --tag Environment=preprod --query "[].name" --output tsv)
for name in $groups
do
	echo "updating tags for resource group:" $name
	az group update --name $name --tags Environment=prod
done