Function createorg{
param
(
   #required params
    [string]$DisplayName ="Testorgan",
    [string]$SqlServerName = $env:COMPUTERNAME,
    [string]$SrsUrl = "http://$SqlServerName/reportserver",
    
    #optional params (can accept nulls)
    [string]$Name,
    [string]$BaseCurrencyCode,
    [string]$BaseCurrencyName,
    [string]$BaseCurrencySymbol,
    [string]$BaseCurrencyPrecision,
    [string]$BaseLanguageCode,
    [string]$SqlCollation,
    [string]$SQMOptIn,
    [string]$SysAdminName,
    [switch]$WaitForJob=$True
)

$RemoveSnapInWhenDone = $False

if (-not (Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}


$opId = New-CrmOrganization -DisplayName $DisplayName -SqlServerName $SqlServerName -SrsUrl $SrsUrl -Name $Name -BaseCurrencyCode $BaseCurrencyCode -BaseCurrencyName $BaseCurrencyName -BaseCurrencySymbol $BaseCurrencySymbol -BaseCurrencyPrecision $BaseCurrencyPrecision -BaseLanguageCode $BaseLanguageCode -SqlCollation $SqlCollation -SQMOptIn $SQMOptIn -SysAdminName $SysAdminName
$opId


if($WaitForJob)
{
    $opstatus = Get-CrmOperationStatus -OperationId $opid
    while($opstatus.State -eq "Processing")
    {
        Write-Host [(Get-Date)] Processing...
        Start-Sleep -s 30
        $opstatus = Get-CrmOperationStatus -OperationId $opid
    }

    if($opstatus.State -eq "Failed")
    {
        Throw ($opstatus.ProcessingError.Message)
    }

    Write-Host [(Get-Date)] Create org completed successfully.
}
else
{
    Write-Host [(Get-Date)] Create org async job requested.
}

if($RemoveSnapInWhenDone)
{
    Remove-PSSnapin Microsoft.Crm.PowerShell
}
}
