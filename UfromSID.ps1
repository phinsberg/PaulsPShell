$SID = Read-Host "Enter SID: "
$objSID = New-Object System.Security.Principal.SecurityIdentifier ( $SID )
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount] )
$objUser = $objSID.Translate([System.Security.Principal.NTAccount])
write-host $objUser.Value
