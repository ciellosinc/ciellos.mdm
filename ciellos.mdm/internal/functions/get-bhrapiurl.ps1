
<#
    .SYNOPSIS
        Retrieves the BambooHR API URL based on the configured settings.
        
    .DESCRIPTION
        The Get-BHRAPIUrl function constructs the BambooHR API URL using configuration values for the base URL, company domain, and API version.
        It validates the presence of required settings and formats the URL accordingly. If the configuration is missing, an error message is displayed.
        
    .PARAMETER None
        This function does not take any parameters.
        
    .EXAMPLE
        Get-BHRAPIUrl
        
    .NOTES
        Ensure that the following configuration settings are properly set:
        - ciellos.mdm.settings.all.bamboohr.url
        - ciellos.mdm.settings.all.bamboohr.companyDomain
        - ciellos.mdm.settings.all.bamboohr.apiVersion
        - Author: Oleksandr Nikolaiev (@onikolaiev)
#>

function Get-BHRapiUrl {
    [CmdletBinding()]
    param (
        [string] $URIQuery = ""
    )

    # Get the base URL from the settings
    $BHRapiUrl = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.url"
    if($BHRapiUrl.EndsWith("/")) {
        $BHRAPIUrl = $BHRapiUrl.Substring(0, $BHRapiUrl.Length - 1)
    }
    
    $BHRCompanyDomain = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.companyDomain"
    $BHRapiVersion = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.apiVersion"

    if (-not $BHRAPIUrl) {
        Write-PSFMessage -Level Error -Message "BambooHR API URL is not configured. Please set 'ciellos.mdm.settings.all.bamboohr.url' in the configuration."
        return
    }    



    # Return the formatted URL
    return $resultUrl
}