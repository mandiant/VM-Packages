$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $category = 'Documents'
    $zipUrl = 'https://github.com/DidierStevens/Beta/archive/cbb1d5c32d02b4e07128a197c8b8fb6ea597916a.zip'
    $zipSha256 = 'e9d83063f45f8e2791d33de194a46850bd7f1921e755bd4651c769cbcdbd5052'

    $packageArgs = @{
        packageName    = ${Env:ChocolateyPackageName}
        unzipLocation  = ${Env:RAW_TOOLS_DIR}
        url            = $zipUrl
        checksum       = $zipSha256
        checksumType   = 'sha256'
    }
    Install-ChocolateyZipPackage @packageArgs
    $toolDir = Get-Item "${Env:RAW_TOOLS_DIR}\Beta-*"
    VM-Assert-Path $toolDir

    # Add shortcut for commonly used office python tools
    ForEach ($toolName in @('onedump')) {
      $executablePath = (Get-Command python).Source
      $filePath = Join-Path $toolDir "$toolName.py"
      $arguments = $filePath + " --help"
      VM-Install-Shortcut $toolName $category $executablePath -consoleApp $true -arguments $arguments
    }

    # Add tools to Path
    VM-Add-To-Path $toolDir
} catch {
  VM-Write-Log-Exception $_
}
