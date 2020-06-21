


function Invoke-Enum-Sys32

<#

.SYNOPSIS
Enumerate directories inside C:\Windows\System32 or any directory which are writable by Identity Default (BUILTIN\Users).

.DESCRIPTION

Enumerate directories inside C:\Windows\System32 or any directory which are writable by Identity Default (BUILTIN\Users).
     
.EXAMPLE

PS C:\>. .\Invoke-Enum-Sys32

PS C:\>Invoke-Enum-Sys32 -Identity "BUILTIN\Users"


.LINK
https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-list-only-directories/



.NOTES

Student ID : NONE
This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/


#> 











{
    [CmdletBinding()]
    param
    (
    [Parameter (Mandatory=$false, Position = 0)]
    [string]
    $DirPath = "c:\Windows\System32\",
    [Parameter (Mandatory=$false, Position = 1)]
    [string]
    # account name as (DESKTOP-XXXX\username) or group As (BUILTIN\Users)
    $Identity = "BUILTIN\Users"



    )
    
    #get all directories inside c:\system32\ and throw error to $null  
    $Dirs = Get-ChildItem -Path $DirPath -Recurse -Directory 2>$null

    #loop for every dir
    foreach ($Dir in $Dirs)
        {

        #get the access control list (acl)  for the dir in order to filter it
        $Acls = (Get-Acl -Path $Dir.FullName)

        #loop for every acl regarding Access
        foreach ($Acl in $Acls.Access)
        {
            #check for Identity (user or group) in order to check the rules or permissions for the (user or group)
            if ($Acl.IdentityReference -eq $Identity)
            {
                #check for Identity (user or group) Rights for writing 
                # I add the ( Write, Synchronize ) condition becasue when i tested my script and gave a user permission to write, it appered AS (Write, Synchronize) not As (Write) to be honest i still dont know why ?
                if ($Acl.FileSystemRights -eq "Write, Synchronize" -or $Acl.FileSystemRights -eq "FullControl" -or $Acl.FileSystemRights -eq "Write")
                {
                    #print the Writable Directory path 
                    write-host -ForegroundColor Green "[+] Found Writable Directory :  " + $Dir.FullName 

                }
            }
           

        }
        
 
       
        }





    




} 