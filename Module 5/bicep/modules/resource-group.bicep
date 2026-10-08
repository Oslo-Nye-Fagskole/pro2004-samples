targetScope = 'subscription'

param name string
param location string

resource group 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: name
  location: location
}

output resourceGroupId string = group.id
