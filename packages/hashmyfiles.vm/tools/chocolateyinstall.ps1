$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'hashmyfiles'
  $category = 'Utilities'

  $zipUrl = "https://www.nirsoft.net/utils/hashmyfiles.zip"
  $zipSha256 = "89db49ec6a3e50f1d76da97ac1289272d1b09b9a330d36f65fdbe1f010f1ae8b"
  $zipUrl_64 = "https://www.nirsoft.net/utils/hashmyfiles-x64.zip"
  $zipSha256_64 = "be2dc5b9613b72ca44e60b7a1b5332593a868079638ded37cc3ad120e7182b0b"

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl $zipSha256 $zipUrl_64 $zipSha256_64)[-1]
  VM-Add-To-Right-Click-Menu $toolName "HashMyFiles" "`"$executablePath`" `"%1`"" "file"
  VM-Add-To-Right-Click-Menu $toolName "HashMyFiles" "`"$executablePath`" `"%1`"" "directory"
} catch {
  VM-Write-Log-Exception $_
}