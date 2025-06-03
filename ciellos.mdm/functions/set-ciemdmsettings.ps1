
<#
    .SYNOPSIS
        Sets and processes MDM configuration settings from a JSON string or file path.
        
    .DESCRIPTION
        The Set-CieMDMSettings function sets MDM configuration settings either from a JSON string or a file path.
        It validates the input, processes the settings, and merges them into an ordered dictionary.
        The function supports execution in different environments, including GitHub, Azure DevOps, and local desktop.
        
    .PARAMETER SettingsFilePath
        The file path to a JSON file containing the MDM settings.
        
    .PARAMETER SettingsJsonString
        A JSON string containing the MDM settings.
        
    .EXAMPLE
        Set-CieMDMSettings -SettingsJsonString '{"key":"value"}'
        
    .EXAMPLE
        Set-CieMDMSettings -SettingsFilePath "C:\path\to\settings.json"
        
    .NOTES
        Ensure that only one of the parameters, SettingsJsonString or SettingsFilePath, is provided at a time.
        - Author: Oleksandr Nikolaiev (@onikolaiev)
#>
function Set-CieMDMSettings {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseSingularNouns", "")]
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    param (
        [string] $SettingsFilePath,
        [string] $SettingsJsonString
    )
    begin{
        if((-not ($SettingsJsonString -eq "")) -and (-not ($SettingsFilePath -eq "")))
        {
            throw "Both settings parameters cannot be provided. Please provide only one of them."
        }

        if(-not ($SettingsJsonString -eq ""))
        {
            $SettingsFilePath = "C:\temp\settings.json"
            $null = Test-PathExists -Path "C:\temp\" -Type Container -Create
            $null = Set-Content $SettingsFilePath $SettingsJsonString -Force -PassThru
        }

        $fscpsFolderName = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.fscpsFolder"
        $fscmSettingsFile = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.mdmSettingsFile"
        $fscmRepoSettingsFile = Get-PSFConfigValue -FullName "ciellos.mdm.settings.all.fscpsRepoSettingsFile"
        Write-PSFMessage -Level Verbose -Message "fscpsFolderName is: $fscpsFolderName"
        Write-PSFMessage -Level Verbose -Message "fscmSettingsFile is: $fscmSettingsFile"
        Write-PSFMessage -Level Verbose -Message "fscmRepoSettingsFile is: $fscmRepoSettingsFile"
        $settingsFiles = @()
        $res = [Ordered]@{}

        $reposytoryName = ""
        $reposytoryOwner = ""
        $currentBranchName = ""

        
        if($Script:IsOnGitHub)# If GitHub context
        {
            Write-PSFMessage -Level Important -Message "Running on GitHub"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoProvider' -Value 'GitHub'
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repositoryRootPath' -Value "$env:GITHUB_WORKSPACE"            

            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.runId' -Value "$ENV:GITHUB_RUN_NUMBER"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.workflowName' -Value "$ENV:GITHUB_WORKFLOW"

            if($SettingsFilePath -eq "")
            {
                $RepositoryRootPath = "$env:GITHUB_WORKSPACE"
                Write-PSFMessage -Level Verbose -Message "GITHUB_WORKSPACE is: $RepositoryRootPath"
                
                $settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)
            }
            else{
                $settingsFiles += $SettingsFilePath
            }

            $reposytoryOwner = "$env:GITHUB_REPOSITORY".Split("/")[0]
            $reposytoryName = "$env:GITHUB_REPOSITORY".Split("/")[1]
            Write-PSFMessage -Level Verbose -Message "GITHUB_REPOSITORY is: $reposytoryName"
            $branchName = "$env:GITHUB_REF"
            Write-PSFMessage -Level Verbose -Message "GITHUB_REF is: $branchName"
            $currentBranchName = [regex]::Replace($branchName.Replace("refs/heads/","").Replace("/","_"), '(?i)(?:^|-|_)(\p{L})', { $args[0].Groups[1].Value.ToUpper()})      
            $gitHubFolder = ".github"

            $workflowName = "$env:GITHUB_WORKFLOW"
            Write-PSFMessage -Level Verbose -Message "GITHUB_WORKFLOW is: $workflowName"
            $workflowName = ($workflowName.Split([System.IO.Path]::getInvalidFileNameChars()) -join "").Replace("(", "").Replace(")", "").Replace("/", "")

            $settingsFiles += (Join-Path $gitHubFolder $fscmRepoSettingsFile)            
            $settingsFiles += (Join-Path $gitHubFolder "$workflowName.settings.json")
            
        }
        elseif($Script:IsOnAzureDevOps)# If Azure DevOps context
        {
            Write-PSFMessage -Level Verbose -Message "Running on Azure"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoProvider' -Value 'AzureDevOps'
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repositoryRootPath' -Value "$env:PIPELINE_WORKSPACE"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.runId' -Value "$ENV:Build_BuildNumber"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.workflowName' -Value "$ENV:Build_DefinitionName" 
            if($SettingsFilePath -eq "")
            {
                $RepositoryRootPath = "$env:PIPELINE_WORKSPACE"
                Write-PSFMessage -Level Verbose -Message "RepositoryRootPath is: $RepositoryRootPath"
            }
            else{
                $settingsFiles += $SettingsFilePath
            }
            
            $reposytoryOwner = $($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI.replace('https://dev.azure.com/', '').replace('/', '').replace('https:',''))
            $reposytoryName = "$env:SYSTEM_TEAMPROJECT"
            $branchName = "$env:BUILD_SOURCEBRANCH"
            $currentBranchName = [regex]::Replace($branchName.Replace("/Metadata","").Replace("$/$($reposytoryName)/","").Replace("$/$($reposytoryName)","").Replace("Trunk/","").Replace("/","_"), '(?i)(?:^|-|_)(\p{L})', { $args[0].Groups[1].Value.ToUpper() })   

            #$settingsFiles += (Join-Path $fscpsFolderName $fscmSettingsFile)

        }
        else { # If Desktop or other
            Write-PSFMessage -Level Verbose -Message "Running on desktop"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoProvider' -Value 'Other'
            if($SettingsFilePath -eq "")
            {
                throw "SettingsFilePath variable should be passed if running on the cloud/personal computer"
            }
            $reposytoryName = "windows host"
            Set-PSFConfig -FullName 'ciellos.mdm.settings.all.runId' -Value 1
            $currentBranchName = 'DEV'
            $settingsFiles += $SettingsFilePath
        }

        Set-PSFConfig -FullName 'ciellos.mdm.settings.all.currentBranch' -Value $currentBranchName
        Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoOwner' -Value $reposytoryOwner
        Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoName' -Value $reposytoryName

        
        function MergeCustomObjectIntoOrderedDictionary {
            Param(
                [System.Collections.Specialized.OrderedDictionary] $dst,
                [PSCustomObject] $src
            )
        
            # Add missing properties in OrderedDictionary

            $src.PSObject.Properties.GetEnumerator() | ForEach-Object {
                $prop = $_.Name
                $srcProp = $src."$prop"
                $srcPropType = $srcProp.GetType().Name
                if (-not $dst.Contains($prop)) {
                    if ($srcPropType -eq "PSCustomObject") {
                        $dst.Add("$prop", [ordered]@{})
                    }
                    elseif ($srcPropType -eq "Object[]") {
                        $dst.Add("$prop", @())
                    }
                    else {
                        $dst.Add("$prop", $srcProp)
                    }
                }
            }
        
            @($dst.Keys) | ForEach-Object {
                $prop = $_
                if ($src.PSObject.Properties.Name -eq $prop) {
                    $dstProp = $dst."$prop"
                    $srcProp = $src."$prop"
                    $dstPropType = $dstProp.GetType().Name
                    $srcPropType = $srcProp.GetType().Name
                    if($dstPropType -eq 'Int32' -and $srcPropType -eq 'Int64')
                    {
                        $dstPropType = 'Int64'
                    }
                    
                    if ($srcPropType -eq "PSCustomObject" -and $dstPropType -eq "OrderedDictionary") {
                        MergeCustomObjectIntoOrderedDictionary -dst $dst."$prop".Value -src $srcProp
                    }
                    elseif ($dstPropType -ne $srcPropType) {
                        throw "property $prop should be of type $dstPropType, is $srcPropType."
                    }
                    else {
                        if ($srcProp -is [Object[]]) {
                            $srcProp | ForEach-Object {
                                $srcElm = $_
                                $srcElmType = $srcElm.GetType().Name
                                if ($srcElmType -eq "PSCustomObject") {
                                    $ht = [ordered]@{}
                                    $srcElm.PSObject.Properties | Sort-Object -Property Name -Culture "iv-iv" | ForEach-Object { $ht[$_.Name] = $_.Value }
                                    $dst."$prop" += @($ht)
                                }
                                else {
                                    $dst."$prop" += $srcElm
                                }
                            }
                        }
                        else {
                            Write-PSFMessage -Level Verbose -Message "Searching ciellos.mdm.settings.*.$prop"
                            $setting = Get-PSFConfig -FullName "ciellos.mdm.settings.*.$prop"
                            Write-PSFMessage -Level Verbose -Message "Found  $setting"
                            if($setting)
                            {
                                Set-PSFConfig -FullName $setting.FullName -Value $srcProp
                            }
                            #$dst."$prop" = $srcProp
                        }
                    }
                }
            }
        }
    }
    process{
        Invoke-TimeSignal -Start    
        $res = Get-FSCPSSettings -OutputAsHashtable

        $settingsFiles | ForEach-Object {
            $settingsFile = $_
            if($RepositoryRootPath)
            {
                $settingsPath = Join-Path $RepositoryRootPath $settingsFile
            }
            else {
                $settingsPath = $SettingsFilePath
            }
            
            Write-PSFMessage -Level Verbose -Message "Settings file '$settingsFile' - $(If (Test-Path $settingsPath) {"exists. Processing..."} Else {"not exists. Skip."})"
            if (Test-Path $settingsPath) {
                try {
                    $settingsJson = Get-Content $settingsPath -Encoding UTF8 | ConvertFrom-Json
        
                    # check settingsJson.version and do modifications if needed
                    MergeCustomObjectIntoOrderedDictionary -dst $res -src $settingsJson
                }
                catch {
                    Write-PSFMessage -Level Host -Message "Settings file $settingsPath, is wrongly formatted." -Exception $PSItem.Exception
                    Stop-PSFFunction -Message "Stopping because of errors"
                    return
                    throw 
                }
            }
            Write-PSFMessage -Level Verbose -Message "Settings file '$settingsFile' - processed"
        }
        Write-PSFMessage -Level Host  -Message "Settings were updated succesfully."
        Invoke-TimeSignal -End
    }
    end{

    }

}