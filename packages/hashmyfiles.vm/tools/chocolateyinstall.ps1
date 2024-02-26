$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'hashmyfiles'
  $category = 'File Information'

  $zipUrl = "https://www.nirsoft.net/utils/hashmyfiles.zip"
  $zipUrl_64 = "https://www.nirsoft.net/utils/hashmyfiles-x64.zip"

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipUrl_64 $zipUrl_64)[-1]
  VM-Add-To-Right-Click-Menu $toolName "HashMyFiles" "`"$executablePath`" /file `"%1`"" "$executablePath"
  VM-Add-To-Right-Click-Menu $toolName "HashMyFiles" "`"$executablePath`" /file `"%1`"" "$executablePath" -type "directory"
} catch {
  VM-Write-Log-Exception $_
}
