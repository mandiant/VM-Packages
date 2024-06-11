$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$extensionId = 'ms-python.python'

code --uninstall-extension $extensionId
