param (
    [Parameter(Mandatory=$true)]
    [String]
    $ClientServerName,

    [Parameter()]
    [String]
    $ClientDNSSuffix,

    [Parameter(Mandatory=$true)]
    [String]
    $ClientVPNName,

    [Parameter(Mandatory=$true)]
    [String]
    $ClientPSK
)

Add-VpnConnection -Name $ClientVPNName -ServerAddress $ClientServerName -AllUserConnection -TunnelType "l2tp" -L2tpPsk $ClientPSK -DnsSuffix $ClientDNSSuffix -AuthenticationMethod "pap" -RememberCredential -Force
