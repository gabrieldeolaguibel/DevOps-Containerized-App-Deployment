param keyVaultName string
param containterRegistryName string
param conttainerRegistryImageName string
param conttainerRegistryImageVersion string = 'main-latest'
param appServicePlanName string
param siteName string
param siteLocation string = resourceGroup().location
param keyVaultSecretNameACRUsername string = 'acr-username'
param keyVaultSecretNameACRPassword1 string = 'acr-password1'
param keyVaultSecretNameACRPassword2 string = 'acr-password2'

resource keyVault 'Mircrosoft.KeyVault@2023-02-01' existing = {
  name: keyVaultName
}

resource containerRegistry 'modules/container-registry/registry/main.bicep' = {
  dependsOn: [
    keyVault
  ]
  name: '${uniqueString(deployment().name)}-acr'
  params: {
    name: containterRegistryName
    location: location  
    acrAdminUserEnabled: true
    adminCredentialsKeyVaultResourceId: resourceId('Microsoft.KeyVault/vaults', keyVaultName)
    adminCredentialsKeyVaultSecretUserName: keyVaultSecretNameACRUsername
    adminCredentialsKeyVaultSecretPassword1: keyVaultSecretNameACRPassword1
    adminCredentialsKeyVaultSecretPassword2: keyVaultSecretNameACRPassword2
  }
}
