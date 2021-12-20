$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'die'
  $category = 'Utilities'

  $zipUrl = 'https://github.com/horsicq/DIE-engine/releases/download/3.02/die_win32_portable_3.02.zip'
  $zipSha256 = '00e01b28e50d32673d59d09f1e33457639a722aabec9f12c832e738e104fdf5b'
  $zipUrl_64 = 'https://github.com/horsicq/DIE-engine/releases/download/3.02/die_win64_portable_3.02.zip'
  $zipSha256_64 = '1ffd192e0f8120691e5c2c018c05245c6761d8aa01695807257044c82a676f27'

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -zipUrl_64 $zipUrl_64 -zipSha256_64 $zipSha256_64 -innerFolder $true)[-1]
  VM-Add-To-Right-Click-Menu $toolName "detect it easy (DIE)" "`"$executablePath`" `"%1`"" "file"
} catch {
  VM-Write-Log-Exception $_
}
