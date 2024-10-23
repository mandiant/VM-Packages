$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

$regKeyPath = "HKLM:\SOFTWARE\WOW6432Node\Policies\Google\Chrome\ExtensionInstallForcelist"
Remove-Item -Path $regKeyPath -Recurse -Force -ea 0
