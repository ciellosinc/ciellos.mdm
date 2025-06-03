
<#
    .SYNOPSIS
        Retrieves the employee directory from the BambooHR API.
        
    .DESCRIPTION
        The Get-CieBHREmployeeDirectory function fetches the employee directory from the BambooHR API using the configured API URL.
        It validates the API request, handles errors, and returns the employee data in a structured format. Logging is performed at each step for debugging and monitoring purposes.
        
    .PARAMETER None
        This function does not take any parameters.
        
    .EXAMPLE
        Get-CieBHREmployeeDirectory
        
    .NOTES
        Ensure that the BambooHR API URL is correctly configured using the Get-BHRapiUrl function.
        - Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-CieBHREmployeeDirectory {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [CmdletBinding()]
    param ()

    begin {
        Invoke-TimeSignal -Start
        
        # Log the start of the operation
        Write-PSFMessage -Level Verbose -Message "Gets employee directory from BambooHR API"
        $_apiQuery = "employees/directory"
    }

process {
        if (Test-PSFFunctionInterrupt) { return }      
        try {
            # Log the request details
            Write-PSFMessage -Level Verbose -Message "API Query: $_apiQuery"

            # Call the Invoke-ADOApiRequest function
            $response = Invoke-BHRApiRequest -UriQuery $_apiQuery `
                                             -Method "GET" `
                                             -Headers @{"Content-Type" = "application/json"}

            # Log the successful response
            Write-PSFMessage -Level Verbose -Message "Successfully retrieved employee directory from BambooHR API"
            return $response.Results | Select-PSFObject * 
        } catch {
            # Log the error
            Write-PSFMessage -Level Error -Message "Failed to retrieve  employee directory from BambooHR API: : $($_.ErrorDetails.Message)" -Exception $PSItem.Exception
            Stop-PSFFunction -Message "Stopping because of errors"
            return
        }
    }

    end {
        # Log the end of the operation
        Write-PSFMessage -Level Verbose -Message "Completed retrieving employee directory from BambooHR API"
        Invoke-TimeSignal -End
    }
}