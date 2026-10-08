targetScope = 'resourceGroup'

@description('Globally unique Web App name. Use lowercase letters, digits and hyphens.')
@minLength(2)
@maxLength(60)
param name string
param location string = resourceGroup().location
@description('Published public Docker Hub username/repository:tag or username/repository@sha256:digest.')
param containerImage string
param tags object = {}

resource plan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: 'asp-${name}'
  location: location
  kind: 'linux'
  tags: tags
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  properties: {
    reserved: true
  }
}

resource app 'Microsoft.Web/sites@2024-11-01' = {
  name: name
  location: location
  kind: 'app,linux,container'
  tags: tags
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: false
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      linuxFxVersion: 'DOCKER|${containerImage}'
      appSettings: [
        {
          name: 'WEBSITES_PORT'
          value: '8000'
        }
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: 'https://index.docker.io'
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'WEBSITE_WEBDEPLOY_USE_SCM'
          value: 'true'
        }
      ]
    }
  }
}

// SCM publishing credentials support the existing Module 2 publish-profile workflow.
resource scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: app
  name: 'scm'
  properties: {
    allow: true
  }
}

resource ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: app
  name: 'ftp'
  properties: {
    allow: false
  }
}

output resourceId string = app.id
output appName string = app.name
output appUrl string = 'https://${app.properties.defaultHostName}'
