
<#
    .SYNOPSIS
        Creates a new browser page using Microsoft Playwright.
        
    .DESCRIPTION
        The Get-NewPage function creates a new browser page within the current browser context using Microsoft Playwright.
        If the browser context is not initialized or the browser is disconnected, it creates a new browser context session.
        It also ensures that any previously opened page is closed before creating a new one.
        
    .PARAMETER None
        This function does not take any parameters.
        
    .OUTPUTS
        [Microsoft.Playwright.IPage]
        Returns a new browser page object.
        
    .EXAMPLE
        PS C:\> Get-NewPage
        
        Creates a new browser page in the current browser context.
        
    .NOTES
        - This function depends on the Get-BrowserContext function to manage browser contexts.
        - Ensure that Microsoft Playwright is properly installed and configured in your environment.
        - The function uses global variables $Script:BrowserContext and $Script:CurrentPage to manage browser state.
        
    .LINK
        https://playwright.dev
#>
function Get-NewPage {

    [CmdletBinding()]
    [OutputType([Microsoft.Playwright.IPage])]
    param(
    )
    begin {
        Invoke-TimeSignal -Start

        if($Script:BrowserContext)
        {
            # Check if the browser context is null
            if(-not $Script:BrowserContext.Browser.IsConnected) {
                Get-BrowserContext -NewSession | Out-Null
            }
            if($Script:CurrentPage) {
                $Script:CurrentPage.CloseAsync().GetAwaiter().GetResult() | Out-Null
                $Script:CurrentPage = $null
            }
        }     
        else {
            Get-BrowserContext -NewSession | Out-Null
        }      
    }
    process {
        # Check if the browser context is null
        $_page = $Script:BrowserContext.NewPageAsync().Result
        return $_page
    }
    end {
        Invoke-TimeSignal -End
        $Script:CurrentPage = $_page
    }    
}