# ==============================================================================================
# 
# Microsoft PowerShell Source File -- Created with SAPIEN Technologies PrimalScript 4.1
# 
# NAME: Grapher.ps1 
# LOCATION: \\itdisgws29\c$\scripts\psoft 
# 
# AUTHOR: Paul Hinsberg ITD , Alameda County
# DATE  : 1/24/2007
# 
# COMMENT: 	The script scans the ACCLUS01\pubdata$\Shared Files\Windows CPU_Reports\[month]\[servername]\[day]
#			folder structure for files. It produces graphs using the ExcelAccess.vbs in the same location, 
#			leveraging Excel 2007 as well. The [servername] is collected from a listing of systems in the 
#			servers.txt in the same directory. 
#
#			The script \\us01ap19v3\d$\PeopleSoft\Performance\MONITOR.PS1 collects performance data from the 
#			PeopleSoft systems and relogs the data to the aforementioned share.
# 
# ==============================================================================================

$sourcecomputer = (Get-ChildItem -Path env:computername).value 

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


Function ShutdownEm { 
If (Test-Path c:\Scripts\Serverstoreboot.txt) { 
	Remove-Item -Path c:\Scripts\Serverstoreboot.txt 
}

foreach ($server in (Get-XAServer)) { 
	If ($server -ne $sourcecomputer) { 
		Out-File -FilePath C:\Scripts\Serverstoreboot.txt -inputObject $server.ServerName -Append
	}
}
$servers= Get-content C:\Scripts\Serverstoreboot.txt
$servers
write-host "Number of servers to be SHUTDOWN: " $servers.Length 

$a=Read-Host -Prompt "Shall we continue with the shutdown of these servers? (y/N)" 
If ($a -eq "y") { 
	foreach ($server in (Get-Content -Path C:\Scripts\Serverstoreboot.txt)) { 
		# Stop-Computer -ComputerName $server -Force 
		Write-Host "I would have shutdown " $server 
	} 
	}
else { 
	Write-Host "Nothing more will be done." 
	}
Write-Host "Done processing." 
}

	
# SIG # Begin signature block
# MIIEYQYJKoZIhvcNAQcCoIIEUjCCBE4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUnfB6nZQ2b/zOEfRD5ai7UO2D
# 9gegggJkMIICYDCCAc2gAwIBAgIQ3ORnqB58Nq9INIESdNwikzAJBgUrDgMCHQUA
# MDMxMTAvBgNVBAMTKFBhdWwgSGluc2JlcmcgUG93ZXJzaGVsbCBMb2NhbCBDZXJ0
# IFJvb3QwHhcNMTMwODEzMTgzNTQ3WhcNMzkxMjMxMjM1OTU5WjAzMTEwLwYDVQQD
# EyhQYXVsIEhpbnNiZXJnIFBvd2Vyc2hlbGwgTG9jYWwgQ2VydCBVc2VyMIGfMA0G
# CSqGSIb3DQEBAQUAA4GNADCBiQKBgQCjVUrMggKWi1YZcSXbimnUjLoH67coyfQu
# 0psJ2yt7E0DEIaM1LFVdmULSJmeqC/UMSlHzgQlZG/WFugjKMNT8gVeLZSxzmoNZ
# JJH4HDOFIft7fSk0Oix8YOvnQAlgqFkDppL2be5y1yUl88GMCpyqtldE9DFga1vg
# iBKd/tmqFwIDAQABo30wezATBgNVHSUEDDAKBggrBgEFBQcDAzBkBgNVHQEEXTBb
# gBC0ezOjn4lND2tnWjp3sejAoTUwMzExMC8GA1UEAxMoUGF1bCBIaW5zYmVyZyBQ
# b3dlcnNoZWxsIExvY2FsIENlcnQgUm9vdIIQYJZIydAiOaNFDVWUQFqzjzAJBgUr
# DgMCHQUAA4GBAD84bgPsGtcpZxN6a3Wbbw5Pn2Pvn+ZsBB1IYnT+89WLcgNG94Km
# WV9fBtw9h+8Iuu6l+KEbGVNDxeC1DkYZpmksrOsJQyZh2mBGX1TJHY/9Y5HVRDN2
# HSAM4BuMQUoIGVH5E6udHL6/o76ZmImpqJGi/CpUzC5yFuO3LingzPGpMYIBZzCC
# AWMCAQEwRzAzMTEwLwYDVQQDEyhQYXVsIEhpbnNiZXJnIFBvd2Vyc2hlbGwgTG9j
# YWwgQ2VydCBSb290AhDc5GeoHnw2r0g0gRJ03CKTMAkGBSsOAwIaBQCgeDAYBgor
# BgEEAYI3AgEMMQowCKACgAChAoAAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMCMGCSqGSIb3DQEJBDEWBBRk
# 78V1HvLiWkCrxhVx7hao5lAyYzANBgkqhkiG9w0BAQEFAASBgGWLd37RhoK/qI7C
# 7iP8g5tY4Qy/pvUeNMbwkh9R/F++f6dBBS/IdUvyaP4BGzVSR+dpGgZXtyljDudC
# z7MTuP0H3eJ8J/AMPuQS61fATlstJq4BFboB7fD5gR+S1DR9bMiz6NkC/m3dIIiR
# gE9JJVrQRNa5vFva3FGuG6FXm393
# SIG # End signature block
