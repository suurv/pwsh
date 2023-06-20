#Requires -RunAsAdministrator

$apps = @("messaging",
        "WindowsMaps",
        "Zune",
        # "Xbox", # one part of xbox is part of the system and will throw an error
        # "people", # one part of people is part of the system and will throw an error
        "office",
        "skype",
        "solitaire",
        "getstarted",
        "feedbackhub",
        "yourphone",
        "gethelp",
        "bing",
        "tips")

$AppxPackages = Get-AppxPackage
$AppxProvisioningPackages = Get-AppxProvisionedPackage -Online

foreach ($app in $apps) {
    Write-Output "searching for: *$app*"
    $appxToDelete = $AppxPackages | Where-Object {$_.PackageFamilyName -match $app}
    foreach ($appx in $appxToDelete) {
        Write-Output "deleting: $appx"
        Remove-AppxPackage -Package $appx
    }

    $appAppxProvisionedPackages = $AppxProvisioningPackages | Where-Object {$_.PackageName -Match $app}
    foreach ($appx in $appAppxProvisionedPackages) {
        Write-Output "removing Appx Provisioning Package: $($appx.PackageName)"
        Remove-AppxProvisionedPackage -Online -PackageName $appx.PackageName
    }
}
