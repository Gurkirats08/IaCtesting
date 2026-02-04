# Define Variables
$hsmName = "Sec-hsm01"  # The name of the Managed HSM
$hsmKeyName = "hsm-key-sec-002"  # Key name to be created in the HSM
$hsm_resource_group = "rg-sec-hsm-sao-aen-01"
$subscriptionId = "dac03557-6089-4127-ae8a-e343e5635de2"  # Subscription ID where the HSM resides
$subSecurityServicesID = "dac03557-6089-4127-ae8a-e343e5635de2" #subscription where the des resides

$diskEncryptionSetName = "sec-team"  # Name of the Disk Encryption Set
$resourceGroupName = "rg-common-sec-prd-sao-aen-001"  # Resource group where the Disk Encryption Set is located

$uanrg ="rg-common-sec-prd-sao-aen-001"
$uanname = "ua-sec-identity"
$userAssignedIdentityId = "/subscriptions/$subSecurityServicesID/resourceGroups/$uanrg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$uanname"  # User-assigned identity ID for encryption
$location = "uaenorth"  # Azure location
$policyFilePath = "./public_SKR_policy.json"  # Path to the SKR policy JSON file
$notBefore = "2024-09-20T00:00:00Z"  # Validity start date for the key
$expires = "2026-09-19T23:59:59Z"  # Expiration date for the key

$terraformStorageRG = "rg-devops-sec-sao-aen-001" #statefile storage account RG
$terraformStorageAccount = "stsaosecdevopsaen020" #statefile storage account name

# Create the Key in Managed HSM
az keyvault key create `
    --exportable true `
    --hsm-name $hsmName `
    --kty RSA-HSM `
    --name $hsmKeyName `
    --policy $policyFilePath `
    --not-before $notBefore `
    --expires $expires `
    --subscription $subscriptionId

# Retrieve Key URL
$keyVaultKeyUrl = az keyvault key show `
    --hsm-name $hsmName `
    --name $hsmKeyName `
    --query "key.kid" -o tsv

# Create Disk Encryption Set
az disk-encryption-set create `
    -n $diskEncryptionSetName `
    -l $location `
    -g $resourceGroupName `
    --subscription $subSecurityServicesID `
    --key-url $keyVaultKeyUrl `
    --enable-auto-key-rotation false `
    --encryption-type "ConfidentialVmEncryptedWithCustomerKey" `
    --mi-system-assigned false `
    --mi-user-assigned $userAssignedIdentityId

#statefile account encryption using hsm key
$hsmurl= az keyvault show `
    --subscription $subscriptionId `
    --hsm-name $hsmName `
    --query properties.hsmUri `
    --output tsv

# Update the storage account with the encryption settings
az storage account update `
    --name $terraformStorageAccount `
    --resource-group $terraformStorageRG `
    --encryption-key-name $hsmKeyName `
    --encryption-key-source "Microsoft.Keyvault" `
    --encryption-key-vault $hsmurl `
    --key-vault-user-identity-id $userAssignedIdentityId `
    --identity-type "UserAssigned" `
    --user-identity-id $userAssignedIdentityId




