#!/bin/sh
echo "Querying for production resource groups"
groups=$(az group list --tag Environment=prod --query "[].name" --output tsv)
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
	az group update --name $name --tags Environment=prod
done