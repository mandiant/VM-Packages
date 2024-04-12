$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $toolName = 'PDBReSym'
  $category = 'Utilities'

  $zipUrl = 'https://github.com/mandiant/STrace/releases/download/v1.3.3/PDBReSym.zip'
  $zipSha256 = '803dfc0321581bc39001f050cdafe672e9e3247e96ffd42606fda3d641f0fd57'

  $executablePath = (VM-Install-From-Zip $toolName $category $zipUrl -zipSha256 $zipSha256 -consoleApp $true -innerFolder $false -arguments "--help")[-1]

  # Iterate through C:\Windows\System32 downloading all PDBs concurrently
  VM-Write-Log "INFO" "Iterating through C:\Windows\System32 downloading PDBs to C:\symbols"
  & $executablePath cachesyms
  # The downloaded symbols are store into C:\symbols
  VM-Assert-Path "C:\symbols"
} catch {
  VM-Write-Log-Exception $_
}
