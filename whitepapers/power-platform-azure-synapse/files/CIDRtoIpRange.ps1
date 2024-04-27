param(
    [Parameter(Mandatory=$True, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $IPAddressJsonFilePath,

    [Parameter(Mandatory=$True, Position=1, ValueFromPipeline=$false)]
    [System.String]
    $ServiceTagName
)


# https://blog.tyang.org/2011/05/01/powershell-functions-get-ipv4-network-start-and-end-address/
Function Get-IPV4NetworkStartIP ($strNetwork)
{
    $StrNetworkAddress = ($strNetwork.split("/"))[0]
    [int]$NetworkLength = ($strNetwork.split("/"))[1]
    $NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
    [Array]::Reverse($NetworkIP)
    $NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address

    if ($NetworkLength -lt 32)
    {
        $StartIP = $NetworkIP +1
    }
    else
    {
        $StartIP = $NetworkIP
    }

    #Convert To Double
    If (($StartIP.Gettype()).Name -ine "double")
    {
        $StartIP = [Convert]::ToDouble($StartIP)
    }

    $StartIP = [System.Net.IPAddress]$StartIP
    Return $StartIP
}

# https://blog.tyang.org/2011/05/01/powershell-functions-get-ipv4-network-start-and-end-address/
Function Get-IPV4NetworkEndIP ($strNetwork)
{
    $StrNetworkAddress = ($strNetwork.split("/"))[0]
    [int]$NetworkLength = ($strNetwork.split("/"))[1]
    $IPLength = 32-$NetworkLength
    $NumberOfIPs = ([System.Math]::Pow(2, $IPLength)) -1
    $NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
    [Array]::Reverse($NetworkIP)
    $NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
    $EndIP = $NetworkIP + $NumberOfIPs
    If (($EndIP.Gettype()).Name -ine "double")
    {
        $EndIP = [Convert]::ToDouble($EndIP)
    }
    $EndIP = [System.Net.IPAddress]$EndIP
    Return $EndIP
}

# Determine if an IP Address is IPv4
Function IsIPv4 ($strIpAddress)
{
    $ip = [IpAddress]$strIpAddress

    Return $ip.AddressFamily -eq "InterNetwork"
}
# Determine if an IP Address is IPv4
Function IsIPv6 ($strIpAddress)
{
    $ip = [IpAddress]$strIpAddress

    Return $ip.AddressFamily -eq "InterNetworkV6"
}

#https://www.powershellgallery.com/packages/PoshFunctions/2.2.3/Content/Functions%5CExpand-IPv6.ps1

function Expand-IPV6 {
<#
.SYNOPSIS
    Takes an abbreviated IPv6 string and expands it fully
.DESCRIPTION
    Takes an abbreviated IPv6 string and expands it fully
.PARAMETER IPv6
    A string parameter that represents an IPv6 address. Aliased to 'Address'
.PARAMETER IncludeInput
    Switch that will display the input parameter along with the result
.EXAMPLE
    Expand-IPV6 'fe98::726d:daad:2afc:5393%18'
 
    Would return:
    FE98:0000:0000:0000:726D:DAAD:2AFC:0000
.EXAMPLE
    Expand-IPV6 'fe98::726d:daad:2afc:5393'
 
    Would return:
    FE98:0000:0000:0000:726D:DAAD:2AFC:5393
.EXAMPLE
    Expand-IPV6 -IPv6 '::1'
 
    Would return:
    0000:0000:0000:0000:0000:0000:0000:0001
.EXAMPLE
    '::1', 'fe98::726d:daad:2afc:5393' | Expand-IPV6 -IncludeInput
 
    OriginalIPv6 ExpandedIPv6
    ------------ ------------
    ::1 0000:0000:0000:0000:0000:0000:0000:0001
    fe98::726d:daad:2afc:5393 FE98:0000:0000:0000:726D:DAAD:2AFC:5393
.NOTES
    Source: https://badflyer.com/powershell-ipv4-to-ipv6/
 
    Changes:
    - added comment help
    - minor formatting changes
    - change IPv6 to string array
    - added IncludeInput parameter
#>

    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments','')]
    param
    (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Address')]
        [string[]] $IPv6,

        [switch] $IncludeInput
    )

    begin {
        Write-Verbose -Message "Starting [$($MyInvocation.Mycommand)]"
    }

    process {
        foreach ($curIPv6 in $IPv6) {
            $count = 0
            $loc = -1
            # Count the number of colons, and keep track of the double colon
            for ($i = 0; $i -lt $curIPv6.Length; $i++) {
                if ($curIPv6[$i] -eq ':') {
                    $count++
                    if (($i - 1) -ge 0 -and $curIPv6[$i - 1] -eq ':') {
                        $loc = $i
                    }
                }
            }
            # If we didnt find a double colon and the count isn't 7, then throw an exception
            if ($loc -lt 0 -and $count -ne 7) {
                throw 'Invalid IPv6 Address'
            }
            # Add in any missing colons if we had a double
            $cleaned = $curIPv6
            if ($count -lt 7) {
                $cleaned = $curIPv6.Substring(0, $loc) + (':' * (7 - $count)) + $curIPv6.Substring($loc)
            }
            # Parse current values in fill in new IP with hex numbers padded to 4 digits
            $result = @()
            foreach ($splt in $cleaned -split ':') {
                $val = 0
                $r = [int]::TryParse($splt, [System.Globalization.NumberStyles]::HexNumber, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$val)
                $result += ('{0:X4}' -f $val)
            }
            $result = $result -join ':'
            if ($IncludeInput) {
                New-Object -TypeName psobject -Property ([ordered] @{
                    OriginalIPv6 = $curIPv6
                    ExpandedIPv6 = $result
                })
            } else {
                Write-Output -InputObject $result
            }
        }
    }

    end {
        Write-Verbose -Message "Ending [$($MyInvocation.Mycommand)]"
    }
}

# https://stackoverflow.com/questions/75533520/how-to-convert-ip-number-to-ipv6-using-powershell/75535232#75535232
function Convert-NumberToIPv6
{
    param(
        [Parameter(Mandatory=$true)][bigInt]$ipv6Decimal
    )
     
    $ipv6Bytes = $ipv6Decimal.ToByteArray()
    # pad to 16 bytes
    [Array]::Resize([ref]$ipv6Bytes, 16)

    # reverse the bytes
    [Array]::Reverse($ipv6Bytes)
    
    # provide a scope identifier to prevent "cannot find overload error"
    $ipAddress = New-Object Net.IPAddress($ipv6Bytes, 0)
    $ipAddress
}

Function GetNetworkAddress($strIpAddressRange)
{
    Return ($strIpAddressRange.split("/"))[0]
}

$myJson = Get-Content $IPAddressJsonFilePath -Raw | ConvertFrom-Json 

$ranges = $myJson.values | where {$_.id -eq $ServiceTagName}

write-Output "IP Ranges for $ServiceTagName below =>"
write-Output ""

$count = 1

foreach($range in $ranges.properties.addressPrefixes)
{
    $networkAddress = GetNetworkAddress($range)

    If (IsIPv4($networkAddress) -eq $True)
    {
        $start = Get-IPV4NetworkStartIP($range)
        $end = Get-IPV4NetworkEndIP($range)
    
        Write-Output ($start.IPAddressToString + " : " + $end.IPAddressToString)
    }
    elseif (IsIPv6($networkAddress) -eq $True) 
    {
        $startIp = ($range -split '/')[0]

        $startIpAddress = [System.Net.IPAddress]::Parse($startIP)
        $startIpBytes = [System.Net.IPAddress]::Parse($startIP).GetAddressBytes()
        [System.Array]::Reverse($startIpBytes)
        $startIpAsInt = [bigint]$startIpBytes
        
        # CIDR Range
        $cidrRange = [bigint]([math]::pow(2, (128 - ($range -split '/')[1])))
    
        [bigint]$endIpAsInt = $startIpAsInt + $cidrRange - 1
    
        $endIpAddress = Convert-NumberToIPv6 $endIpAsInt
    
        $expandedStartIpAddress = (Expand-IPV6 $startIpAddress.IPAddressToString).ToLower()
        $expandedEndIpAddress = (Expand-IPV6 $endIpAddress.IPAddressToString).ToLower()
    
        Write-Output ($expandedStartIpAddress + " : " + $expandedEndIpAddress)
    }

    $count = $count + 1
}


write-Output ""
write-Output "Sample Storage Account PowerShell Script =>"
write-Output ""
write-Output "`$storageAccountName = `"INSET_NAME_HERE`""
write-Output "`$resourceGroupName = `"INSET_NAME_HERE`""

foreach($range in $ranges.properties.addressPrefixes)
{
    $networkAddress = GetNetworkAddress($range)

    If (IsIPv4($networkAddress) -eq $True)
    {
        $newRange = $range -replace "/32"
    }
    elseif (IsIPv6($networkAddress) -eq $True) 
    {
        $newRange = $range -replace "/128"
    }

    Write-Output ("Add-AzStorageAccountNetworkRule -ResourceGroupName `$resourceGroupName -Name `$storageAccountName -IPAddressOrRange " + $newRange)
}

write-Output ""
write-Output "Sample Azure Synapse PowerShell Script =>"
write-Output ""
write-Output "`$synapseWorkspaceName = `"INSET_NAME_HERE`""

$count = 1

foreach($range in $ranges.properties.addressPrefixes)
{
    $networkAddress = GetNetworkAddress($range)
    
    If (IsIPv4($networkAddress) -eq $True)
    {
        $start = Get-IPV4NetworkStartIP($range)
        $end = Get-IPV4NetworkEndIP($range)
    }
    elseif (IsIPv6($networkAddress) -eq $True) 
    {
        $startIp = ($range -split '/')[0]

        $startIpAddress = [System.Net.IPAddress]::Parse($startIP)
        $startIpBytes = [System.Net.IPAddress]::Parse($startIP).GetAddressBytes()
        [System.Array]::Reverse($startIpBytes)
        $startIpAsInt = [bigint]$startIpBytes
        
        # CIDR Range
        $cidrRange = [bigint]([math]::pow(2, (128 - ($range -split '/')[1])))
    
        [bigint]$endIpAsInt = $startIpAsInt + $cidrRange - 1
    
        $endIpAddress = Convert-NumberToIPv6 $endIpAsInt
    
        $start = (Expand-IPV6 $startIpAddress.IPAddressToString).ToLower()
        $end = (Expand-IPV6 $endIpAddress.IPAddressToString).ToLower()
    }

    $name = ($ServiceTagName + "-" + $count)

    Write-Output ("New-AzSynapseFirewallRule -WorkspaceName `$synapseWorkspaceName -Name $name -StartIpAddress `"$start`" -EndIpAddress `"$end`"")

    $count = $count + 1
}