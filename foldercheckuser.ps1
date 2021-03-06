
#foldercheckuser.ps1
#Paul Hinsberg, 5/2/2014 
#
#
# Scans a folder and uses the names to look up associated accounts.  It checks to see if the account exists and if it exists 
# checks to see if it is disabled. 
# 
# 
# Requirements:  Powershell 2.0 ,   AD modules (import-module ActiveDirectory) 
# 
# 
#change the folder name below in the -Path to switch to another folder
#the folders name is expected to match their NetID 

Import-Module ActiveDirectory

foreach ($name in (Get-ChildItem -Path \\xen\users -Name)) { 

$userexist=$true

Try {
	$account = Get-ADUser $name -ErrorAction SilentlyContinue
} Catch {
		$userexist = $false
} 
	
If ($userexist)
	{
		if ($account.Enabled -eq $False) 
			{
			Write-Host $account.Name " : " $account.SamAccountName " : " $account.Enabled 
			}
	}
Else 
	{ 
	Write-host $name " No account found " 
	}	
}
	

