
$shell = new-object –com Shell.Application
$windows = $shell.Windows()
write-output ($windows.count.ToString() + " windows found")foreach ($window in $windows) {  if ($window.FullName -like "*iexplore*") {    write-output ($window.LocationURL + ", " + $window.LocationName)  }}

$shell = $null