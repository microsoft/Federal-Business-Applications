# Power BI Desktop Registry Setting for Sovereign Clouds
Power BI Desktop uses a global discovery endpoint to route users to the correct sovereign cloud environments for customers in our US Government clouds.  If you want to bypass using this global discovery endpoint, you can use the following registry key settings,

## GCC

````
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Power BI]
"PowerBIDiscoveryUrl"="https://api.powerbigov.us"

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Microsoft\Microsoft Power BI]
"PowerBIDiscoveryUrl"="https://api.powerbigov.us"
````
GCC Sample Registry Key File =>

https://github.com/microsoft/Federal-Business-Applications/blob/master/whitepapers/power-bi-registry-settings/PowerBIDesktop_GCC.reg

## GCC High
````
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Power BI]
"PowerBIDiscoveryUrl"="https://api.high.powerbigov.us"

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Microsoft\Microsoft Power BI]
"PowerBIDiscoveryUrl"="https://api.high.powerbigov.us"
````
GCC High Sample Registry Key File =>

https://github.com/microsoft/Federal-Business-Applications/blob/master/whitepapers/power-bi-registry-settings/PowerBIDesktop_GCCH.reg

## DOD
````
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft Power BI]
"PowerBIDiscoveryUrl"="https://api.mil.powerbigov.us"

[HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Policies\Microsoft\Microsoft Power BI]
"PowerBIDiscoveryUrl"="https://api.mil.powerbigov.us"
````
DOD Sample Registry Key File =>

https://github.com/microsoft/Federal-Business-Applications/blob/master/whitepapers/power-bi-registry-settings/PowerBIDesktop_DOD.reg
