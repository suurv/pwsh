<#
.SYNOPSIS
    Install Google Chrome
.DESCRIPTION
    This script at one time worked to install Chrome. You should test this to verify. It was also capable of removing 
    the software too. This may serve as starting point or a POC. The script still works but could definitely have a lot 
    complexity removed. For example the script would be best if it used temp dirs and files so that the installer could 
    be automagically cleaned up by the OS.
.NOTES
    Only supports Windows
.EXAMPLE
    .\Set-GoogleChrome.ps1 -Install
.EXAMPLE
    .\Set-GoogleChrome.ps1 -Uninstall
#>

[CmdletBinding()]
param (
    [Parameter( Mandatory = $true,
                ParameterSetName = 'Install',
                Position = 0)]
    [switch]
    $Install,
    [Parameter( Mandatory = $true,
                ParameterSetName = 'Uninstall',
                Position = 0)]
    [switch]
    $Uninstall,
    [Parameter()]
    [string]
    $DownloadDir = $env:TEMP,
    [Parameter()]
    [string]
    $ChromeInstaller = "GoogleChromeInstaller.exe"
)

function Install-Chrome {
    (New-Object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$DownloadDir\$ChromeInstaller")
    & "$DownloadDir\$ChromeInstaller" /silent /install;
};

function Get-UninstallString {
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $Program
    )
    Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object {$_.DisplayName -imatch "$Program" } | Select-Object -Property DisplayName, UninstallString;
};

function Uninstall-Chrome {
    $UninstallString = ((Get-UninstallString -Program "Google Chrome").UninstallString -replace ('"', "'"))
    powershell.exe -c "& $UninstallString --force-uninstall";
};

if ($Install) {
    if (Test-Path -Path $DownloadDir) {
        Install-Chrome
    } else {
        Write-Error "$DownloadDir does no exist."
    }
} elseif ($Uninstall) {
    Uninstall-Chrome
}
