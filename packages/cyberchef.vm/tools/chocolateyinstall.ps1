$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $category = 'Utilities'
  $toolName = 'CyberChef'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/gchq/CyberChef/releases/download/v10.19.4/CyberChef_v10.19.4.zip'
    checksum      = '3788b29ffb54f5784968fcf998286f0f75670be8a92e40eb683743ebaab97510'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $chromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
  $cyberchefPath = Get-Item "$toolDir\CyberChef*.html"
  $iconLocation = VM-Create-Ico (Join-Path $toolDir "images\cyberchef-128x128.png")
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $chromePath -arguments "-home $cyberchefPath" -iconLocation $iconLocation
} catch {
  VM-Write-Log-Exception $_
}
