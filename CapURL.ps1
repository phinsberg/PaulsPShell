
$shell = new-object �com Shell.Application
$windows = $shell.Windows()
write-output ($windows.count.ToString() + " windows found")

$shell = $null