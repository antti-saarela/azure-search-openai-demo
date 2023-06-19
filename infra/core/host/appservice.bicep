param name string  
param location string = resourceGroup().location  
param tags object = {}  
  
// Reference Properties  
param applicationInsightsName string = ''  
param appServicePlanId string  
param keyVaultName string = ''  
param managedIdentity bool = !empty(keyVaultName)  
  
// Runtime Properties  
@allowed([  
  'dotnet', 'dotnetcore', 'dotnet-isolated', 'node', 'python', 'java', 'powershell', 'custom'  
])  
param runtimeName string  
param runtimeNameAndVersion string = '${runtimeName}|${runtimeVersion}'  
param runtimeVersion string  
  
// Microsoft.Web/sites Properties  
param kind string = 'app,linux'  
  
// Microsoft.Web/sites/config  
param allowedOrigins array = []  
param alwaysOn bool = true  
param appCommandLine string = ''  
param appSettings object = {}  
param clientAffinityEnabled bool = false  
param enableOryxBuild bool = contains(kind, 'linux')  
param functionAppScaleLimit int = -1  
param linuxFxVersion string = runtimeNameAndVersion  
param minimumElasticInstanceCount int = -1  
param numberOfWorkers int = -1  
param scmDoBuildDuringDeployment bool = false  
param use32BitWorkerProcess bool = false  
param ftpsState string = 'FtpsOnly'  
param healthCheckPath string = ''  
  
resource appService 'Microsoft.Web/sites@2022-03-01' = {  
  name: name  
  location: location  
  tags: tags  
  kind: kind  
  properties: {  
    serverFarmId: appServicePlanId  
    siteConfig: {  
      linuxFxVersion: linuxFxVersion  
      alwaysOn: alwaysOn  
      ftpsState: ftpsState  
      appCommandLine: appCommandLine  
      numberOfWorkers: numberOfWorkers != -1 ? numberOfWorkers : null  
      minimumElasticInstanceCount: minimumElasticInstanceCount != -1 ? minimumElasticInstanceCount : null  
      use32BitWorkerProcess: use32BitWorkerProcess  
      functionAppScaleLimit: functionAppScaleLimit != -1 ? functionAppScaleLimit : null  
      healthCheckPath: healthCheckPath  
      cors: {  
        allowedOrigins: union([ 'https://portal.azure.com', 'https://ms.portal.azure.com' ], allowedOrigins)  
      }  
    }  
    clientAffinityEnabled: clientAffinityEnabled  
    httpsOnly: true  
  }  
  
  identity: { type: managedIdentity ? 'SystemAssigned' : 'None' }  
  
  resource configAppSettings 'config' = {  
    name: 'appsettings'  
    properties: union(appSettings,  
      {  
        SCM_DO_BUILD_DURING_DEPLOYMENT: string(scmDoBuildDuringDeployment)  
        ENABLE_ORYX_BUILD: string(enableOryxBuild)  
      },  
      !empty(applicationInsightsName) ? { APPLICATIONINSIGHTS_CONNECTION_STRING: applicationInsights.properties.ConnectionString } : {},  
      !empty(keyVaultName) ? { AZURE_KEY_VAULT_ENDPOINT: keyVault.properties.vaultUri } : {})  
  }  
  
  resource configLogs 'config' = {  
    name: 'logs'  
    properties: {  
      applicationLogs: { fileSystem: { level: 'Verbose' } }  
      detailedErrorMessages: { enabled: true }  
      failedRequestsTracing: { enabled: true }  
      httpLogs: { fileSystem: { enabled: true, retentionInDays: 1, retentionInMb: 35 } }  
    }  
    dependsOn: [  
      configAppSettings  
    ]  
  }  
  
  resource appServiceNetworking 'config' = {  
    name: 'web'  
    properties: {  
      ipSecurityRestrictions: [  
        {
          ipAddress: '131.207.242.5/32'
          action: 'Allow'
          tag: 'Default'
          priority: 100
          name: 'TietoevryPublicIP'
          description: 'Allow traffic from Tietoevry public IP office addresses'
        }
        {
            ipAddress: '131.207.242.128/32'
            action: 'Allow'
            tag: 'Default'
            priority: 110
            name: 'TietoevryVPN'
            description: 'Allow traffic from Tietoevry VPN addresses'
        }
        {
            ipAddress: '193.15.240.56/28'
            action: 'Allow'
            tag: 'Default'
            priority: 200
            name: 'TietoevrySweden'
            description: 'Tietoevry Sweden offices'
        }
        {
            ipAddress: '86.62.169.149/32'
            action: 'Allow'
            tag: 'Default'
            priority: 210
            name: 'TietoevryFornebu'
            description: 'Tietoevry Fornebu office'
        }
        {
            ipAddress: '194.71.87.232/32'
            action: 'Allow'
            tag: 'Default'
            priority: 220
            name: 'TietoevryOslo'
            description: 'Tietoevry Oslo office'
        }
        {
            ipAddress: '194.71.87.1/32'
            action: 'Allow'
            tag: 'Default'
            priority: 230
            name: 'TietoevrySwedenAddOn'
            description: 'Tietoevry Sweden Additional IP address'
        }
        {
            ipAddress: '0.0.0.0/0'
            action: 'Deny'
            tag: 'Default'
            priority: 2147483647
            name: 'DenyAll'
            description: 'Deny all other traffic'
        }
        {
            ipAddress: '193.15.240.60/32'
            action: 'Allow'
            tag: 'Default'
            priority: 240
            name: 'Tietoevry-VPN-SWE'
            description: 'Tietoevry GlobalProtect VPN SWE'
        }
        {
            ipAddress: 'Any'
            action: 'Deny'
            priority: 2147483647
            name: 'Deny all'
            description: 'Deny all access'
        }  
      ]  
    }   
  }  
}  
  
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = if (!(empty(keyVaultName))) {  
  name: keyVaultName  
}  
  
resource applicationInsights 'Microsoft.Insights/components@2020-02-02' existing = if (!empty(applicationInsightsName)) {  
  name: applicationInsightsName  
}  
  
output identityPrincipalId string = managedIdentity ? appService.identity.principalId : ''  
output name string = appService.name  
output uri string = 'https://${appService.properties.defaultHostName}'  
