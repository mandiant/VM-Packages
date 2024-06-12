$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$extensionId = 'ms-python.python'
$extensionVersion = '2024.9.11621011'
$executablePath = Join-Path ${Env:ProgramFiles} "\Microsoft VS Code\bin\code.cmd" -Resolve

& $executablePath --install-extension $extensionId '@' $extensionVersion
