#!/bin/bash
#This script will create a service principle in Azure AD
# written by Moran Guy

echo "please provide Azure Subscription ID :"
read subscription_id
az account set --subscription "${subscription_id}" 
echo "please provide Azure Service Principle Name you want to create :"
read principle_name
az ad sp create-for-rbac -n "${principle_name}" --role contributor --scopes "/subscriptions/${subscription_id}" > service_principle.json
app_id=$(cat service_principle.json | jq -r '."appId"')
echo "your app id is ${app_id}"
app_password=$(cat service_principle.json | jq -r '."password"')
echo "your app password / secret is ${app_password}"
az role assignment create --role "User Access Administrator" --assignee-object-id $(az ad sp list --filter "appId eq '${app_id}'" | jq '.[0].id' -r)

az ad app permission add --id ${app_id} --api 00000002-0000-0000-c000-000000000000 --api-permissions 824c81eb-e3f8-4ee6-8f6d-de7f50d565b7=Role

az ad app permission grant --id ${app_id} --api 00000002-0000-0000-c000-000000000000 --scope "/subscriptions/${subscription_id}"

# if service principe need to be deleted.
# az ad sp delete --id 4b82b73c-67b8-4d33-a2f0-1a673f03725e