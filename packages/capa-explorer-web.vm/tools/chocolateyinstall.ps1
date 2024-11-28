$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  VM-Remove-PreviousZipPackage ${Env:chocolateyPackageFolder}

  $category = 'Utilities'
  $toolName = 'capa-explorer-web'
  $toolDir = Join-Path ${Env:RAW_TOOLS_DIR} $toolName

  $packageArgs = @{
    packageName   = ${Env:ChocolateyPackageName}
    unzipLocation = $toolDir
    url           = 'https://github.com/mandiant/capa/raw/refs/heads/master/web/explorer/releases/capa-explorer-web-v1.0.0-6a2330c.zip'
    checksum      = '3a7cf6927b0e8595f08b685669b215ef779eade622efd5e8d33efefadd849025'
    checksumType  = 'sha256'
  }
  Install-ChocolateyZipPackage @packageArgs
  VM-Assert-Path $toolDir

  $chromePath = "${env:ProgramFiles}\Google\Chrome\Application\chrome.exe"
  $capaWebPath = Get-Item "$toolDir\$toolName\*.html"
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $chromePath -arguments "-home $capaWebPath"
} catch {
  VM-Write-Log-Exception $_
}
