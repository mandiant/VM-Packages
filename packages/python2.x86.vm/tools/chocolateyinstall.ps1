$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $installDir = "${Env:SystemDrive}\Python27.x86"
  $installArgs  = '/qn /norestart ALLUSERS=1 ADDLOCAL=Extensions TargetDir="{0}"' -f $installDir

  $params = @{
    packageName    = ${Env:ChocolateyPackageName}
    fileType       = 'msi'
    silentArgs     = $installArgs
    url            = 'https://www.python.org/ftp/python/2.7.15/python-2.7.15.msi'
    checksum       = '1AFA1B10CF491C788BAA340066A813D5EC6232561472CFC3AF1664DBC6F29F77'
    checksumType   = 'sha256'
  }
  Install-ChocolateyPackage @params
  VM-Assert-Path $installDir
} catch {
  VM-Write-Log-Exception $_
}