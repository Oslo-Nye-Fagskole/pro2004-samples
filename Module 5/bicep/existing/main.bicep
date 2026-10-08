targetScope = 'subscription'

param resourceGroupName string = 'rg-shop'

resource shop 'Microsoft.Resources/resourceGroups@2022-09-01' existing = {
  name: resourceGroupName
}

// Resolves an identifier; this declaration neither creates nor updates the group.
output resourceGroupId string = shop.id
