
<#
    .SYNOPSIS
        Retrieves and processes MDM configuration settings from a JSON string or file path.
        
    .DESCRIPTION
        The Get-CieMDMSettings function retrieves MDM configuration settings either from a JSON string or a file path.
        It validates the input, processes the settings, and returns the configuration as an ordered hashtable.
        The function also supports additional configuration retrieval in a GitHub context.
        
    .PARAMETER SettingsJsonString
        A JSON string containing the MDM settings.
        
    .PARAMETER SettingsJsonPath
        The file path to a JSON file containing the MDM settings.
        
    .PARAMETER OutputAsHashtable
        Outputs the settings as a hashtable if specified.
        
    .EXAMPLE
        Get-CieMDMSettings -SettingsJsonString '{"key":"value"}'
        
    .EXAMPLE
        Get-CieMDMSettings -SettingsJsonPath "C:\path\to\settings.json"
        
    .NOTES
        Ensure that only one of the parameters, SettingsJsonString or SettingsJsonPath, is provided at a time.
        - Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Get-CieMDMSettings {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseOutputTypeCorrectly", "")]
    param (
        [string] $SettingsJsonString,
        [string] $SettingsJsonPath,
        [switch] $OutputAsHashtable
    )
    begin{
        Invoke-TimeSignal -Start   
        $helperPath = Join-Path -Path $($Script:ModuleRoot) -ChildPath "\internal\scripts\helpers.ps1" -Resolve
        . ($helperPath)    
        $res = [Ordered]@{}

        if((-not ($SettingsJsonString -eq "")) -and (-not ($SettingsJsonPath -eq "")))
        {
            throw "Both settings parameters should not be provided. Please provide only one of them."
        }

        if(-not ($SettingsJsonString -eq ""))
        {
            $tmpSettingsFilePath = "C:\temp\settings.json"
            $null = Test-PathExists -Path "C:\temp\" -Type Container -Create
            $null = Set-Content $tmpSettingsFilePath $SettingsJsonString -Force -PassThru
            $null = Set-FSCPSSettings -SettingsFilePath $tmpSettingsFilePath
        }

        if(-not ($SettingsJsonPath -eq ""))
        {
            $null = Set-FSCPSSettings -SettingsFilePath $SettingsJsonPath
        }        
    }
    process{         

        foreach ($config in Get-PSFConfig -FullName "ciellos.mdm.settings.all.*") {
            $propertyName = $config.FullName.ToString().Replace("ciellos.mdm.settings.all.", "")
            $res.$propertyName = $config.Value
        }
        if($Script:IsOnGitHub)# If GitHub context
        {
            foreach ($config in Get-PSFConfig -FullName "ciellos.mdm.settings.github.*") {
                $propertyName = $config.FullName.ToString().Replace("ciellos.mdm.settings.github.", "")
                $res.$propertyName = $config.Value
            }
        }
        if($Script:IsOnAzureDevOps)# If ADO context
        {
            foreach ($config in Get-PSFConfig -FullName "ciellos.mdm.settings.ado.*") {
                $propertyName = $config.FullName.ToString().Replace("ciellos.mdm.settings.ado.", "")
                $res.$propertyName = $config.Value
            }
        }
        if($Script:IsOnLocalhost)# If localhost context
        {
            foreach ($config in Get-PSFConfig -FullName "ciellos.mdm.settings.localhost.*") {
                $propertyName = $config.FullName.ToString().Replace("ciellos.mdm.settings.localhost.", "")
                $res.$propertyName = $config.Value
            }
        }
        if($OutputAsHashtable) {
            $res
        } else {
            [PSCustomObject]$res
        }   
       
    }
    end{
        Invoke-TimeSignal -End
    }

}