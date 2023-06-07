# This project contains a script to retrieve uninstall strings

---


### Example Usages


This is works as either running the file in PowerShell or by eval the fn in ISE and calling the fn with the `-Program` param
```powershell
.\Get-UninstallStrings.ps1 -ProgramName veeam
```


or


```powershell
# after eval
# function Get-UninstallString {...}

Get-UninstallString -Program veeam
```