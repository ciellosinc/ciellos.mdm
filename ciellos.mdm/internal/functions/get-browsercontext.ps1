
<#
    .SYNOPSIS
        Retrieves or creates a browser context using Microsoft Playwright.
        
    .DESCRIPTION
        The Get-BrowserContext function retrieves the current browser context or creates a new one using Microsoft Playwright.
        It supports creating a new session by closing and disposing of the existing browser context. The function also
        uses a storage state file (cookies) if available to maintain session persistence.
        
    .PARAMETER NewSession
        A switch parameter. If specified, a new browser session is created by closing and disposing of the existing browser context.
        
    .OUTPUTS
        [Microsoft.Playwright.IBrowserContext]
        Returns an instance of the browser context.
        
    .EXAMPLE
        PS C:\> Get-BrowserContext
        
        Retrieves the current browser context or creates a new one if none exists.
        
    .EXAMPLE
        PS C:\> Get-BrowserContext -NewSession
        
        Creates a new browser session by closing and disposing of the existing browser context.
        
    .NOTES
        - This function depends on Microsoft Playwright for browser automation.
        - Ensure that Microsoft Playwright is properly installed and configured in your environment.
        - The function uses the global variables $Script:Playwright, $Script:BrowserContext, and $Script:CookiesPath.
        - Author: Oleksandr Nikolaiev (@onikolaiev)
        
    .LINK
        https://playwright.dev
#>
function Get-BrowserContext {    [CmdletBinding()]
    [OutputType([Microsoft.Playwright.IBrowserContext])]
    param(
        [Parameter(Mandatory=$false)]
        [switch]$NewSession    )
    begin {
        Invoke-TimeSignal -Start
        if(-not $Script:Playwright) {
            $Script:Playwright = [Microsoft.Playwright.Playwright]::CreateAsync().GetAwaiter().GetResult()
        }
        
        $_browserContext = $Script:BrowserContext
        if($NewSession)
        {
            if($_browserContext) {
                $_browserContext.CloseAsync().GetAwaiter().GetResult() | Out-Null
                $_browserContext.DisposeAsync().GetAwaiter().GetResult() | Out-Null
            }
            
            $_browserContext = $null
        }
        $_headless =  Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.headless"
    }
    process {
        if (-not $_browserContext) {                        
            $browser = $Script:Playwright.Chromium.LaunchAsync([Microsoft.Playwright.BrowserTypeLaunchOptions]@{ Headless = $_headless }).Result
    
            if(Test-Path $Script:CookiesPath) {
                $_browserContext = $browser.NewContextAsync(@{
                    StorageStatePath = $Script:CookiesPath
                }).GetAwaiter().GetResult()
            }
            else {
                $_browserContext = $browser.NewContextAsync().GetAwaiter().GetResult()
            }
            
        }
        return $_browserContext
    }
    end {
        Invoke-TimeSignal -End
        $Script:BrowserContext = $_browserContext
    }    
}