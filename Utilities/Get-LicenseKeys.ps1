param (
    [Parameter(
        Position=0,
        HelpMessage="Path to one locations.")]
    [string]
    $Path = ".\$(hostname.exe)-LicenseKeys.txt"
)

$RegLicense = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\' -Name BackupProductKeyDefault).BackupProductKeyDefault

$OEMLicense = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey

"BackupProductKeyDefault: " + $RegLicense | Tee-Object -Append -FilePath $Path
"OEM Key: " + $OEMLicense | Tee-Object -Append -FilePath $Path

"`nOutput saved to " + $Path | Write-Host
