$location=convert-path(Get-Location)

write-host $location

(Get-Content -Path $location\servers.txt) | Doit
Function Doit {
	[CmdletBinding()]
	Param( 
	[Parameter( 
		Mandatory=$true,
		ValueFromPipeline=$true)][String[]]$computer)
	
	(Get-Content -path $location\members.txt)|foreach $_ {
   
			$account = $_
 
			Write-Host "Search and destroy: " + $account 
			Write-host $location "\DelProf2.exe /c:\\"$computer" /id:"$account"* /i /u >> $location\DelProf.log"
		
	} #foreach members
	} #End Function 
