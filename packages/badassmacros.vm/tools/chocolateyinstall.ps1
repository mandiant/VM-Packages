$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'BadAssMacros'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

$exeUrl = 'https://github.com/Inf0secRabbit/BadAssMacros/releases/download/v1.0/BadAssMacrosx64.exe'
$exeSha256 = 'aa1efdba79ca36fa9d6d4b64fbe29e2ea7bc8cff1053e21269b8788104d48e83'

VM-Install-Single-Exe $toolName $category $exeUrl -exeSha256 $exeSha256 -consoleApp $true
