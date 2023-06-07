<#
.SYNOPSIS
    Enable or Disable the .NET 3.5 framework
.EXAMPLE
    .\Set-WindowsDotNET35.ps1 -Enable
.EXAMPLE
    .\Set-WindowsDotNET35.ps1 -Disable
#>


param (
    [Parameter(Mandatory = $true,
        ParameterSetName = 'Enable',
        HelpMessage = 'Enable the Windows Feature.',
        Position = 0)]
    [switch]
    $Enable,
    [Parameter(Mandatory = $true,
        ParameterSetName = 'Disable',
        HelpMessage = 'Disable the Windows Feature.',
        Position = 0)]
    [switch]
    $Disable
)

<# If Enable, then Attempt to Enable
 #  If Disabled, then Install
 #  If Enabled, Notify Already Enabled
 #  Else Write-Error
 # Elseif Disable, then Disable
 # Else Error 
 #>
if ($Enable) {
    $NetFx3InitState = (Get-WindowsOptionalFeature -Online -FeatureName NetFx3).State
    
    if (($NetFx3InitState).ToString() -imatch "Disabled") {
            Enable-WindowsOptionalFeature -Online -FeatureName NetFx3
    } elseif (($NetFx3InitState).ToString() -eq "Enabled") {
        Write-Output "Already $NetFx3InitState"
        Write-Information "Already $NetFx3InitState"
    } else {
        Write-Error $NetFx3InitState
    }
} elseif ($Disable) {
    Disable-WindowsOptionalFeature -Online -FeatureName NetFx3
} else {
    Write-Error "Set-WindowsDotNET35.ps1 ___ <-- Valid switch required."
}
