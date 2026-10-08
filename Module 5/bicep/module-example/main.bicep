// The small module call shown in Chapter 5.7, before the larger API hosting module.
targetScope = 'subscription'

module shop '../modules/resource-group.bicep' = {
  name: 'shop-group'
  params: {
    name: 'rg-shop'
    location: 'westeurope'
  }
}

output shopGroupId string = shop.outputs.resourceGroupId
