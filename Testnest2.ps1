

$location=convert-path(Get-Location)

foreach ($computer in (Get-Content -path $location\members.txt)){
   
		Foreach($account in (Get-Content -Path $location\servers.txt)){
		
		Write-Host "Looking on computer: " $computer 
		Write-Host "Search and destroy: " $account 
		
		}
} #foreach members