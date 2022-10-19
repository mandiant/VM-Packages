$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $installDir = "${Env:SystemDrive}\Python27"
  $installArgs  = '/qn /norestart ALLUSERS=1 ADDLOCAL=Extensions TargetDir="{0}"' -f $installDir

  $params = @{
    packageName    = ${Env:ChocolateyPackageName}
    fileType       = 'msi'
    silentArgs     = $installArgs
    url            = 'https://www.python.org/ftp/python/2.7.18/python-2.7.18.msi'
    checksum       = 'D901802E90026E9BAD76B8A81F8DD7E43C7D7E8269D9281C9E9DF7A9C40480A9'
    checksumType   = 'sha256'
  }
  Install-ChocolateyPackage @params
  VM-Assert-Path $installDir
} catch {
  VM-Write-Log-Exception $_
}