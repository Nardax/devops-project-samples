#!/bin/sh
# Delete old deprecated resource groups before setting current prod to deprecated.
./delete-groups-by-tag.sh Environment=deprecated
echo "Querying for production resource groups."
groups=$(az group list --tag Environment=production --query "[].name" --output tsv)
for name in $groups
do
	./update-group-tag-by-name.sh $name Environment=deprecated
done
echo "Querying for pre-production resource groups."
groups=$(az group list --tag Environment=pre-production --query "[].name" --output tsv)
for name in $groups
do
	./update-group-tag-by-name.sh $name Environment=production
done
# Output production group list to file.
mkdir -p logs/
destdir=logs/promotion-list
echo "Saving list of updated resource groups to logs/promotion-list"
echo "$groups" > "$destdir"