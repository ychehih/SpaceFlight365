param
(
    #optional params
    [string]$RootDomainScheme,
    [string]$DeploymentSdkRootDomain,
    [string]$DiscoveryRootDomain,
    [boolean]$NlbEnabled,
    [string]$SdkRootDomain,
    [string]$SslHeader,
    [string]$WebAppRootDomain
)

$RemoveSnapInWhenDone = $False

if (-not (Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}

$WebAddressSettings = Get-CrmSetting -SettingType WebAddressSettings

if($DeploymentSdkRootDomain) {$WebAddressSettings.DeploymentSdkRootDomain = $DeploymentSdkRootDomain}
if($DiscoveryRootDomain) {$WebAddressSettings.DiscoveryRootDomain = $DiscoveryRootDomain}
if($PSBoundParameters.ContainsKey('NlbEnabled')) {$WebAddressSettings.NlbEnabled = $NlbEnabled}
if($RootDomainScheme) {$WebAddressSettings.RootDomainScheme = $RootDomainScheme}
if($SdkRootDomain) {$WebAddressSettings.SdkRootDomain = $SdkRootDomain}
if($PSBoundParameters.ContainsKey('SslHeader')) {$WebAddressSettings.SslHeader = $SslHeader}
if($WebAppRootDomain) {$WebAddressSettings.WebAppRootDomain = $WebAppRootDomain}

Set-CrmSetting -Setting $WebAddressSettings

$WebAddressSettings

if($RemoveSnapInWhenDone)
{
    Remove-PSSnapin Microsoft.Crm.PowerShell
}
