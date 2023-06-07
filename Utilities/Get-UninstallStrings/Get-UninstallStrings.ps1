[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [String]
    $ProgramName
)

function Get-UninstallString {
    param (
        [Parameter(Mandatory=$true)]
        [String]
        $Program
    )
    Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, `
        HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall `
        | Get-ItemProperty `
        | Where-Object {$_.DisplayName -imatch "$Program" } `
        | Select-Object -Property DisplayName, UninstallString
}

Get-UninstallString -Program $ProgramName
