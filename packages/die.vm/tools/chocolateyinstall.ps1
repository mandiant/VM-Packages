$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'die'
  $category = 'Utilities'

  $zipUrl = 'https://github.com/horsicq/DIE-engine/releases/download/3.07/die_win32_portable_3.07.zip'
  $zipSha256 = 'c7f16841df475d6f09d37cf745804c866c823876c4605b5958376402cbb64eca'
  $zipUrl_64 = 'https://github.com/horsicq/DIE-engine/releases/download/3.07/die_win64_portable_3.07.zip'
  $zipSha256_64 = '3450169643be76484ac4bd5e1473f6f4745d9825c8a07255a3925a4a6e8bad7e'

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64)[-1]
  VM-Add-To-Right-Click-Menu $toolName "detect it easy (DIE)" "`"$executablePath`" `"%1`"" "$executablePath"
} catch {
  VM-Write-Log-Exception $_
}
