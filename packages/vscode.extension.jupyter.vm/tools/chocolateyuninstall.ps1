$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$extensionId = 'ms-toolsai.jupyter'

code --uninstall-extension $extensionId
