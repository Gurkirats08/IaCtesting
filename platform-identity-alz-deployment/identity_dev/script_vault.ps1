# Variables
$tenantId            = "10f919bc-6528-4f5e-9f26-5a50f051b6ce"
$subscriptionID      = "a03bd7fd-5bf3-4ea3-95be-7babd65eb73e"
$resourceGroupName   = "rg-idnt-test-01"
$location            = "uaenorth"
$vaultName           = "backupvault-idnt-platform-dev-005"
$userAssignedIdPath  = "/subscriptions/$subscriptionID/resourceGroups/$resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/idnt-ua-01-test"
$clientId            = "d4249891-fb80-4478-8253-dedd2334ffb5"
$principalId         = "a9c892ce-172b-4440-b372-e07a5e15a10b"
$cmkKeyUri           = "https://sec-hsm01.managedhsm.azure.net/keys/idnt-hsm-key-test/9ff6e5c370d84e363b51f0ed5de36ac2"

# Login to Azure
$ARM_CLIENT_SECRET = $args[1]
$ARM_CLIENT_ID = $args[0]


$SecureStringPwd = $ARM_CLIENT_SECRET | ConvertTo-SecureString -AsPlainText -Force
$pscredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ARM_CLIENT_ID, $SecureStringPwd
Connect-AzAccount -ServicePrincipal -Credential $pscredential -Tenant $tenantId

# Update-AzConfig -DefaultSubscriptionForLogin $subscriptionID
# Set-AzContext -Subscription $subscriptionID

# Storage Setting
$storageSetting = New-AzDataProtectionBackupVaultStorageSettingObject `
                    -DataStoreType VaultStore `
                    -Type LocallyRedundant

# User Assigned Identity
$userAssignedIdentity = @{
    $userAssignedIdPath = @{
        clientId    = $clientId
        principalId = $principalId
    }
}

# CMK Identity ID
# $cmkIdentityId = $userAssignedIdPath

# Create Backup Vault
$BackupVault = New-AzDataProtectionBackupVault `
                -ResourceGroupName $resourceGroupName `
                -VaultName $vaultName `
                -SubscriptionId $subscriptionID `
                -Location $location `
                -StorageSetting $storageSetting `
                -IdentityType UserAssigned `
                -UserAssignedIdentity $userAssignedIdentity `
                -CmkEncryptionState Enabled `
                -CmkIdentityType UserAssigned `
                -CmkUserAssignedIdentityId $userAssignedIdPath `
                -CmkEncryptionKeyUri $cmkKeyUri `
                -CmkInfrastructureEncryption Enabled






# $tenantId = "72f988bf-86f1-41af-91ab-2d7cd011db47"
# $subscriptionID = "c1a38017-1a26-49d0-9d9b-2f9b4f916b87"
# $location = "uaenorth"


# # Login to Azure
# Connect-AzAccount -DeviceCode -TenantId $tenantId
# Set-AzContext -Subscription $subscriptionID

# $storagesetting = New-AzDataProtectionBackupVaultStorageSettingObject -DataStoreType VaultStore -Type LocallyRedundant;
# $userAssignedIdentity = @{
#         '/subscriptions/c1a38017-1a26-49d0-9d9b-2f9b4f916b87/resourceGroups/rg-idnt-test-01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/idnt-ua-test-01' = @{
#           clientId = 'e8153fda-11e0-4a78-9b23-a1b032ff2f9e';
#           principalId = 'febad3f9-3e8f-435f-b538-eaf6e8df723b';
#         }
#       };
# $cmkIdentityId = '/subscriptions/c1a38017-1a26-49d0-9d9b-2f9b4f916b87/resourceGroups/rg-idnt-test-01/providers/Microsoft.ManagedIdentity/userAssignedIdentities/idnt-ua-test-01';
# $cmkKeyUri = 'https://secvault01.managedhsm.azure.net/keys/idnt-hsm-key-test01/205092358b964aa339a211dcdc3b494a';

# New-AzDataProtectionBackupVault -SubscriptionId $subscriptionID -ResourceGroupName 'rg-idnt-test-01' -VaultName 'backupvault-idnt-platform-dev-005' -Location $location -StorageSetting $storagesetting -IdentityType UserAssigned -UserAssignedIdentity $userAssignedIdentity -CmkEncryptionState Enabled -CmkIdentityType UserAssigned -CmkUserAssignedIdentityId $cmkIdentityId -CmkEncryptionKeyUri $cmkKeyUri -CmkInfrastructureEncryption Enabled;
   