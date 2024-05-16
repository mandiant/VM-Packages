$ErrorActionPreference = 'Continue'
Import-Module vm.common -Force -DisableNameChecking
VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}
