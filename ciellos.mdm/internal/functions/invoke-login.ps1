
<#
    .SYNOPSIS
        Automates the login process to the LCS (Lifecycle Services) portal using Microsoft Playwright.
        
    .DESCRIPTION
        The Invoke-Login function automates the login process to the LCS (Lifecycle Services) portal.
        It retrieves the username and password from the PSFramework configuration, navigates to the login page,
        fills in the credentials, and saves the session cookies for future use. If the login is successful,
        it updates the browser context with a new session.
        
    .PARAMETER None
        This function does not take any parameters.
        
    .OUTPUTS
        None
        
    .EXAMPLE
        PS C:\> Invoke-Login
        
        Logs into the LCS portal using the credentials stored in the PSFramework configuration.
        
    .NOTES
        - This function depends on the Get-NewPage and Get-BrowserContext functions for browser management.
        - Ensure that Microsoft Playwright is properly installed and configured in your environment.
        - The username and password must be stored in the PSFramework configuration under the keys:
        "ciellos.mdm.settings.all.lcsUsername" and "ciellos.mdm.settings.all.lcsPassword".
        - The function uses the global variable $Script:CookiesPath to store session cookies.
        - Author: Oleksandr Nikolaiev (@onikolaiev)
        
    .LINK
        https://playwright.dev
#>
function Invoke-Login {
    [CmdletBinding()]
    param(
    )
    begin {
        Invoke-TimeSignal -Start
        $_page = Get-NewPage
        $lcsUsername = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.lcsUsername"
        $lcsPassword = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.lcsPassword"
    }
    process {
        # Navigate to the login page
        $_page.GotoAsync("https://lcs.dynamics.com/Logon/ADLogon").Wait()
        if($_page.Url -ne "https://lcs.dynamics.com/V2") {
        # Fill in the username/email field
            $_page.FillAsync("input[type='email']", "$lcsUsername").Wait()            
            # Click the "Next" button
            $_page.ClickAsync("input[type='submit']").Wait()            
            # Wait for the password field to appear
            $_page.WaitForSelectorAsync("input[type='password']").Wait()            
            # Fill in the password field
            $_page.FillAsync("input[type='password']", "$lcsPassword").Wait()            
            # Click the "Sign in" button
            $_page.ClickAsync("input[type='submit']").Wait()            
            $_page.ClickAsync("input[type='submit']").Wait()            
            # Wait for the login process to complete (adjust selector as needed)
            #$page.WaitForNavigationAsync().Wait()
            $_page.Context.StorageStateAsync(@{
                Path = $Script:CookiesPath
            }).Wait()
            #$Script:BrowserContext = Get-BrowserContext -NewSession
        }
           
    }
    end {
        Invoke-TimeSignal -End
    }    
}