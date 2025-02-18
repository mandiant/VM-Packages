$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BinDiff'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/google/bindiff/releases/download/v8/bindiff8.msi'
$exeSha256 = '688831e490bef8a20c9917048b693bad591f346b3b96489fc79ad8d20d7cb15f'

$toolDir = Join-Path ${Env:ProgramFiles} $toolName
$executablePath = Join-Path $toolDir "bin\bindiff_ui.cmd"

VM-Install-With-Installer -toolName $toolName -category $category -fileType "MSI" -silentArgs '/qn /norestart' -executablePath $executablePath -url $exeUrl -sha256 $exeSha256 -consoleApp $false
