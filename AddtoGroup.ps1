# ==============================================================================================
# 
# Microsoft PowerShell Source File 
# 
# NAME: LSCommunity.ps1
# LOCATION: c:\scripts\
# 
# AUTHOR: Paul Hinsberg 
# DATE  : 3/1/2010 
# 
# COMMENT: 	The script reads a file that contains the user names, emails, and a column for the 
#           add or delete. The script then performs the action and if added, puts the contact in 
#           the group livescribe-global
# ==============================================================================================

(Get-Content -path c:\scripts\members.txt)|foreach $_ {

    '$Username, $emailad, $add_del = $_.Split(",")
    '$First, $Last = $Username.Split(" ") 
    '$Last = $Last -replace '\s'
    $emailad = $emailad -replace '\s'
    '$Alias = $Username -replace '\s'
    
	
		write-host $First, $Last, $emailad, $Alias  
	   ' New-MailContact -ExternalEmailAddress $emailad -Name $Username -Alias $Alias -OrganizationalUnit 'pensoft.local/Oakland/Contacts' -FirstName $First -Initials '' -LastName $Last	
	   '   start-Sleep -s 10
	    Add-DistributionGroupMember -Identity "Eng-HW" -Member $emailad
 	
	
} #foreach loop end

