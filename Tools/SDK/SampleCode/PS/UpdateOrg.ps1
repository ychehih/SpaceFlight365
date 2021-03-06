param
(
    #required params
    [string]$Name = $(throw "Name parameter not specified"),
    
    #optional params
    [switch]$Upgrade,
    [switch]$WaitForJob
)

$RemoveSnapInWhenDone = $False

if (-not (Get-PSSnapin -Name Microsoft.Crm.PowerShell -ErrorAction SilentlyContinue))
{
    Add-PSSnapin Microsoft.Crm.PowerShell
    $RemoveSnapInWhenDone = $True
}

$opId = Update-CrmOrganization -Name $Name $Upgrade
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

    if($Upgrade)
    {
        Write-Host [(Get-Date)] Upgrade org completed successfully.
    }
    else
    {
        Write-Host [(Get-Date)] Update org completed successfully.
    }
}
else
{
    Write-Host [(Get-Date)] Update org async job requested.
}


if($RemoveSnapInWhenDone)
{
    Remove-PSSnapin Microsoft.Crm.PowerShell
}
