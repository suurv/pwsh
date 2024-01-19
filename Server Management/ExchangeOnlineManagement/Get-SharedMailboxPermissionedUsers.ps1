#Requires -Modules ExchangeOnlineManagement
#Requires -RunAsAdministrator
param (
	[string]
	$OutFile = "$env:USERPROFILE\Documents\SharedMailbox-Permissioned-Users.txt"
)

Connect-ExchangeOnline

Get-EXOMailbox -RecipientTypeDetails SharedMailbox | Sort-Object DisplayName | ForEach-Object {

	"# $($_.DisplayName), $($_.PrimarySmtpAddress)`n---`n" | Tee-Object -FilePath $OutFile -Append

	Get-EXOMailboxPermission -Identity $_.GUID | Sort-Object Name | ForEach-Object {
		if ($_.User -ne "NT AUTHORITY\SELF")
		{
			$_.User + " Premissions: " + $_.AccessRights | Tee-Object -FilePath $OutFile -Append
		}
	}

	"`n" | Tee-Object -FilePath $OutFile -Append
}

Disconnect-ExchangeOnline -Confirm:$false
