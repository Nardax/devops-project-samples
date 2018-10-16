#!/bin/sh
echo "Querying for production resource groups"
groups=$(az group list --tag Environment=prod --query "[].name" --output tsv)
for name in $groups
do
	echo "rolling back tags for resource group:" $name
	az group update --name $name --tags Environment=error
done
echo "Querying for depreciated resource groups"
groups=$(az group list --tag Environment=depreciated --query "[].name" --output tsv)
for name in $groups
do
	echo "rolling back tags for resource group:" $name
	az group update --name $name --tags Environment=prod
done