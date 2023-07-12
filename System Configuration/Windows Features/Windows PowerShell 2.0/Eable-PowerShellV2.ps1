#Requires -RunAsAdmin

Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2* | Enable-WindowsOptionalFeature -Online