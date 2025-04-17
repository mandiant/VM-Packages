$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = "binaryninja"
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

try {
  $url = "https://cdn.binary.ninja/installers/$($toolName)_free_win64.exe"
  $executablePath = Join-Path ${Env:ProgramFiles} "Vector35\$toolName\$toolName.exe"

  VM-Install-With-Installer -toolName $toolName `
    -category $category `
    -fileType 'EXE' `
    -silentArgs '/S /ALLUSERS=1' `
    -executablePath $executablePath `
    -url $url `
    -consoleApp $false `
    -verifySignature

} catch {
  VM-Write-Log-Exception $_
}
