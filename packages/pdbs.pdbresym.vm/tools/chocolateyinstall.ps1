$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
  $executablePath = Join-Path ${Env:RAW_TOOLS_DIR} PDBReSym\PDBReSym.exe -Resolve
  $symbolsPath = "C:\symbols"

  $pdbs = @(
    @{ name = "x64"; path = "$env:windir\System32" },
    @{ name = ".NET"; path = "$env:windir\Microsoft.NET" },
    @{ name = "driver"; path = "$env:windir\System32\drivers" }
  )
  if (Get-OSArchitectureWidth -Compare 64) {
    $pdbs += @{ name = "x32"; path = "$env:windir\SysWOW64" }
  }

  ForEach ($pdb in $pdbs) {
    VM-Write-Log "INFO" "Iterating through $($pdb.path) downloading $($pdb.name) PDBs to $symbolsPath"
    & $executablePath cachesyms --sysdir $($pdb.path)
  }

  VM-Assert-Path $symbolsPath

  # Set _NT_SYMBOL_PATH to include the downloaded symbols
  $symbolsPath = "srv*c:\symbols*https://msdl.microsoft.com/download/symbols"
  [System.Environment]::SetEnvironmentVariable("_NT_SYMBOL_PATH", $symbolsPath, "Machine")
} catch {
  VM-Write-Log-Exception $_
}
