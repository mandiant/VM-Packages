$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Windows Terminal'
  $category = 'Productivity Tools'
  $executableName = "wt.exe"

  $zipUrl = 'https://github.com/microsoft/terminal/releases/download/v1.19.10573.0/Microsoft.WindowsTerminal_1.19.10573.0_x64.zip'
  $zipSha256 = 'F756A41FA2DBEE274334CB49D93A84CB29E5DF0A2446FC79BF7ED9FFE8B49FFB'

  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  # Remove files from previous zips for upgrade
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  # Download and unzip
  $packageArgs = @{
      packageName    = ${Env:ChocolateyPackageName}
      unzipLocation  = $toolDir
      url            = $zipUrl
      checksum       = $zipSha256
      checksumType   = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  # GitHub ZIP files typically unzip to a single folder that contains the tools.
  $dirList = Get-ChildItem $toolDir -Directory
  $toolDir = Join-Path $toolDir $dirList[0].Name -Resolve

  $executablePath = Join-Path $toolDir $executableName -Resolve
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -runAsAdmin
} catch {
  VM-Write-Log-Exception $_
}