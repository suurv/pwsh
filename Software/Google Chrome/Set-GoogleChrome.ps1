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
    $RemoteAgentPath,
    [Parameter()]
    [string]
    $PackagesPath,
    [Parameter()]
    [string]
    $PackageInstallTargetDir,
    [Parameter()]
    [string]
    $ChromeInstaller
)

<###
   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
   |    Begin Declare DefaultVars   |
   |    vvv                   vvv   |
###>

if (-not ($RemoteAgentPath)) {
    $RemoteAgentPath = "C:\Windows\LTSvc\"
};

if (-not ($PackagesPath)) {
    $PackagesPath = "C:\Windows\LTSvc\packages"
};

if (-not ($PackageInstallTargetDir)) {
    $PackageInstallTargetDir = "C:\Windows\LTSvc\packages\chrome"
};

if (-not ($ChromeInstaller)) {
    $ChromeInstaller = "GoogleChromeInstaller.exe"
};

<###
   |    ^^^                 ^^^     |
   |    End Declare DefaultVars     |
   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
   |    Begin Declare Functions     |
   |    vvv                 vvv     |
###>

function Test-PreReqDirs {
    if ( -not(Test-Path -Path $RemoteAgentPath) ) {
        mkdir $RemoteAgentPath;
    };
    if ( -not(Test-Path -Path $PackagesPath)) {
        mkdir $PackagesPath;
    };
};

function Install-Chrome {
    (New-Object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$PackageInstallTargetDir\$ChromeInstaller")
    & "$PackageInstallTargetDir\$ChromeInstaller" /silent /install;
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
    Remove-Item -Recurse -Force -Path $PackageInstallTargetDir;
};

<###
   |    ^^^                 ^^^     |
   |    End Declare Functions       |
   |~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~|
   |    Begin Execute Functions     |
   |    vvv                 vvv     |
###>

if ($Install) {    
    Test-PreReqDirs;

    if (Test-Path -Path $PackageInstallTargetDir) {
        Install-Chrome;
    } else {
        mkdir $PackageInstallTargetDir;
        Install-Chrome;
    };

} elseif ($Uninstall) {
    Uninstall-Chrome
}
