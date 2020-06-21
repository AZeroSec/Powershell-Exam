#this code was copied from https://github.com/PFPT3223/PFPT_EXAM/blob/master/Assignment_7.ps1 Thanks to him  I learned a lot from this Assignment *_*.


function Invoke-Web-Server
{

    <#


    .DESCRIPTION
    A cmdlet to launch a simple PowerShell Web Server (Yet Another PowerShell Web Server). Gives the ability to quickly share files in a directory, as well as upload new files and delete existing ones. 
    this code was copied from https://github.com/PFPT3223/PFPT_EXAM/blob/master/Assignment_7.ps1 Thanks to him  I learned a lot from this Assignment *_*.

    .EXAMPLE
    PS C:\> . .\WebServer.ps1
    PS C:\> Invoke-Web-Server

    .LINK
    https://github.com/ahhh/PSSE/blob/master/Run-Simple-WebServer.ps1
    http://obscuresecurity.blogspot.mx/2014/05/dirty-powershell-webserver.html
    https://gist.github.com/wagnerandrade/5424431
    https://github.com/PFPT3223/PFPT_EXAM/blob/master/Assignment_7.ps1

    .NOTES
    this code was copied from https://github.com/PFPT3223/PFPT_EXAM/blob/master/Assignment_7.ps1 Thanks to him  I learned a lot from this Assignment *_*.

    Student ID : NONE
    This blog post has been created for completing the requirements of the SecurityTube PowerShell for Penetration Testers Certification Exam: http://www.securitytube-training.com/onlinecourses/powershell-for-pentesters/
    this code was copied from https://github.com/PFPT3223/PFPT_EXAM/blob/master/Assignment_7.ps1 Thanks to him  I learned a lot from this Assignment *_*.
    #>           



    [CmdletBinding()] Param( 

    [Parameter(Mandatory = $false)]
    [String]
    $WebRoot = ".",

    [Parameter(Mandatory = $false)]
    [String]
    $url = 'http://localhost:8080/'

)

    # Our responses to the various requests
    $routes = @{


      # Lists all files in the WebRoot
      "/list" = { return dir $WebRoot }

      # Download web root specified in the query string EX: http://localhost:8000/download?name=test.txt
      "/download" = { return (Get-Content (Join-Path $WebRoot ($context.Request.QueryString[0]))) }

      # Delete the file from the WebRoot specificed in the query string EX: http://localhost:8000//delete?name=test.txt
      "/delete" = { (rm (Join-Path $WebRoot ($context.Request.QueryString[0])))
                     return "Succesfully deleted" }

      # Creates a file based on the contents of an uploaded file via a get request
      "/upload" = { (Set-Content -Path (Join-Path $WebRoot ($context.Request.QueryString[0])) -Value ($context.Request.QueryString[1]))
                     return "Succesfully uploaded" }
                     
      # Shuts down the webserver remotly
      "/exit" = { exit }
    }
     




    # credits for Wagnerandrade's SimpleWebServer 
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($url)
    $listener.Start()
    
    Write-Host "[-]Listening at $url..." -ForegroundColor Green
     
    try{
      while ($listener.IsListening)
      {
        $context = $listener.GetContext()
        $requestUrl = $context.Request.Url
        $response = $context.Response
       
        Write-Host ''
        Write-Host "> $requestUrl"
       
        $localPath = $requestUrl.LocalPath
        $route = $routes.Get_Item($requestUrl.LocalPath)
       
        if ($route -eq $null) # If a route dosn't exist, we 404
        {
          $response.StatusCode = 404
        }
        else # Else, follow the route and it's returned content
        {
          $content = & $route
          $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
          $response.ContentLength64 = $buffer.Length
          $response.OutputStream.Write($buffer, 0, $buffer.Length)
        }
        
        $response.Close()
        $responseStatus = $response.StatusCode
        Write-Host "< $responseStatus"
      }
    }catch{ }
  }
