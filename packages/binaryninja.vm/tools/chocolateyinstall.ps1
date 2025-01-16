$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = "binaryninja"
$category = "Disassemblers"
$installFile = "binaryninja_free_win64.exe"

function Get-CurrentHash {
  param (
    [string]$url      = "https://binary.ninja/js/hashes.json",
    [string]$installFile = $installFile
  )
  $json = Invoke-WebRequest -Uri $url
  $json = ConvertFrom-Json $json
  return $json.Hashes.$installFile
}

try {
  $url = "https://cdn.binary.ninja/installers/$installFile"
  $hash = Get-CurrentHash
  $toolDir = Join-Path ${Env:ProgramFiles} "Vector35"
  $toolDir = Join-Path $toolDir "BinaryNinja"
  $executablePath = Join-Path $toolDir "binaryninja.exe"

  VM-Install-With-Installer -toolName $toolName `
    -category $category `
    -fileType 'EXE' `
    -silentArgs '/S /ALLUSERS=1' `
    -executablePath $executablePath `
    -url $url `
    -sha256 $hash `
    -consoleApp $false

} catch {
  VM-Write-Log-Exception $_
}