<#
.SYNOPSIS
    Install Mozilla Firefox
.DESCRIPTION
    This script at one time worked to install Firefox. You should test this to verify. It was also capable of removing 
    the software too. This may serve as starting point or a POC. The script still works but could definitely have a lot 
    complexity removed. For example the script would be best if it used temp dirs and files so that the installer could 
    be automagically cleaned up by the OS.
.NOTES
    Only supports Windows
.EXAMPLE
    .\Set-MozillaFirefox.ps1 -Install
.EXAMPLE
    .\Set-MozillaFirefox.ps1 -Uninstall
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
    $FirefoxInstaller = "FirefoxInstaller.msi"
)

$vars = @{
    DownloadURL = 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US'
    UninstallRegistryPaths = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    ProgramDisplayName = "Mozilla Firefox"
}

function Install-Program
{
    (New-Object System.Net.WebClient).DownloadFile($vars.DownloadURL, "$DownloadDir\$FirefoxInstaller")
    & "$DownloadDir\$FirefoxInstaller" /qn
};

function Get-UninstallString
{
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $Program
    )
    Get-ChildItem -Path $vars.UninstallRegistryPaths | Get-ItemProperty | Where-Object {$_.DisplayName -imatch "$Program" } | Select-Object -Property DisplayName, UninstallString;
};

function Uninstall-Program
{
    $UninstallString = ((Get-UninstallString -Program $vars.ProgramDisplayName).UninstallString -replace ('"', "'"))
    powershell.exe -c "& $UninstallString /silent";
};

if ($Install)
{
    if (Test-Path -Path $DownloadDir)
    {
        Install-Program
    } else
    {
        Write-Error "$DownloadDir does no exist."
    }
} elseif ($Uninstall)
{
    Uninstall-Program
}
