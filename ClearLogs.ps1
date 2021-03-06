#
# ClearLogs.ps1 
# 
# Paul Hinsberg, 11/18/2013
# 
# 
# Deletes files in a folder older than a number of days 
# 
# Paramaters: 
#   
#  Source folder - eg d:\scripts\hold 
#  Destination folder of particular copy  - eg d:\Scripts\testlist\SavedCopy.txt
#  Days to save - eg 4
# 
# Modified to also copy the current file to a particular location for backup
# 

If ( $args.count -eq 3 ) { 

$PathName = $args[0]
$BackupPath = $args[1]
$DaystoKeep = $args[2] 



$Files = Get-ChildItem $PathName 
foreach($file in $Files)
    {
		$y = ((Get-Date) - $file.LastWriteTime).Days
		if ($y -eq 0 ) { 
			Copy-Item $PathName\$file $BackupPath -Force
		}
        if ($y -gt $DaystoKeep) { 
            $file.Delete() 
			}
	}
 }
 else { 
 Write-Host No agruments provided. 
 }
 
 