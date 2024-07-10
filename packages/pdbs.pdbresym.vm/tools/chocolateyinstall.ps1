$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $executablePath = Join-Path ${Env:RAW_TOOLS_DIR} PDBReSym\PDBReSym.exe -Resolve

  VM-Write-Log "INFO" "Iterating through C:\Windows\System32 downloading PDBs to C:\symbols"
  & $executablePath cachesyms

  VM-Write-Log "INFO" "Iterating through  C:\Windows\Microsoft.NET downloading .NET PDBs to C:\symbols"
  & $executablePath cachesyms --sysdir "C:\Windows\Microsoft.NET"

  # The downloaded symbols are store into C:\symbols
  VM-Assert-Path "C:\symbols"

  # Set _NT_SYMBOL_PATH to include the downloaded symbols
  $symbolsPath = "srv*c:\symbols*https://msdl.microsoft.com/download/symbols"
  [System.Environment]::SetEnvironmentVariable("_NT_SYMBOL_PATH", $symbolsPath, "Machine")
} catch {
  VM-Write-Log-Exception $_
}
