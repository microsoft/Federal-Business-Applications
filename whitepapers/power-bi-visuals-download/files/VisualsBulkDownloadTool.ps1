# Created by Steve Winward
#
# This script will download all Power BI visuals from the marketplace and save them
# to a downloads subfolder in the current working directory.
# 
# You can optionally specify the -CertifiedOnly switch to only download visuals
# that have gone through the certification process.
#
# You can optionally specify the -MicrosoftOnly switch to download visuals that
# are created by Microsoft
param (
    [switch]$CertifiedOnly = $false,
    [switch]$MicrosoftOnly = $false,
    [int] $RetryCount = 3,
    [int] $TimeoutInSecs = 30
)

# Reusing Retry-Command from Ridicurious's blog
# https://ridicurious.com/2019/02/01/retry-command-in-powershell/
function Invoke-RetryCommand {
    [CmdletBinding()]
    param (
        [parameter(Mandatory, ValueFromPipeline)] 
        [ValidateNotNullOrEmpty()]
        [scriptblock] $ScriptBlock,
        [string] $SuccessMessage = "Command executed successfuly!",
        [string] $FailureMessage = "Failed to execute the command"
        )        

    process {
        $Attempt = 1
        $Flag = $true      
        do {
            try {
                $PreviousPreference = $ErrorActionPreference
                $ErrorActionPreference = 'Stop'
                Invoke-Command -ScriptBlock $ScriptBlock -OutVariable Result          
                $ErrorActionPreference = $PreviousPreference

                # flow control will execute the next line only if the command in the scriptblock executed without any errors
                # if an error is thrown, flow control will go to the 'catch' block
                Write-Verbose "$SuccessMessage `n"

                $Flag = $false
            }
            catch {
                if ($Attempt -gt $RetryCount) {
                    Write-Verbose "$FailureMessage! Total retry attempts: $RetryCount"
                    Write-Verbose "[Error Message] $($_.exception.message) `n"

                    $Flag = $false
                }
                else {
                    Write-Verbose "[$Attempt/$RetryCount] $FailureMessage. Retrying in $TimeoutInSecs seconds..."
                    Start-Sleep -Seconds $TimeoutInSecs

                    $Attempt = $Attempt + 1
                }
            }
        }

        While ($Flag)
    }
}
# End Ridicurious Retry-Command function

# For debugging purposes, output the OS Version information
Write-Host "OS Version Information"
[System.Environment]::OSVersion
Write-Host ""

# Determing if this is running on a "Legacy Windows OS", anything before Windows 8
$LegacyWindowsOS = $false
if([System.Environment]::OSVersion.Version.Major -lt 10){
    $LegacyWindowsOS = $true
}

# Forcing TLS 1.2 for all web requests in this script
# https://stackoverflow.com/questions/41618766/powershell-invoke-webrequest-fails-with-ssl-tls-secure-channel
# This only needs to be set for Windows 8 and older client operating systems.
if($LegacyWindowsOS){
    Write-Host "Forcing TLS 1.2 for Windows 8 and older clients"
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Write-Host ""
}

# Create the downloads path as a subdirectory to the current working directory of the script
$downloadFolder = Join-Path (Get-Location) 'downloads'

# Create the downloads folder if it doesn't already exist
if(-not (Test-Path $downloadFolder)){
    Write-Host "$downloadFolder does not exist"
    Write-Host "Creating $downloadFolder"
    
    New-Item -Path $downloadFolder -ItemType Directory
}

# This is the REST call to get all of the list of all Power BI visuals from the marketplace
$url = 'https://store.office.com/api/addins/search?ad=US&apiversion=1.0&client=Any_PowerBI&top=1000'

# Execute the REST call and parse the results into JSON
Write-Host "Attempting to download the list of all Power BI visuals"

# Construct the Headers for the web request
# If you don't specify a language, no results will be returned
$headers = @{'Accept-Language' = 'en-US'}

# Wrap the download call in a Invoke-RetryCommand to try and recover from transient errors
# NOTE: We have to specify the UseBasicParsing switch for legacy Windows OS's
# https://stackoverflow.com/questions/38005341/the-response-content-cannot-be-parsed-because-the-internet-explorer-engine-is-no
$json = Invoke-RetryCommand -ScriptBlock { 
        Invoke-WebRequest $url -UseBasicParsing:$LegacyWindowsOS -Headers $headers | ConvertFrom-Json 
    }.GetNewClosure() -Verbose

# loop over all results
$json.Values | ForEach-Object {
    # if the CertifiedOnly switch was specified, skip any visuals that are not certified
    if($CertifiedOnly){
        # Check the categories attributes to see if "Power BI Certified" exists
        $containsCertified = $_.Categories | Where-Object {$_.Id -eq 'Power BI Certified'}

        # If it is not certified, skip this visual and go to the next one
        if($containsCertified -eq $null){
            return
        }
    }

    # Download the manifest xml file
    [xml]$xml = (New-Object System.Net.WebClient).DownloadString($_.ManifestUrl)

    # Filter out Microsoft only created visuals if specified
    if($MicrosoftOnly){
        if($xml.OfficeApp.ProviderName -ne "Microsoft"){
            return
        }
    }

    # find the download url for the pbiviz file
    $fileUrl = $xml.OfficeApp.DefaultSettings.SourceLocation.DefaultValue

    # parse the visual file name
    $visualName = $fileUrl.split('/')[-1]

    # print the visual name
    Write-Host "Attempting to download the visual: $visualName"

    # create the destination path
    $destFilePath = Join-Path $downloadFolder $visualName

    # download and save the pbiviz file to the downloads subfolder
    $wc = New-Object System.Net.WebClient

    # Wrap the download call in a Invoke-RetryCommand to try and recover from transient errors
    Invoke-RetryCommand -ScriptBlock {$wc.DownloadFile($fileUrl, $destFilePath)} -Verbose
}