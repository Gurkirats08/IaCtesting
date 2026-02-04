$VMName = "cvm-2019-01"
$ResourceGroup = "rg-idnt-test-01"
$OSDiskEncryptionSet = "sec-team"

$Subscription = "ME-MngEnvMCAP809010-identity"
$SubscriptionId = (Get-AzSubscription -SubscriptionName $Subscription).Id
Set-AzContext -SubscriptionId $SubscriptionId

Write-Output $SubscriptionId

$VM = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroup -ErrorAction Stop
Write-Output $VM

Describe "VM Tests for - $VMName" {
    It "Has expected OS Disk Encryption Set" {
        if ($OSDiskEncryptionSet -ne $null) {
            if ($VM.SecurityProfile.SecurityType -eq "ConfidentialVM") {
                $OSDisk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $VM.StorageProfile.OsDisk.Name -ErrorAction Stop
                ($OSDisk.SecurityProfile.SecureVMDiskEncryptionSetId -split "/")[-1] | Should -Be $OSDiskEncryptionSet
            }
            else {
                ($VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id -split "/")[-1] | Should -Be $OSDiskEncryptionSet
            }
        }
        else {
            if ($VM.SecurityProfile.SecurityType -eq "ConfidentialVM") {
                $OSDisk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $VM.StorageProfile.OsDisk.Name -ErrorAction Stop
                $OSDisk.SecurityProfile.SecureVMDiskEncryptionSetId | Should -BeNullOrEmpty
            }
            else {
                $VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id | Should -BeNullOrEmpty
            }
        }
    }
}



# # Debug output to verify VM properties
# Write-Output "VM OS Disk Name: $($VM.StorageProfile.OsDisk.Name)"
# Write-Output "VM Security Type: $($VM.SecurityProfile.SecurityType)"
# Write-Output "VM Disk Encryption Set ID: $($VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id)"

# It "Has expected OS Disk Encryption Set" {
#     if ($OSDiskEncryptionSet -ne $null) {
#         if ($VM.SecurityProfile -and $VM.SecurityProfile.SecurityType -eq "ConfidentialVM") {
#             $OSDisk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $VM.StorageProfile.OsDisk.Name -ErrorAction Stop
            
#             # Debug output
#             Write-Output "OS Disk Security Profile: $($OSDisk.SecurityProfile | ConvertTo-Json -Depth 10)"

#             if ($OSDisk.SecurityProfile -and $OSDisk.SecurityProfile.SecureVMDiskEncryptionSetId) {
#                 $SecureVMDESId = $OSDisk.SecurityProfile.SecureVMDiskEncryptionSetId
#                 Write-Output "SecureVMDiskEncryptionSetId: $SecureVMDESId"
#                 ($SecureVMDESId -split "/")[-1] | Should -Be $OSDiskEncryptionSet
#             }
#             else {
#                 Fail "SecureVMDiskEncryptionSetId not found in SecurityProfile"
#             }
#         }
#         else {
#             # Normal VM - Check if the property exists before splitting
#             if ($VM.StorageProfile.osDisk.ManagedDisk -and $VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id) {
#                 $NormalVMDESId = $VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id
#                 Write-Output "DiskEncryptionSet.Id: $NormalVMDESId"
#                 ($NormalVMDESId -split "/")[-1] | Should -Be $OSDiskEncryptionSet
#             }
#             else {
#                 Write-Output "DiskEncryptionSet.Id is null or not present for this VM."
#                 Fail "DiskEncryptionSet.Id is missing for non-CVM"
#             }
#         }
#     }
#     else {
#         if ($VM.SecurityProfile -and $VM.SecurityProfile.SecurityType -eq "ConfidentialVM") {
#             $OSDisk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $VM.StorageProfile.OsDisk.Name -ErrorAction Stop
            
#             if ($OSDisk.SecurityProfile -and $OSDisk.SecurityProfile.SecureVMDiskEncryptionSetId) {
#                 Write-Output "SecureVMDiskEncryptionSetId should be null."
#                 $OSDisk.SecurityProfile.SecureVMDiskEncryptionSetId | Should -BeNullOrEmpty
#             }
#             else {
#                 Write-Output "SecureVMDiskEncryptionSetId is already null."
#             }
#         }
#         else {
#             if ($VM.StorageProfile.osDisk.ManagedDisk -and $VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id) {
#                 Write-Output "DiskEncryptionSet.Id should be null."
#                 $VM.StorageProfile.osDisk.ManagedDisk.DiskEncryptionSet.Id | Should -BeNullOrEmpty
#             }
#             else {
#                 Write-Output "DiskEncryptionSet.Id is already null."
#             }
#         }
#     }
# }





# $VM = Get-AzVM -Name $VMName -ResourceGroupName $ResourceGroup -ErrorAction Stop


