#Requires -RunasAdministrator

Get-WindowsOptionalFeature -Online -FeatureName NetFx3 | Enable-WindowsOptionalFeature -Online