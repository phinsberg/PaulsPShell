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

set-content c:\scripts\test.txt (get-date)
(Get-Content -path c:\scripts\psoft\servers.txt)|foreach {
$Servername, $MemMB = $_.Split(",")

Add-Content c:\scripts\test.txt -value $Servername
}

	