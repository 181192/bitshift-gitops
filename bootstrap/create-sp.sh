#!/bin/bash

AZURE_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
AZURE_TENANT_ID=$(az account show --query tenantId -o tsv)
USER_NAME=$(az account show --query user.name --output tsv | cut -d'@' -f 1)
SERVICE_PRINCIPAL_NAME=$USER_NAME-bitshift-gitops

AZURE_CLIENT_SECRET=$(az ad sp create-for-rbac --name http://"$SERVICE_PRINCIPAL_NAME" --scopes /subscriptions/"$AZURE_SUBSCRIPTION_ID" --role contributor --query password --output tsv)
AZURE_CLIENT_ID=$(az ad sp show --id http://"$SERVICE_PRINCIPAL_NAME" --query appId --output tsv)

echo "export AZURE_TENANT_ID=$AZURE_TENANT_ID"
echo "export AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID"
echo "export AZURE_CLIENT_ID=$AZURE_CLIENT_ID"
echo "export AZURE_CLIENT_SECRET=$AZURE_CLIENT_SECRET"
