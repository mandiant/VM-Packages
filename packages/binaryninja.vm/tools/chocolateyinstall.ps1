$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'binaryninja'
  $category = 'Disassemblers'

  $packageArgs = @{
    packageName  = ${Env:ChocolateyPackageName}
    fileType     = 'exe'
    silentArgs   = '/S /ALLUSERS=1'
    url          = 'https://cdn.binary.ninja/installers/binaryninja_free_win64.exe'
    checksum     = '426aa8219415a64df90562274ae7e420471934c60f3a19c459e982467469cf55'
    checksumType = 'sha256'
  }

  Install-ChocolateyPackage @packageArgs

  $toolDir = Join-Path ${Env:ProgramFiles} "Vector35"  -Resolve
  $toolDir = Join-Path $toolDir "BinaryNinja"  -Resolve
  $executablePath = Join-Path $toolDir "binaryninja.exe" -Resolve

  Install-BinFile -Name $toolname -Path $executablePath
  $executableIcon = Join-Path $toolDir "icon.ico" -Resolve
  VM-Install-Shortcut -toolName "binja" -category $category -executablePath $executablePath -IconLocation $executableIcon

} catch {
  VM-Write-Log-Exception $_
}
