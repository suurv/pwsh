#Requires -Modules ExchangeOnlineManagement
#Requires -RunAsAdministrator
param (
	[string]
	$OutFile = "$env:USERPROFILE\Documents\DistributionGroups-and-Users.md"
)

Connect-ExchangeOnline

Get-DistributionGroup | Sort-Object Name | ForEach-Object {

	"# $($_.DisplayName)`n---`n" | Tee-Object -FilePath $OutFile -Append

	Get-DistributionGroupMember $_.GUID | Sort-Object Name | ForEach-Object {
		if($_.RecipientType -eq "UserMailbox")
		{
			"[" + $_.DisplayName + "](" + $_.PrimarySMTPAddress + ")" | Tee-Object -FilePath $OutFile -Append
		}
	}

	"`n" | Tee-Object -FilePath $OutFile -Append
}

Disconnect-ExchangeOnline -Confirm:$false
