#!/bin/sh
name=$1
tag=$2
chrlen=${#tag}
if [ $chrlen -ge 4 ]; then
    echo "Updating tags for resource group:" $name
    az group update --name $name --tags $tag
else
    echo "Please enter a tag name with 4 or more characters"
fi