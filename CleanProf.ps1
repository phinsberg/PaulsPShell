Get-ChildItem '\\xen\citrixpm65$' | ForEach-Object { 
#Get-ChildItem 'e:\users' | ForEach-Object { 
if ($_.name -gt "n") { 
	write-host "I will delete" 
	$folder = $_.name.Trim()
	$folder = "\\xen\citrixpm65$\"+$folder+"\UPM_Profile"
	#$folder = "e:\users\"+$folder+"\UPM_Profile"
	#Write-Host $folder"\AppData\Local"
	#Write-Host $folder"\AppData\LocalLow"
	#Write-Host
	Remove-Item $folder"\AppData\Local" -Force -Recurse
	Remove-Item $folder"\AppData\LocalLow" -Force -Recurse
} 
}