<#
.SYNOPSIS
    Set the desired version of TLS/SSL
.DESCRIPTION
    PowerShell assumes the TLS 1.0 is good enough but some websites throw errors and you have to change the supported 
    TLS types by PowerShell
.EXAMPLE
    .\Set-TLSVersion.ps1 -Version Tls12
    This will change the version of TLS used by PowerShell to TLS 1.2
#>

param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("Tls", "Tls11", "Tls12", "Tls13", "Ssl3", "SystemDefault")]
    [string]
    $Version
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::$Version