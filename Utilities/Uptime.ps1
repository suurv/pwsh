<#
.SYNOPSIS
    A samll system uptime command
.DESCRIPTION
    This command was created for systems that don't have the `Get-Uptime` cmdlet
.NOTES
    Windows only
.EXAMPLE
    .\Uptime.ps1

    LastBootUpTime
    --------------
    6/8/2023 12:52:06 PM
#>


Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object LastBootUpTime