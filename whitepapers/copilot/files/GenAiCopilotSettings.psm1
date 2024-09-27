# A PowerShell module that provides methods to query and update Copilot settings via the Power Platform Admin Center (PAC) CLI tool
#
# To install this module, use the following command:
# Install-Module .\GenAiCopilotSettings.psm1
# 
# You will need to authenticate with an identity that has Power Platform Admin rights to view all environments and update settings
#
# Also, you need to specify the cloud type (Public, UsGov, UsGovHigh, UsGovDod) when calling the functions

# If this is running in PowerShell 7, switch to legacy argument passing mode
if(test-Path variable:global:PSNativeCommandArgumentPassing){
    $PSNativeCommandArgumentPassing = 'Legacy'
}

# Lists all Copilot settings for all environments in the specified cloud type
function Get-AllCopilotSettings{
    param(
        [Parameter(Mandatory=$true)]
        [ValidateSet("Public", "UsGov", "UsGovHigh", "UsGovDod")]
        [string]$cloudType
    )

    # login to the PAC CLI tool first
    pac auth create --cloud $cloudType    

    # get all environments
    $allEnvironments = pac env list

    # skip the first line
    $envNameIndex = $allEnvironments[1].indexOf("Display Name")
    $envIdIndex = $allEnvironments[1].indexOf("Environment ID")
    $envStringLength = $envIdIndex - $envNameIndex

    # enumerate over all environemnts
    for ($i = 2; $i -lt $allEnvironments.Count; $i++) {
        # parse the current line
        $currentLine = $allEnvironments[$i]

        if  (($envIdIndex + 36) -le $currentLine.ToString().Length) {            
            $envName = $currentLine.Substring($envNameIndex, $envStringLength).Trim()
            $envId = $currentLine.Substring($envIdIndex, 36).Trim()

            # output the current environment
            Write-Output $envName, $envId

            # AI Prompts in Power Platform and Copilot Studio feature flag
            pac env list-settings --environment """$envId""" --filter "aipromptsenabled"

            # Enable the usage of AI Builder model types that are in preview
            pac env list-settings --environment """$envId""" --filter "paipreviewscenarioenabled"

            # Enable new AI-powered Copilot features for people who make apps
            pac env list-settings --environment """$envId""" --filter "powerappsmakerbotenabled"

            # Get the OrgDbOrgSettings xml value
            $rawSettingsValue = pac env list-settings --environment """$envId""" --filter "orgdborgsettings"
            $xmlStartIndex = $rawSettingsValue[2].IndexOf("<OrgSettings>")

            $parsedSettingsValue = $rawSettingsValue[2].Substring($xmlStartIndex)

            $settingsXml = [xml]$parsedSettingsValue

            Write-Output "OrgDbOrgSettings:"
            $settingsXml.OrgSettings.OuterXml

            Write-Output ""
        }
    }
}

# Disables all Copilot settings for the specified environment in the specified cloud type
function Disable-CopilotSettings{
    param(
        [Parameter(Mandatory=$true)]
        [string]$envName,

        [Parameter(Mandatory=$true)]
        [ValidateSet("Public", "UsGov", "UsGovHigh", "UsGovDod")]
        [string]$cloudType
    )

    # login to the PAC CLI tool first
    pac auth create --cloud UsGov

    # Set the current environment in the PAC CLI tool
    pac env select --environment """$envName"""

    # AI Prompts in Power Platform and Copilot Studio feature flag
    pac env update-settings --name aipromptsenabled --value false

    # Enable the usage of AI Builder model types that are in preview
    pac env update-settings --name paipreviewscenarioenabled --value false

    # Enable new AI-powered Copilot features for people who make apps
    pac env update-settings --name powerappsmakerbotenabled --value false

    # parse the OrgDbOrgSettings xml value
    $rawSettingsValue = pac env list-settings --filter orgdborgsettings
    $xmlStartIndex = $rawSettingsValue[2].IndexOf("<OrgSettings>")

    if($xmlStartIndex -eq -1) {
        Write-Host "OrgDbOrgSettings not found!"
        exit
    }

    $parsedSettingsValue = $rawSettingsValue[2].Substring($xmlStartIndex)

    $settingsXml = [xml]$parsedSettingsValue

    # check for existance of the IsDVCopilotForTextDataEnabled property
    # if it does not exist, create it and set it to false
    if ($null -eq (Select-Xml -Content $parsedSettingsValue -XPath "//IsDVCopilotForTextDataEnabled").Node) {
        $newElement = $settingsXml.CreateElement("IsDVCopilotForTextDataEnabled")
        $newElement.InnerText = "false"
        $settingsXml.OrgSettings.AppendChild($newElement)    
    }
    # if it already exists, set it to false
    else {
        $settingsXml.OrgSettings.IsDVCopilotForTextDataEnabled = "false"
    }

    # check for existance of the IsAiSuggestFormulaColumnEnabled property
    # if it does not exist, create it and set it to false
    if ($null -eq (Select-Xml -Content $parsedSettingsValue -XPath "//IsAiSuggestFormulaColumnEnabled").Node) {
        $newElement = $settingsXml.CreateElement("IsAiSuggestFormulaColumnEnabled")
        $newElement.InnerText = "false"
        $settingsXml.OrgSettings.AppendChild($newElement)  
    }
    # if it already exists, set it to false
    else {
        $settingsXml.OrgSettings.IsAiSuggestFormulaColumnEnabled = "false"
    }

    $newSettingsXmlStr = $settingsXml.OrgSettings.OuterXml

    # write back the updated OrgDbOrgSettings xml value
    pac org update-settings --value """$newSettingsXmlStr""" --name "orgdborgsettings"
}

# Export the functions in the module
Export-ModuleMember -Function Get-AllCopilotSettings, Disable-CopilotSettings