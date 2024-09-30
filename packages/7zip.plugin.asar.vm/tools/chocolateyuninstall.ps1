$ErrorActionPreference = 'Continue'

$toolName = "Asar"
$pluginsDir = Join-Path ${Env:ProgramFiles} "7-Zip\Formats"
Remove-Item (Join-Path $pluginsDir "$toolName.64.dll") -Force -ea 0
