param keyVaultName string
param containerRegistryName string
param containerRegistryImageName string
param containerRegistryImageVersion string = 'main-latest'
param appServicePlanName string
param siteName string
param location string = resourceGroup().location
param keyVaultSecretNameACRUsername string = 'acr-username'
param keyVaultSecretNameACRPassword1 string = 'acr-password1'
param keyVaultSecretNameACRPassword2 string = 'acr-password2'

resource keyvault 'Mircrosoft.KeyVault/vaults@2023-02-01' existing = {
  name: keyVaultName
}

module containerRegistry 'modules/container-registry/registry/main.bicep' = {
  dependsOn: [
    keyvault
  ]
  name: '${uniqueString(deployment().name)}-acr'
  params: {
    name: containerRegistryName
    location: location  
    acrAdminUserEnabled: true
    adminCredentialsKeyVaultResourceId: resourceId('Microsoft.KeyVault/vaults', keyVaultName)
    adminCredentialsKeyVaultSecretUserName: keyVaultSecretNameACRUsername
    adminCredentialsKeyVaultSecretPassword1: keyVaultSecretNameACRPassword1
    adminCredentialsKeyVaultSecretPassword2: keyVaultSecretNameACRPassword2
  }
}

module serverfarm 'modules/web/serverfarm/main.bicep' = {
  name: '${uniqueString(deployment().name)}-asp'
  params: {
    name: appServicePlanName
    location: location
    sku: {
      capacity: '1'
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

module website 'modules/web/site/main.bicep' = {
  dependsOn: [
    serverfarm
    containerRegistry
    keyVault
  ]
  name: '${uniqueString(deployment().name)}-site'
  params: {
    name: siteName
    location: 

  }
}
