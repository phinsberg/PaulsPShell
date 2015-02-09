Get-Mailbox -ResultSize Unlimited |  select DisplayName, Alias |export-csv C:\scripts\stats.csv  
$csv = Import-csv -path "C:\scripts\stats.csv"  
foreach($line in $csv)  
{   
    $result = $Line.Alias  
    $Emailadd = Get-Mailbox $Line.Alias |select emailaddresses  
    $K = $Emailadd.EmailAddresses  
  
     foreach ($S in $K)  
     {  
          If (($S.smtpaddress -like "*astang*") -or ($S.smtpaddress -like "*astang*"))  
          {  
               $result = $result + "," + $S.smtpaddress  
          }  
     }  
     $result | Out-File C:\scripts\Result_output.csv -Append  
  
} 