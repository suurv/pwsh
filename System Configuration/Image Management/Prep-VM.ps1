# Clear cached updates
Get-ChildItem C:\Windows\SoftwareDistribution\Download | `
    ForEach-Object { Remove-Item -LiteralPath $_.FullName -Recurse -Force}

# Clear the Panther dir so the vm will have no setup logs
Remove-Item C:\Windows\Panther -Force -Recurse

# Set the CD/DVD-ROM to auto start otherwise the image will not boot
Set-Location -Path HKLM:
Set-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\cdrom `
    -Name Start `
    -Value 1 -Force

# https://learn.microsoft.com/en-us/azure/virtual-machines/generalize#windows
# Change the working dir to $env:windir\system32\sysprep
Set-Location -Path $env:windir\system32\sysprep
.\sysprep.exe /oobe /generalize /shutdown