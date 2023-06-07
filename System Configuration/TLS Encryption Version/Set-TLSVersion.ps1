<#
.SYNOPSIS
    Set the desired version of TLS/SSL
.DESCRIPTION
    PowerShell assumes the TLS 1.0 is good enough but some websites throw errors and you have to change the supported 
    TLS types by PowerShell
.EXAMPLE
    .\Set-TLSVersion.ps1
#>


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12