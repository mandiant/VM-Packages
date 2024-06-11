$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$extensionId = 'ms-toolsai.jupyter'
$extensionVersion = '2024.6.2024060601'
$executablePath = Join-Path ${Env:ProgramFiles} "\Microsoft VS Code\bin\code.cmd" -Resolve

& $executablePath --install-extension $extensionId '@' $extensionVersion
