#Requires -Modules Microsoft.Online.SharePoint.PowerShell
Connect-SPOService -Url $(Read-Host -Prompt "Supply the administration SharePoint URL. i.e. https://<tenant>-admin.sharepoint.com")
Write-Host "Getting OneDrive sites..."
$OneDrives = Get-SPOSite -IncludePersonalSite $True -Limit All -Filter "Url -like '-my.sharepoint.com/personal/'"
$Result = @()
ForEach ($OneDrive in $OneDrives)
{
    $OneDrive = [PSCustomObject]@{
        Email       = $OneDrive.Owner
        URL         = $OneDrive.URL
        QuotaGB     = [Math]::Round($OneDrive.StorageQuota / 1024, 3) 
        UsedGB      = [Math]::Round($OneDrive.StorageUsageCurrent / 1024, 3)
        PercentUsed = [Math]::Round(($OneDrive.StorageUsageCurrent / $OneDrive.StorageQuota * 100), 3)
    }
    $Result += $OneDrive
}
$Result | Format-Table Email,URL,UsedGB,QuotaGB,PercentUsed -AutoSize
$Result | Export-Csv -Path $(Read-Host -Prompt "Enter a Path for the output file") -NoTypeInformation
