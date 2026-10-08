[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SubscriptionId,
    [string]$ResourceGroupName = 'rg-shop-imperative',
    [string]$Location = 'westeurope',
    [string]$Environment = 'development'
)

$ErrorActionPreference = 'Stop'

# Every cloud command explicitly selects the target subscription.
$exists = az group exists --subscription $SubscriptionId --name $ResourceGroupName
if ($LASTEXITCODE -ne 0) { throw 'Could not check whether the group exists.' }

if ($exists -eq 'false') {
    az group create --subscription $SubscriptionId --name $ResourceGroupName --location $Location --output none
    if ($LASTEXITCODE -ne 0) { throw 'Resource group creation failed.' }
}

# Reapply the intended tag on every run; preserve unrelated tags.
$groupId = az group show --subscription $SubscriptionId --name $ResourceGroupName --query id --output tsv
if ($LASTEXITCODE -ne 0) { throw 'Could not read the resource group.' }
az tag update --subscription $SubscriptionId --resource-id $groupId --operation Merge --tags "environment=$Environment" --output none
if ($LASTEXITCODE -ne 0) { throw 'Tag update failed. Inspect the group before rerunning.' }

az group show --subscription $SubscriptionId --name $ResourceGroupName --query '{name:name,location:location,tags:tags}'
if ($LASTEXITCODE -ne 0) { throw 'Resource group verification failed.' }
