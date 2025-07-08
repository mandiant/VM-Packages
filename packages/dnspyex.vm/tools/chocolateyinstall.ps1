$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'dnSpy'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $zipUrl = "https://github.com/dnSpyEx/dnSpy/releases/download/v6.5.1/dnSpy-netframework.zip"
  $zipSha256 = "95816dae47093966ccdb780c063f71576640d85d3e8584de490be43b1452f4e4"
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
