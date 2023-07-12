#Requires -RunAsAdmin

Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2* | Disable-WindowsOptionalFeature -Online