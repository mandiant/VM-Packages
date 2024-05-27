$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'die'
  $category = 'File Information'

  $zipUrl = 'https://github.com/horsicq/DIE-engine/releases/download/3.09/die_win32_portable_3.09_x86.zip'
  $zipSha256 = '7cdc3c3e33e23cc04463dc2c463c5d9dd7f746ee5dbacb280657e29b5d75b39a'
  $zipUrl_64 = 'https://github.com/horsicq/DIE-engine/releases/download/3.09/die_win64_portable_3.09_x64.zip'
  $zipSha256_64 = '299ff9d91cead31c32926ecfb5f27d629d06997d259e70af8632044edaf27c9b'

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64)[-1]
  VM-Add-To-Right-Click-Menu $toolName "detect it easy (DIE)" "`"$executablePath`" `"%1`"" "$executablePath"
} catch {
  VM-Write-Log-Exception $_
}
