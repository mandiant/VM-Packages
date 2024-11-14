$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'die'
  $category = 'File Information'

  $zipUrl = 'https://github.com/horsicq/DIE-engine/releases/download/3.10/die_win32_portable_3.10_x86.zip'
  $zipSha256 = 'dbd639a9bebceaf84e63c47bdb4a64e3fbb7677ec834321fe9b8574fe7781b10'
  $zipUrl_64 = 'https://github.com/horsicq/DIE-engine/releases/download/3.10/die_win64_portable_3.10_x64.zip'
  $zipSha256_64 = '6e84ac8d3abdfba60078a36fa7f6b492b20c2af2c502e0a4579f41367ac37c80'

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64)[-1]
  VM-Add-To-Right-Click-Menu $toolName "detect it easy (DIE)" "`"$executablePath`" `"%1`"" "$executablePath"
} catch {
  VM-Write-Log-Exception $_
}
