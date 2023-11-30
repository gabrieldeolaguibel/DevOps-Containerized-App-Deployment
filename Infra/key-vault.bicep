param keyVaultName string
param location string = resourceGroup().location
param roleAssignments array = []

module keyvault 'modules/key-vault/vault/main.bicep' = {
  name: '${uniqueString(deployment().name)}-kv'
  params: {
    name: keyVaultName
    location: location
    enableVaultForDeployment: true
    roleAssignments: roleAssignments
  }
}
