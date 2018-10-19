#!/bin/bash
# Copyright (c) Microsoft Corporation. All rights reserved.
 
RESOURCE_GROUP=""
LOCATION_VARIABLE=""
CLUSTER_NAME=""
workspaceKey=""
workspaceId=""

#---------------------------------------------------------------------------------------

vmresourcegroup="MC_${RESOURCE_GROUP}_${CLUSTER_NAME}_${LOCATION_VARIABLE}"
 
vmlist=$(az vm list-ip-addresses --resource-group $vmresourcegroup)

function jsonValue(){
    KEY=$1
    num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}

vmnames=$(echo $vmlist | jsonValue name)

for vmname in $vmnames
do
    echo "vm name:" $vmname
    az vm extension set --resource-group $vmresourcegroup --vm-name $vmname --publisher Microsoft.EnterpriseCloud.Monitoring --version 1.0 --name OmsAgentForLinux --protected-settings '{"workspaceKey": "'$workspaceKey'"}' --settings '{"workspaceId": "'$workspaceId'"}'
done
