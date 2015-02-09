#**************************************************************************
#DISCLAIMER -
#This script is supplied by SAPIEN Technologies, Inc. as a courtesy to
#users of PrimalScript. This script was not written by nor is it supported 
#by SAPIEN Technologies. 
#
#This script has been placed in the public domain by its original author(s).
#
#SAPIEN Technologies assumes no liability regarding individuals' use of this script. 
#USE AT YOUR OWN RISK!
#**************************************************************************
#FILE INFORMATION -
#NAME:    SearchForAllUsers.ps1
#COMMENT: 
#**************************************************************************
#
Function Ldap 
	{
		$AD=new-object DirectoryServices.DirectoryEntry($args[0]) 
		New-Object DirectoryServices.DirectorySearcher($AD) 
	}

Function EnumGroup 
	{ 
		$Count=$args[1]
		$Space=" " * $Count
		$TempGrp = [ADSI]("LDAP://"+$args[0])
		$Members=$TempGrp.member
		foreach ($Member in $Members) { 
			$User =[ADSI]("LDAP://"+$Member) 
			If ($User.groupType)
				{
				Write-Host `r
				Write-Host $Space $User.name `t $user.displayname `r
				Write-Host "---------------------------------------------------"
				$Count=$args[1]+4
				EnumGroup $User.distinguishedname $Count
				}
			else
				{
				Write-Host $Space $User.name `t $user.displayname `r
				}
			$Count=$Count-4
			}
	}
			

$LDAP="LDAP://user/OU=Applications,DC=user,DC=root,DC=acgov,DC=org"
$searcher=Ldap $LDAP

$searcher.Filter="((objectclass=organizationalunit))"
$OUs=$searcher.FindAll()
Write-Host "There are"$OUs.count"OUs."

foreach ($OU in $OUs) {
 Write-Host $OU.properties.name
}
$APP=Read-Host "Please type the name of the app as it appears above"

$LDAP="LDAP://user/OU=" + $APP + ",OU=Applications,DC=user,DC=root,DC=acgov,DC=org"
$searcher=Ldap $LDAP 
$searcher.Filter="((objectclass=group))" 
$Groups=$searcher.FindAll()

foreach ($Group in $Groups) { 
	Write-Host `r 
	Write-Host "=================================================="
	write-host $Group.properties.name `r
	Write-Host "=================================================="
	EnumGroup $Group.properties.distinguishedname 2
}




	
