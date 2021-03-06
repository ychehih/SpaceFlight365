param
(
    #optional params
    [boolean]$Enabled,
    [string]$EncryptionCertificate,
    [string]$FederationMetadataUrl
)

$RemoveSnapInWhenDone = $False

if (-not (Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}

$ClaimsSettings = Get-CrmSetting -SettingType ClaimsSettings

if($PSBoundParameters.ContainsKey('Enabled')) {$ClaimsSettings.Enabled = $Enabled}
if($EncryptionCertificate) {$ClaimsSettings.EncryptionCertificate = $EncryptionCertificate}
if($FederationMetadataUrl) {$ClaimsSettings.FederationMetadataUrl = $FederationMetadataUrl}

Set-CrmSetting -Setting $ClaimsSettings

$ClaimsSettings

if($RemoveSnapInWhenDone)
{
    Remove-PSSnapin Microsoft.Crm.PowerShell
}
