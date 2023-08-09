#Requires -RunAsAdministrator

Get-WindowsOptionalFeature -Online -FeatureName Printing-XPSServices-Features | Enable-WindowsOptionalFeature -Online