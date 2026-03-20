$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    # Use the 'py' launcher to dynamically get the exact 3.13 executable path
    $python313Path = py -3.13 -c "import sys; print(sys.executable)" 2>$null

    if (-not $python313Path -or -not (Test-Path $python313Path)) {
        throw "Python 3.13 path not found. Ensure it is installed and the 'py' launcher is available."
    }

    # Derive the pip path from the python executable path
    $pip313Path = Join-Path (Split-Path $python313Path) "Scripts\pip.exe"

    # Remove default python stubs created by Microsoft Store
    Remove-Item "$env:LOCALAPPDATA\Microsoft\WindowsApps\python*.exe" -Force -ErrorAction SilentlyContinue

    # Set all .py files to use the dynamically found Python 3.13 install
    VM-Set-Open-With-Association $python313Path ".py"

    # Re-add shim path to the top of the path to ensure it is found first
    $shimPath = Join-Path $Env:ChocolateyInstall "bin" -Resolve
    [Environment]::SetEnvironmentVariable("Path", "$shimPath;$Env:Path", "Machine")

    # Create the Symlinks in the Chocolatey bin folder (overwrites choco shims)
    $links = @{
        "python.exe" = $python313Path; "python3.exe" = $python313Path;
        "pip.exe" = $pip313Path; "pip3.exe" = $pip313Path
    }

    foreach ($link in $links.GetEnumerator()) {
        $linkDest = Join-Path $shimPath $link.Name
        if (Test-Path $linkDest) { Remove-Item $linkDest -Force }
        if (Test-Path $link.Value) { New-Item -ItemType SymbolicLink -Path $linkDest -Target $link.Value -Force | Out-Null }
    }

    # Force the global py launcher preference
    [Environment]::SetEnvironmentVariable("PY_PYTHON", "3.13", "Machine")

} catch {
    VM-Write-Log-Exception $_
}