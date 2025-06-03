function Cleanup-Session{
    if($Script:CurrentPage)
    {
        $Script:CurrentPage.CloseAsync().GetAwaiter().GetResult() | Out-Null
        $Script:CurrentPage = $null
    }
    if($Script:BrowserContext) {
        $Script:BrowserContext.CloseAsync().GetAwaiter().GetResult() | Out-Null
        $Script:BrowserContext.DisposeAsync().GetAwaiter().GetResult() | Out-Null
        $Script:BrowserContext = $null
    }
    if($Script:Playwright) {
        $Script:Playwright.Dispose() | Out-Null
        $Script:Playwright = $null
    }
}

function Get-PWRequestOptions
{
    [CmdletBinding()]
    [OutputType([Microsoft.Playwright.APIRequestContextOptions])]
    param(
    )

    begin{
        Invoke-TimeSignal -Start
        # Ensure Playwright is initialized
        if (-not $Script:Playwright) {
            $Script:Playwright = [Microsoft.Playwright.Playwright]::CreateAsync().GetAwaiter().GetResult()
        }
        # Ensure the current page is set
        if (-not $Script:CurrentPage) {
            throw "CurrentPage is not set. Please ensure you have navigated to a valid page."
        }
    }
    process {
        if (Test-PSFFunctionInterrupt) { return }

        $_requestVerificationToken = $Script:CurrentPage.Locator("input[name='__RequestVerificationToken']").GetAttributeAsync("value").GetAwaiter().GetResult()
        $headers = [System.Collections.Generic.Dictionary[string, string]]::new()
        $headers.Add("__RequestVerificationToken", $_requestVerificationToken)
        $headers.Add("X-Requested-With", "XMLHttpRequest")
    
        # Create the request options
        $requestOptions = [Microsoft.Playwright.APIRequestContextOptions]::new()
        $requestOptions.Headers = $headers
        return $requestOptions
    }
    end {
        Invoke-TimeSignal -End
    }
}

