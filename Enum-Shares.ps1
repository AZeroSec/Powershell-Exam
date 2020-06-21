


function Invoke-Enum-Share

<#

.SYNOPSIS
Enumerate all open shares in a Domain network

.DESCRIPTION

using Active Directory Module for Windows PowerShell to get all computer names then enumrate shares for write & read permission 
Need powershell version 5 for get-smbshare & Get-SmbShareAccess
     
.EXAMPLE

PS C:\>. .\Invoke-Enum-Share
PS C:\>Invoke-Enum-Share -permssion Read -Identity "test\testadmin"


.LINK
https://docs.microsoft.com/en-us/powershell/module/smbshare/get-smbshare
https://docs.microsoft.com/en-us/powershell/module/smbshare/get-smbshareaccess
https://adamtheautomator.com/powershell-file-shares/



.NOTES

Student ID : NONE
This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/


#> 




{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, Position = 0)]
        [ValidateSet('Write','Read','all')]
        [string]
        $permssion,

        [Parameter(Mandatory=$false, Position=1)]
        [string]
        #user or group to check shares permission for it
        $Identity = "BUILTIN\Administrators"

    )

    #using Active Directory Module for Windows PowerShell to get all computer names
    $servers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
    
    #executing get-smbshare | Get-SmbShareAccess in all computes in domain in order to get shares permission for Identity (user or group )
    $share = Invoke-Command -ComputerName $servers -ScriptBlock {Get-SmbShare | Get-SmbShareAccess} | Where-Object{$_.AccountName -eq $Identity}

    #if AccessRight is Write or change or full and the Parameter permssion value is write print all shares that the Identity can write
    if(($share.AccessRight -eq 'Write' -or $share.AccessRight -eq 'Full' -or $share.AccessRight -eq 'Change' ) -and $permssion -eq 'Write')
    {
        
        write-host "=============== Write | Full ==============="
        $share | Format-Table -Property Name,AccountName,PSComputerName,AccessRight
    }

    #if AccessRight is Read or full and the Parameter permssion value is Read print all shares that the Identity can Read
    if(($share.AccessRight -eq 'Read' -or $share.AccessRight -eq 'Full') -and $permssion -eq 'Read' )
    {
        
        write-host "=============== Read | Full ==============="
        $share | Format-Table -Property Name,AccountName,PSComputerName,AccessRight
    }

    #if the Parameter permssion value is all print all shares for Identity either write or read or any permssion
    if($permssion -eq 'all')
    {
        write-host "=============== ALL ==============="
        $share | Format-Table -Property Name,AccountName,PSComputerName,AccessRight
    }


}