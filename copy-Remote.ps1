function Invoke-PSRemotingCopy{

<#

.SYNOPSIS
Transfer files over PowerShell Remoting
need powershell 5 for 

.DESCRIPTION

Transfer files over PowerShell Remoting
     
.EXAMPLE

PS C:\> . .\Invoke-PSRemotingCopy
PS C:\> Invoke-PSRemotingCopy -LocalPath c:\test.txt -ComputerName testme\testadmin -DestnationPath c:\Windows\temp\test.txt


.LINK
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/copy-item
https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/new-pssessionoption?view=powershell-7



.NOTES

Student ID : NONE
This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/


#> 






    [CmdletBinding()]
    param(
    
    [Parameter(Mandatory=$true,Position=0)]
    [string]
    $LocalPath,

    [Parameter(Mandatory=$true,Position=1)]
    [string]
    $DestnationPath,

    [Parameter(Mandatory=$true,Position=2)]
    [string]
    $ComputerName


    
    )    


    #Creates an object that contains advanced options for a PSSession
    $sessionOn = New-PsSessionOption

    #Gets a credential object based on a user name and password from user
    $creds = Get-Credential

    #Start new session with target and supply crds and session option
    $Dsession = New-PSSession -ComputerName $ComputerName  -Credential $creds  -SessionOption $sessionOn

    #Copy file to target we can use sessionoption -ToSession
    Copy-Item $LocalPath -Destination $DestnationPath -ToSession $Dsession

}