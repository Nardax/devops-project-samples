#!/bin/bash
# Copyright (c) Microsoft Corporation. All rights reserved.

cd workspace

az group deployment create --resource-group aksdevsandbox3 --name azuredeploy_workspace --template-file ./azuredeploy.json --parameters azuredeploy.parameters.json

cd ../actionGroup

az group deployment create --resource-group aksdevsandbox3 --name azuredeploy_actiongroup --template-file ./azuredeploy.json --parameters azuredeploy.parameters.json

cd ../alerts

az group deployment create --resource-group aksdevsandbox3 --name azuredeploy_alerts --template-file ./azuredeploy.json --parameters azuredeploy.parameters.json

cd ../workSpaceVMAgent

./VMAgentHook.sh "azuredeploy_workspace"