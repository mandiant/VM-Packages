$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking

# It is safe to delete this registry key as it does not exist by default and it is
# not used within Flare-VM.

$regKeyPath = "HKLM:\SOFTWARE\WOW6432Node\Policies\Google\Chrome\ExtensionInstallForcelist"
Remove-Item -Path $regKeyPath -Recurse -Force -ea 0
