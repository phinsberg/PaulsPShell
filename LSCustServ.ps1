# ==============================================================================================
# 
# Microsoft PowerShell Source File 
# 
# NAME: LSCustServ.ps1
# LOCATION: c:\scripts\
# 
# AUTHOR: Paul Hinsberg 
# DATE  : 3/1/2010 
# 
# COMMENT: 	The script reads a file that contains the user names, emails, and a column for the 
#           add or delete. The script then performs the action and if added, puts the contact in 
#           the group Customer Service International group 
# ==============================================================================================

(Get-Content -path c:\scripts\CSGLOBAL.csv)|foreach {

	$Username, $emailad, $add_del = $_.Split(",")

    $First, $Last = $Username.Split(" ") 
    $Last = $Last -replace '\s'
    $emailad = $emailad -replace '\s'
    $Alias = $Username -replace '\s'
    
    $eamilad = 'SMTP:'+ $emailad
    write-host $add_del -eq "add"
	If ($add_del -eq "add") 
	{ 
	      Write-Host New-MailContact -ExternalEmailAddress $emailad -Name $Username -Alias $Alias -OrganizationalUnit 'pensoft.local/Oakland/Contacts' -FirstName $First -Initials '' -LastName $Last
          New-MailContact -ExternalEmailAddress $emailad -Name $Username -Alias $Alias -OrganizationalUnit 'pensoft.local/Oakland/Contacts' -FirstName $First -Initials '' -LastName $Last
          Add-DistributionGroupMember -Identity "Customer Service Employees - International" -Member $emailad
 	} 
	Else 
    { 
        
        Remove-MailContact -Identity $emailad -DomainController gallardo.pensoft.local -Confirm:$false 
	}
	
} #foreach loop end


