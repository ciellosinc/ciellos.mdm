# Script to generate the parameter unit tests.
# See also https://github.com/ciellosinc/fscps.tools/wiki/Building-tools
$path = "$PSScriptRoot\..\ciellos.mdm"

Import-Module $path -Force -ErrorAction SilentlyContinue

$excludeCommands = @()

$commandsRaw = Get-Command -Module ciellos.mdm -CommandType Function

if ($excludeCommands.Count -gt 0) {
    $commands = $commandsRaw | Select-String -Pattern $excludeCommands -SimpleMatch -NotMatch

} else {
    $commands = $commandsRaw
}

Remove-Item -Path "$path\tests\functions\*.Tests.ps1"
foreach ( $commandName in $commands) {
    Invoke-PSMDTemplate CommandTest -OutPath "$path\tests\functions" -Name $commandName -Force
}

Get-ChildItem -Path "$path\tests\functions" -Recurse -File | Set-PSMDEncoding