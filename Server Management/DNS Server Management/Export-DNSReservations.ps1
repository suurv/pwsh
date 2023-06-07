<#
.SYNOPSIS
    Gets DNS Resevations from a Windows DHCP Server
.DESCRIPTION
    This was created when there was a need to migrate the DHCP role from a 
    Windows DHCP server that was being replaced by a new DHCP server on a 
    router. 
.NOTES
    Not supported in Linux
    Must be run on the desired machine.
    Is only for IPv4
.EXAMPLE
    ./Export-DNSReservations.ps1
    Export to "C:\$($env:COMPUTERNAME)-Reservations.csv"
#>

#Requires -RunAsAdministrator

Get-DHCPServerV4Scope | ForEach-Object {

    Get-DHCPServerv4Lease -ScopeID $_.ScopeID | Where-Object {$_.AddressState -like '*Reservation'}

} | Select-Object ScopeId,IPAddress,HostName,ClientID,AddressState | Export-Csv "C:\$($env:COMPUTERNAME)-Reservations.csv" -NoTypeInformation