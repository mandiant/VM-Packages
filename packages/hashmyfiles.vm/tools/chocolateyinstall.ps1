$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'HashMyFiles'
  $category = VM-Get-Category($MyInvocation.MyCommand.Definition)

  $zipUrl = "https://www.nirsoft.net/utils/hashmyfiles.zip"
  $zipUrl_64 = "https://www.nirsoft.net/utils/hashmyfiles-x64.zip"

  $toolDir, $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipUrl_64 $zipUrl_64)
  VM-Add-To-Right-Click-Menu $toolName $toolName "`"$executablePath`" /file `"%1`"" "$executablePath"
  VM-Add-To-Right-Click-Menu $toolName $toolName "`"$executablePath`" /file `"%1`"" "$executablePath" -type "directory"

  # Copy configuration file to tool directory
  $packageToolDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Copy-Item "$packageToolDir\$toolName.cfg" -Destination $toolDir
} catch {
  VM-Write-Log-Exception $_
}
