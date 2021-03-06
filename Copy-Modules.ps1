Function Get-OperatingSystemVersion
{
 (Get-WmiObject -Class Win32_OperatingSystem).Version
} #end Get-OperatingSystemVersion

Function Test-ModulePath
{
 $VistaPath = "$env:userProfile\documents\WindowsPowerShell\Modules"
 $XPPath =  "$env:Userprofile\my documents\WindowsPowerShell\Modules" 
 if ([int](Get-OperatingSystemVersion).substring(0,1) -ge 6) 
   { 
     if(-not(Test-Path -path $VistaPath))
       {
         New-Item -Path $VistaPath -itemtype directory | Out-Null
       } #end if
   } #end if
 Else 
   {  
     if(-not(Test-Path -path $XPPath))
       {
         New-Item -path $XPPath -itemtype directory | Out-Null
       } #end if
   } #end else
} #end Test-ModulePath

Function Copy-Module ([string]$name,[string]$directory)
{
 $UserPath = $env:PSModulePath.split(";")[0]
 $ModulePath = Join-Path -path $userPath `
               -childpath (Get-Item -path $name).basename
 New-Item -path $ModulePath -itemtype directory | Out-Null
 Copy-item -path $name -destination $ModulePath | Out-Null
 $name2=$directory + "\*.ps1xml"
 Write-host Filename: $name2
 Write-host Modulename: $ModulePath
 Copy-item -path $name2 -destination $ModulePath | Out-Null 
 }

# *** Entry Point to Script *** 
Test-ModulePath
Get-ChildItem -Path C:\scripts\PSCX -Include *.psm1,*.psd1 -Recurse |
Foreach-Object { Copy-Module -name $_.fullName -directory $_.DirectoryName}
