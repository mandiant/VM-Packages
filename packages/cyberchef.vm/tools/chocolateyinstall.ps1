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
    url           = 'https://github.com/gchq/CyberChef/releases/download/v10.19.0/CyberChef_v10.19.0.zip'
    checksum      = 'c9805866bb72842c94c8480d9aa1a13dfcce2218380d65c644740a5575db3a8f'
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
