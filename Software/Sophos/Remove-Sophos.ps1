<#
.SYNOPSIS
    Remove Sophos
.DESCRIPTION
    This script will remove Sophos under the impression that tamper protection is disabled already.
.NOTES
    This script runs on only Windows
.EXAMPLE
    .\Remove-Sophos.ps1
#>

#Requires -RunAsAdministrator

if (Test-Path -Path "C:\Program Files\Sophos\Sophos Endpoint Agent\SophosUninstall.exe" -PathType Leaf) {
    Start-Process -FilePath "C:\Program Files\Sophos\Sophos Endpoint Agent\SophosUninstall.exe" `
        -ArgumentList "--quiet" `
        -NoNewWindow `
        -Wait
} else {
    Write-Host "Uninstaller not found"
}
