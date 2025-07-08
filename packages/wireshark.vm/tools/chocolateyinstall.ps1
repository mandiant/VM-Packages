$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'Wireshark'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $shortcutDir = Join-Path ${Env:TOOL_LIST_DIR} $category
  $shortcut = Join-Path $shortcutDir "$toolName.lnk"
  $executablePath = Join-Path ${Env:ProgramFiles} "Wireshark\$toolName.exe" -Resolve
  Install-ChocolateyShortcut -shortcutFilePath $shortcut -targetPath $executablePath -RunAsAdmin
  VM-Assert-Path $shortcut

  # Add tshark (installed by Wireshark) to PATH and to Tools directory
  $toolName = 'tshark'
  $executablePath = Join-Path ${Env:ProgramFiles} "Wireshark\$toolName.exe" -Resolve
  Install-BinFile -Name $toolname -Path $executablePath
  VM-Install-Shortcut -toolName $toolName -category $category -executablePath $executablePath -consoleApp $true -arguments "--help"
} catch {
  VM-Write-Log-Exception $_
}
