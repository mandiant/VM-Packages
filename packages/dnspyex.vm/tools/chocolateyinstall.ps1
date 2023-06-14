$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'dnSpy'
  $category = 'dotNet'

  $zipUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.4.0/dnSpy-netframework.zip"
  $zipSha256 = "103233b20688839046221bd1d0bd145c820e6a145e39a2c6c63a1ca360f230b8"
  $toolDir = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256)[0]

  $toolNameX86 = "$toolName-x86"
  $executablePathX86 = Join-Path $toolDir "$toolNameX86.exe" -Resolve
  VM-Install-Shortcut $toolNameX86 $category $executablePathX86
  Install-BinFile -Name $toolNameX86 -Path $executablePathX86

  $toolNameConsole = "$toolName.Console"
  $executablePathConsole = Join-Path $toolDir "$toolNameConsole.exe" -Resolve
  VM-Install-Shortcut $toolNameConsole $category $executablePathConsole -consoleApp $true -arguments $null
  Install-BinFile -Name $toolNameConsole -Path $executablePathConsole
} catch {
  VM-Write-Log-Exception $_
}
