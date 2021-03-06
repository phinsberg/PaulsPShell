#Defaults
$Answer="y"
$Time = Read-Host "Time in minutes" 
$Time=[int]$Time
$Time = $Time * 60 * 1000
Write-Host "timing for " ($Time/1000) " Seconds"


function Set-Wallpaper
{
    param(
        [Parameter(Mandatory=$true)]
        $Path,
        
        [ValidateSet('Center', 'Stretch')]
        $Style = 'Stretch'
    )
    
    Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
public enum Style : int
{
Center, Stretch
}
public class Setter {
public const int SetDesktopWallpaper = 20;
public const int UpdateIniFile = 0x01;
public const int SendWinIniChange = 0x02;
[DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
public static void SetWallpaper ( string path, Wallpaper.Style style ) {
SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
switch( style )
{
case Style.Stretch :
key.SetValue(@"WallpaperStyle", "2") ; 
key.SetValue(@"TileWallpaper", "0") ;
break;
case Style.Center :
key.SetValue(@"WallpaperStyle", "1") ; 
key.SetValue(@"TileWallpaper", "0") ; 
break;
}
key.Close();
}
}
}
"@
    
    [Wallpaper.Setter]::SetWallpaper( $Path, $Style )
}

#Main Loop 

If ($Time -gt 0 ) {
while ($Answer -eq "y")
    {
		# Display countdown
		[System.Threading.Thread]::Sleep($Time)
		Set-Wallpaper "C:\Windows\Web\Wallpaper\Dell\Win7 Red 1920x1200.jpg"
		if ((Get-Date -DisplayHint Time) -gt "4:00:00 PM" ) {$Answer = "n"}
		[System.Threading.Thread]::Sleep(10000)
		#$Answer = read-host "Time Again? (y/n)" 
		Set-Wallpaper "C:\Windows\Web\Wallpaper\Dell\Win7 Chrome 1920x1200.jpg"
	}
} 

	