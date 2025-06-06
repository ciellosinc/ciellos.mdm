﻿$script:ModuleRoot = $PSScriptRoot
$script:ModuleVersion = (Import-PowerShellDataFile -Path "$($script:ModuleRoot)\ciellos.mdm.psd1").ModuleVersion
$Script:DefaultTempPath = "c:\temp\ciellos.mdm"
# Detect whether at some level dotsourcing was enforced
$script:doDotSource = Get-PSFConfigValue -FullName ciellos.mdm.Import.DoDotSource -Fallback $false
if ($ciellos.mdm_dotsourcemodule) { $script:doDotSource = $true }

<#
Note on Resolve-Path:
All paths are sent through Resolve-Path/Resolve-PSFPath in order to convert them to the correct path separator.
This allows ignoring path separators throughout the import sequence, which could otherwise cause trouble depending on OS.
Resolve-Path can only be used for paths that already exist, Resolve-PSFPath can accept that the last leaf my not exist.
This is important when testing for paths.
#>

# Detect whether at some level loading individual module files, rather than the compiled module was enforced
$importIndividualFiles = Get-PSFConfigValue -FullName ciellos.mdm.Import.IndividualFiles -Fallback $false
if ($ciellos.mdm_importIndividualFiles) { $importIndividualFiles = $true }
if (Test-Path (Resolve-PSFPath -Path "$($script:ModuleRoot)\..\.git" -SingleItem -NewChild)) { $importIndividualFiles = $true }
if (-not (Test-Path (Resolve-PSFPath "$($script:ModuleRoot)\commands.ps1" -SingleItem -NewChild))) { $importIndividualFiles = $true }

function Import-ModuleFile
{
	<#
		.SYNOPSIS
			Loads files into the module on module import.
		
		.DESCRIPTION
			This helper function is used during module initialization.
			It should always be dotsourced itself, in order to proper function.
			
			This provides a central location to react to files being imported, if later desired
		
		.PARAMETER Path
			The path to the file to load
		
		.EXAMPLE
			PS C:\> . Import-ModuleFile -File $function.FullName
	
			Imports the file stored in $function according to import policy
	#>
	[CmdletBinding()]
	Param (
		[string]
		$Path
	)
	
	$resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($Path).ProviderPath
	if ($doDotSource) { . $resolvedPath }
	else { $ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($resolvedPath))), $null, $null) }
}


if ($importIndividualFiles)
{
	# Execute Preimport actions
	. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\preimport.ps1"
	# Import all internal functions
	foreach ($function in (Get-ChildItem "$($script:ModuleRoot)\internal\functions" -Filter "*.ps1" -Recurse -ErrorAction Ignore))
	{
		. Import-ModuleFile -Path $function.FullName
	}

	# Import all public functions
	foreach ($function in (Get-ChildItem "$($script:ModuleRoot)\functions" -Filter "*.ps1" -Recurse -ErrorAction Ignore))
	{
		. Import-ModuleFile -Path $function.FullName
	}

	# Execute Postimport actions
	. Import-ModuleFile -Path "$($script:ModuleRoot)\internal\scripts\postimport.ps1"
}
else
{
	if (Test-Path (Resolve-PSFPath "$($script:ModuleRoot)\resourcesBefore.ps1" -SingleItem -NewChild))
	{
		. Import-ModuleFile -Path "$($script:ModuleRoot)\resourcesBefore.ps1"
	}

	. Import-ModuleFile -Path "$($script:ModuleRoot)\commands.ps1"

	if (Test-Path (Resolve-PSFPath "$($script:ModuleRoot)\resourcesAfter.ps1" -SingleItem -NewChild))
	{
		. Import-ModuleFile -Path "$($script:ModuleRoot)\resourcesAfter.ps1"
	}
}
$Script:BinFolder = "$($Script:ModuleRoot)\bin"


#endregion Load individual files
#region Load compiled code
"<compile code into here>"
#endregion Load compiled code