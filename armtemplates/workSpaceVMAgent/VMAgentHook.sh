#!/bin/bash
# Copyright (c) Microsoft Corporation. All rights reserved.

CLUSTER_RESOURCE_GROUP=${1:-defaultResourceGroup}
WORKSPACE_RESOURCE_GROUP=${2:-defaultResourceGroup}
LOCATION=${3:-westus2}
CLUSTER_NAME=${4:-clusterDefault}
WORKSPACE_DEPLOYMENT=${5:-azuredeploy_workspace}

#---------------------------------------------------------------------------------------

# Get workspaceKey and customerId from deployment output
workspaceKey=$(az group deployment show -g ${WORKSPACE_RESOURCE_GROUP} -n ${WORKSPACE_DEPLOYMENT} --query properties.outputs.workspaceKey.value)
workspaceId=$(az group deployment show -g ${WORKSPACE_RESOURCE_GROUP} -n ${WORKSPACE_DEPLOYMENT} --query properties.outputs.customerId.value)
echo $workspaceKey
echo $workspaceId

vmresourcegroup="MC_${CLUSTER_RESOURCE_GROUP}_${CLUSTER_NAME}_${LOCATION}"

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
    az vm extension set --resource-group $vmresourcegroup --vm-name $vmname --publisher Microsoft.EnterpriseCloud.Monitoring --version 1.0 --name OmsAgentForLinux --protected-settings '{"workspaceKey": '$workspaceKey'}' --settings '{"workspaceId": '$workspaceId'}'
done
