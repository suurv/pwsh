#Requires -RunAsAdministrator

Get-WindowsOptionalFeature -Online -FeatureName Printing-XPSServices-Features | Disable-WindowsOptionalFeature -Online