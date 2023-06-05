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
          priority: 100  
          name: 'TietoevryPublicIP'  
          description: 'Allow traffic from Tietoevry public IP office addresses'  
        }  
        {  
          ipAddress: '131.207.242.128/32'  
          action: 'Allow'  
          priority: 110  
          name: 'TietoevryVPN'  
          description: 'Allow traffic from Tietoevry VPN addresses'  
        }
        {  
          ipAddress: '193.66.181.64/28'  
          action: 'Allow'  
          priority: 200  
          name: 'HUSExpressRoute'  
          description: 'Allow traffic from HUS ExpressRoute addresses'  
        }
        {  
          ipAddress: '193.166.190.0/24'  
          action: 'Allow'  
          priority: 210  
          name: 'HUSOutboundNAT1'  
          description: 'Allow traffic from HUS Outbound NAT addresses'  
        }
        {  
          ipAddress: '193.166.253.0/24'  
          action: 'Allow'  
          priority: 200  
          name: 'HUSOutboundNAT2'  
          description: 'Allow traffic from HUS Outbound NAT addresses'  
        }   
        {  
          ipAddress: '0.0.0.0/0'  
          action: 'Deny'  
          priority: 2147483647  
          name: 'DenyAll'  
          description: 'Deny all other traffic'  
        }  
      ]  
    }  
    dependsOn: [  
      appService  
    ]  
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
