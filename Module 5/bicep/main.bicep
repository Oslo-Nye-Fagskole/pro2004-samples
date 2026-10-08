targetScope = 'subscription'

@allowed([
  'development'
  'production'
])
param environment string = 'development'
param resourceGroupName string
param appName string
param containerImage string
param location string = 'westeurope'
param tags object = {}

var environmentTags = union(tags, {
  environment: environment
  course: 'PRO2004'
})

resource shop 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: location
  tags: environmentTags
}

module storeApi './modules/web-app.bicep' = {
  name: 'store-api-${environment}'
  scope: shop
  params: {
    name: appName
    location: location
    containerImage: containerImage
    tags: environmentTags
  }
}

output appId string = storeApi.outputs.resourceId
output appName string = storeApi.outputs.appName
output appUrl string = storeApi.outputs.appUrl
