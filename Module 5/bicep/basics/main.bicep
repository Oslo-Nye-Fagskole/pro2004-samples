targetScope = 'subscription'

param resourceGroupName string = 'rg-shop'
param location string = 'westeurope'
param tags object = {
  environment: 'development'
  course: 'PRO2004'
}

resource shop 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

output resourceGroupId string = shop.id
