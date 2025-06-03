
<#
    .SYNOPSIS
        A universal function to interact with Azure DevOps REST API endpoints.
        
    .DESCRIPTION
        The `Invoke-BHRApiRequest` function allows interaction with any Azure DevOps REST API endpoint.
        It requires the organization, a valid authentication token, and the specific API URI.
        The project is optional and will only be included in the URL if specified.
        
    .PARAMETER UriQuery
        The specific Azure DevOps REST API URI to interact with (relative to the organization or project URL).
        
    .PARAMETER Method
        The HTTP method to use for the request (e.g., GET, POST, PUT, DELETE). Default is "GET".
        
    .PARAMETER Body
        The body content to include in the HTTP request (for POST/PUT requests).
        
    .PARAMETER Headers
        Additional headers to include in the request.
        
    .EXAMPLE
        Invoke-BHRApiRequest -UriQuery "employees/directory"
        
        This example retrieves test suites from the test plan with ID 123 in the specified organization.
        
    .NOTES
        - The function uses the Azure DevOps REST API.
        - An authentication token is required.
        - Handles pagination through continuation tokens.
        - Author: Oleksandr Nikolaiev
#>

function Invoke-BHRApiRequest {
    param (
        [Parameter(Mandatory = $false)]
        [string]$UriQuery = "",

        [Parameter()]
        [ValidateSet("GET", "POST", "PUT", "DELETE", "PATCH")]
        [string]$Method = "GET",

        [Parameter()]
        [string]$Body = $null,

        [Parameter()]
        [Hashtable]$Headers = @{}
    )
    begin {
        Invoke-TimeSignal -Start
        # Get the base URL from the settings
        $BHRapiUrl = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.url"
        $BHRCompanyDomain = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.companyDomain"
        $BHRapiVersion = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.apiVersion"
        $BHRApiKey = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.bamboohr.token"
        if (-not $BHRapiUrl -or -not $BHRCompanyDomain -or -not $BHRapiVersion -or -not $BHRApiKey) {
            Write-PSFMessage -Level Error -Message "BambooHR API URL, company domain, or API version is not configured. Please set 'ciellos.mdm.settings.all.bamboohr.url', 'ciellos.mdm.settings.all.bamboohr.companyDomain', and 'ciellos.mdm.settings.all.bamboohr.apiVersion' in the configuration."
            return
        }

        # Prepare Authorization Header

        $authHeader = @{ Authorization = "Basic $BHRApiKey" }

        # Merge additional headers
        $headers = $authHeader + $Headers

        $allResults = @()
        $requestUrl = ""

        if($BHRapiUrl.EndsWith("/")) {
            $BHRAPIUrl = $BHRapiUrl.Substring(0, $BHRapiUrl.Length - 1)
        }    
    }
    process {       

        try {
            $statusCode = $null  

            # Construct the full URL with API version and query
            $requestUrl =  "${$BHRapiUrl}/api/gateway.php/${$BHRCompanyDomain}/${BHRapiVersion}/${$UriQuery}"
            
            Write-PSFMessage -Level Verbose -Message "Request URL: $Method $requestUrl"

            if ($PSVersionTable.PSVersion.Major -ge 7) {
                $response = Invoke-RestMethod -Uri $requestUrl -Headers $headers -Method $Method.ToLower() -Body $Body -ResponseHeadersVariable responseHeaders -StatusCodeVariable statusCode
            } else {
                $response = Invoke-WebRequest -Uri $requestUrl -Headers $headers -Method $Method.ToLower() -Body $Body -UseBasicParsing
                $statusCode = $response.StatusCode
                $response = $response.Content | ConvertFrom-Json
            }
            
            if ($statusCode -in @(200, 201, 202, 204 )) {
                if ($response.value) {
                    $allResults += $response.value
                } else {
                    $allResults += $response
                }
                
            } else {
                Write-PSFMessage -Level Error -Message "The request failed with status code: $($statusCode)"
            }

            return @{
                Results = $allResults
                Count = $allResults.Count
            }
        } catch {
            Write-PSFMessage -Level Error -Message "Something went wrong during request to ADO: $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }
    end {
        Invoke-TimeSignal -End        
    }
}