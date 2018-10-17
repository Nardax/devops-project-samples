#!/bin/sh
echo "Querying for production resource groups"
groups=$(az group list --tag Environment=production --query "[].name" --output tsv)
for name in $groups
do
	echo "Rolling back tags for resource group:" $name
	az group update --name $name --tags Environment=error
done
echo "Querying for deprecated resource groups"
groups=$(az group list --tag Environment=deprecated --query "[].name" --output tsv)
for name in $groups
do
	echo "Rolling back tags for resource group:" $name
	az group update --name $name --tags Environment=production
done