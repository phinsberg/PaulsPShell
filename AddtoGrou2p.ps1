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

    
	 $emailad = $_

	
		write-host $emailad
	    #New-MailContact -ExternalEmailAddress $emailad -Name $Username -Alias $Alias -OrganizationalUnit 'pensoft.local/Oakland/Contacts' -FirstName $First -Initials '' -LastName $Last	
	    #  start-Sleep -s 10
	    Add-DistributionGroupMember -Identity "LS_Major_Investors" -Member $emailad
 	
	
} #foreach loop end

