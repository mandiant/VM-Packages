$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'dnSpy'
  $category = 'dotNet'

  $zipUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.5.0/dnSpy-netframework.zip"
  $zipSha256 = "5962e3cca902e650c61050e2a879af58b78eec91288b7a7b77a7bc761424a0ed"
  $toolDir = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256)[0]

  $toolNameX86 = "$toolName-x86"
  $executablePathX86 = Join-Path $toolDir "$toolNameX86.exe" -Resolve
  VM-Install-Shortcut $toolNameX86 $category $executablePathX86
  Install-BinFile -Name $toolNameX86 -Path $executablePathX86

  $toolNameConsole = "$toolName.Console"
  $executablePathConsole = Join-Path $toolDir "$toolNameConsole.exe" -Resolve
  VM-Install-Shortcut $toolNameConsole $category $executablePathConsole -consoleApp $true
  Install-BinFile -Name $toolNameConsole -Path $executablePathConsole
} catch {
  VM-Write-Log-Exception $_
}
