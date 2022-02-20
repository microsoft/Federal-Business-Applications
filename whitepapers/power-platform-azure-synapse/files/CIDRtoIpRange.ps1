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

$myJson = Get-Content $IPAddressJsonFilePath -Raw | ConvertFrom-Json 

$ranges = $myJson.values | where {$_.id -eq $ServiceTagName}

write-Output "IP Ranges for $ServiceTagName below =>"
write-Output ""

$count = 1

foreach($range in $ranges.properties.addressPrefixes)
{
    $start = Get-IPV4NetworkStartIP($range)
    $end = Get-IPV4NetworkEndIP($range)

    Write-Output ($start.IPAddressToString + " : " + $end.IPAddressToString)

    $count = $count + 1
}

write-Output ""
write-Output "Sample Storage Account PowerShell Script =>"
write-Output ""
write-Output "`$storageAccountName = `"INSET_NAME_HERE`""
write-Output "`$resourceGroupName = `"INSET_NAME_HERE`""

foreach($range in $ranges.properties.addressPrefixes)
{
    $newRange = $range -replace "/32"

    Write-Output ("Add-AzStorageAccountNetworkRule -ResourceGroupName `$resourceGroupName -Name `$storageAccountName -IPAddressOrRange " + $newRange)
}

write-Output ""
write-Output "Sample Azure Synapse PowerShell Script =>"
write-Output ""
write-Output "`$synapseWorkspaceName = `"INSET_NAME_HERE`""

$count = 1

foreach($range in $ranges.properties.addressPrefixes)
{
    $start = Get-IPV4NetworkStartIP($range)
    $end = Get-IPV4NetworkEndIP($range)

    $name = ($ServiceTagName + "-" + $count)

    Write-Output ("New-AzSynapseFirewallRule -WorkspaceName `$synapseWorkspaceName -Name $name -StartIpAddress `"$start`" -EndIpAddress `"$end`"")

    $count = $count + 1
}