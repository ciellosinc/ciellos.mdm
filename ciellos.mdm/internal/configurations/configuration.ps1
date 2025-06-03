<#
This is an example configuration file

By default, it is enough to have a single one of them,
however if you have enough configuration settings to justify having multiple copies of it,
feel totally free to split them into multiple files.
#>

<#
# Example Configuration
Set-PSFConfig -Module 'ciellos.mdm' -Name 'Example.Setting' -Value 10 -Initialize -Validation 'integer' -Handler { } -Description "Example configuration setting. Your module can then use the setting using 'Get-PSFConfigValue'"
#>

Set-PSFConfig -Module 'ciellos.mdm' -Name 'Import.DoDotSource' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be dotsourced on import. By default, the files of this module are read as string value and invoked, which is faster but worse on debugging."
Set-PSFConfig -Module 'ciellos.mdm' -Name 'Import.IndividualFiles' -Value $false -Initialize -Validation 'bool' -Description "Whether the module files should be imported individually. During the module build, all module code is compiled into few files, which are imported instead by default. Loading the compiled versions is faster, using the individual files is easier for debugging and testing out adjustments."
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.headless' -Value $true -Initialize -Description 'Whether the module should run in headless mode. This is used to determine whether the module should use the GUI or not. The default is to use the GUI. This setting is used to determine whether the module should use the GUI or not.'

Set-PSFConfig -FullName "ciellos.mdm.path.sqlpackage" -Value "C:\Program Files (x86)\Microsoft SQL Server\140\DAC\bin\SqlPackage.exe" -Initialize -Description "Path to the default location where SqlPackage.exe is located."
Set-PSFConfig -FullName "ciellos.mdm.azure.common.oauth.token" -Value "https://login.microsoftonline.com/common/oauth2/token" -Initialize -Description "URI / URL for the Azure Active Directory OAuth 2.0 endpoint for tokens"

Set-PSFConfig -FullName 'ciellos.mdm.settings.all.mdmSettingsFile' -Value 'settings.json' -Initialize -Description 'The name of the file has custom fscps settings. JSON'

Set-PSFConfig -FullName 'ciellos.mdm.settings.github.runs-on' -Value '' -Initialize -Description 'Specifies which github runner will be used for all jobs in all workflows (except the Update FSC-PS System Files workflow). The default is to use the GitHub hosted runner Windows-latest. You can specify a special GitHub Runner for the build job using the GitHubRunner setting.'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.fscPsVer' -Value $script:ModuleVersion -Initialize -Description 'Version of the ciellos.mdm module'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.currentBranch' -Value '' -Initialize -Description 'The current execution branch name'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.sourceBranch' -Value '' -Initialize -Description 'The branch used to build and generate the package.'

Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoOwner' -Value '' -Initialize -Description 'The name of the repo owner. GitHub - repo owner. Azure - name of the organization'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoName' -Value '' -Initialize -Description 'The name of the repo. GitHub - name of the repo. Azure - name of the collection'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoProvider' -Value '' -Initialize -Description 'GitHub/AzureDevOps/Other'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repositoryRootPath' -Value '' -Initialize -Description 'Dynamics value. Contains the path to the root of the repo'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.runId' -Value '' -Initialize -Description 'GitHub/Azure run_id'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.repoToken' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.lcsUrl' -Value 'https://lcs.dynamics.com/' -Initialize -Description 'The URL of the LCS environment. This is used to connect to the LCS environment and perform actions on it. The default is https://lcs.dynamics.com/'

Set-PSFConfig -FullName 'ciellos.mdm.settings.github.githubRunner' -Value 'windows-latest' -Initialize -Description ''
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.workflowName' -Value '' -Initialize -Description 'The name of the GitHub Workflow/AzureDO Task'

Set-PSFConfig -FullName 'ciellos.mdm.settings.all.nugetPackagesPath' -Value 'NuGets' -Initialize -Description 'The name of the directory where Nuget packages will be stored'

Set-PSFConfig -FullName 'ciellos.mdm.settings.github.githubSecrets' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'ciellos.mdm.settings.github.githubAgentName' -Value '' -Initialize -Description 'Specifies which github runner will be used for the build/ci/deploy/release job in workflows. This is the most time consuming task. By default this job uses the Windows-latest github runner '

Set-PSFConfig -FullName 'ciellos.mdm.settings.all.lcsEnvironmentId' -Value '' -Initialize -Description 'The Guid of the LCS environment'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.lcsProjectId' -Value 123456 -Initialize -Description 'The ID of the LCS project'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.lcsClientId' -Value '' -Initialize -Description 'The ClientId of the Azure application what has access to the LCS'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.lcsUsername' -Value '' -Initialize -Description 'The GitHub secret name that contains the username that has at least Owner access to the LCS project. It is a highly recommend to create a separate AAD user for this purposes. E.g. lcsadmin@contoso.com'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.lcsPassword' -Value '' -Initialize -Description 'The GitHub secret name that contains the password of the LCS user.'

Set-PSFConfig -FullName 'ciellos.mdm.settings.all.azTenantId' -Value '' -Initialize -Description 'The Guid of the Azure tenant'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.azClientId' -Value '' -Initialize -Description 'The Guid of the AAD registered application'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.azClientSecret' -Value '' -Initialize -Description 'The github secret name that contains ClientSecret of the registered application'
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.azVmname' -Value '' -Initialize -Description ''
Set-PSFConfig -FullName 'ciellos.mdm.settings.all.azVmrg' -Value '' -Initialize -Description ''

Set-PSFConfig -FullName 'ciellos.mdm.settings.github.repoTokenSecretName' -Value 'REPO_TOKEN' -Initialize -Description ''
Set-PSFConfig -FullName 'ciellos.mdm.settings.github.secretsList' -Value @('nugetFeedPasswordSecretName','nugetFeedUserSecretName','lcsUsernameSecretname','lcsPasswordSecretname','azClientsecretSecretname','repoTokenSecretName','codeSignDigiCertUrlSecretName','codeSignDigiCertPasswordSecretName','codeSignDigiCertAPISecretName','codeSignDigiCertHashSecretName','codeSignKeyVaultClientSecretName') -Initialize -Description ''

Set-PSFConfig -FullName "ciellos.mdm.azure.storage.accounts" -Value @{} -Initialize -Description "Object that stores different Azure Storage Account and their details."
Set-PSFConfig -FullName "ciellos.mdm.active.azure.storage.account" -Value @{} -Initialize -Description "Object that stores the Azure Storage Account details that should be used during the module."

Set-PSFConfig -FullName "ciellos.mdm.settings.all.bamboohr.apikey" -Value "" -Initialize -Description "The API key for BambooHR. This is used to connect to the BambooHR API and perform actions on it."
Set-PSFConfig -FullName "ciellos.mdm.settings.all.bamboohr.url" -Value "https://api.bamboohr.com/" -Initialize -Description "The URL of the BambooHR environment. This is used to connect to the BambooHR environment and perform actions on it. The default is https://api.bamboohr.com/"
Set-PSFConfig -FullName "ciellos.mdm.settings.all.bamboohr.companyDomain" -Value "Ciellos" -Initialize -Description "The company domain for BambooHR. This is used to connect to the BambooHR environment and perform actions on it. The default is Ciellos"
Set-PSFConfig -FullName "ciellos.mdm.settings.all.bamboohr.apiVersion" -Value "v1" -Initialize -Description "The API version for BambooHR. This is used to connect to the BambooHR environment and perform actions on it. The default is v1."