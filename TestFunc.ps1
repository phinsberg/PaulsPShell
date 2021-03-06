$sourcecomputer = (Get-ChildItem -Path env:computername).value 

Function ShutdownEm { 
Write-Host "Shutdownem" 
} 

Function RebootEm { 
Write-Host "RebootEm" 
} 

Function CheckEm { 
Write-Host "checkEm" 
} 

Function StartEm { 
Write-Host "StartEm" 
}

Function HelpExitEm { 
Write-Host "HelpExitEm" 
} 

Write-host "*** On the Menu ***" 
Write-host 
Write-host "1) Shutdown servers in a farm" 
Write-host "2) Reboot servers in a farm" 
Write-host "3) Check on powerstate of servers" 
Write-host "4) Start the servers in a list of" 
Write-host 
Write-host 
	
$a=Read-Host -Prompt "Please enter you select: " 
switch ($a) { 
	1 { ShutdownEm ; break } 
	2 { RebootEm ; break } 
	3 { CheckEm ; break } 
	4 { StartEm ; Break } 
	default { HelpExitEm ; Break } 
} 