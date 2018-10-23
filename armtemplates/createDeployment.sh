#!/bin/bash
# Copyright (c) Microsoft Corporation. All rights reserved.

RESOURCE_GROUP="ResourceGroupName"
WORKSPACE_NAME="WorkspaceName"
AG_NAME="YourActionGroupName"
AG_SHORTNAME="AGShortName"
AG_EMAIL_NAME="myEmailName"
AG_EMAIL="myEmail@gmail.com"
ALERT_NAME="CPUAlert"

# Create resource group
az group create -l westus -n ${RESOURCE_GROUP}

# Deploy workspace
cd workspace
az group deployment create --resource-group ${RESOURCE_GROUP} \
    --name azuredeploy_workspace --template-file ./azuredeploy.json \
    --parameters azuredeploy.parameters.json \
    --parameters workspaceName=${WORKSPACE_NAME} \

# Deploy action group
cd ../actionGroup
az group deployment create --resource-group ${RESOURCE_GROUP} \
    --name azuredeploy_actiongroup --template-file ./azuredeploy.json \
    --parameters azuredeploy.parameters.json \
    --parameters actiongroupName=${AG_NAME} \
    --parameters actionGroupShortName=${AG_SHORTNAME} \
    --parameters emailName=${AG_EMAIL_NAME} \
    --parameters email=${AG_EMAIL}

# Deploy alerts
cd ../alerts
az group deployment create --resource-group ${RESOURCE_GROUP} \
--name azuredeploy_alerts --template-file ./azuredeploy.json \
--parameters azuredeploy.parameters.json \
--parameters workspaceName=${WORKSPACE_NAME} \
--parameters actiongroupName=${AG_NAME} \
--parameters alertName=${ALERT_NAME}

# Hook VMs to workspace
cd ../workSpaceVMAgent
./VMAgentHook.sh \
    "clusterresourcegroupname" \
    "${RESOURCE_GROUP}" \
    "westus2" \
    "clustername" \
    "azuredeploy_workspace" 