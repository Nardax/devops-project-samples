#!/bin/sh
tag=$1
chrlen=${#tag}
if [ $chrlen -ge 4 ]; then
    echo "Querying for resource groups tagged with:" $tag
    groups=$(az group list --tag $tag --query "[].name" --output tsv)
    for name in $groups
    do
        echo "Deleting resource group:" $name
        az group delete --name $name -y
    done
else
    echo "Please enter a tag name with 4 or more characters"
fi