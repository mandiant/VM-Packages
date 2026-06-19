$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'unipacker'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)
$version = '==1.0.8'

VM-Install-With-Pip -toolName $toolName -category $category -version $version -arguments '--help'

$outputFile = VM-New-Install-Log ${Env:VM_COMMON_DIR}

# Fix dependency conflict where cmd2 pulls in the deprecated and broken 'pyreadline' package on Windows/Python 3.13
Write-Host "[+] Cleaning up broken pyreadline and ensuring pyreadline3 is active..."
Start-Process -FilePath "cmd.exe" -ArgumentList "/c py -3.13 -m pip uninstall pyreadline -y --disable-pip-version-check >> `"$outputFile`" 2>&1" -NoNewWindow -Wait
Start-Process -FilePath "cmd.exe" -ArgumentList "/c py -3.13 -W ignore -m pip install --force-reinstall --disable-pip-version-check pyreadline3 >> `"$outputFile`" 2>&1" -NoNewWindow -Wait

# Fix dependency conflict where unipacker pulls in 'unicorn-unipacker' which conflicts with standard 'unicorn'
Write-Host "[+] Cleaning up unicorn-unipacker and restoring standard unicorn..."
Start-Process -FilePath "cmd.exe" -ArgumentList "/c py -3.13 -m pip uninstall unicorn-unipacker -y --disable-pip-version-check >> `"$outputFile`" 2>&1" -NoNewWindow -Wait
Start-Process -FilePath "cmd.exe" -ArgumentList "/c py -3.13 -W ignore -m pip install --force-reinstall --disable-pip-version-check unicorn >> `"$outputFile`" 2>&1" -NoNewWindow -Wait

# Re-apply the Python 3.13 monkey patch to readline.py
$sitePackages = py -3.13 -c "import site; print(site.getsitepackages()[1])"
$readlineFile = Join-Path $sitePackages "readline.py"
if (Test-Path $readlineFile) {
    $content = Get-Content $readlineFile -Raw
    if ($content -notmatch "backend = 'pyreadline'") {
        Add-Content -Path $readlineFile -Value "`n# Patch for Python 3.13`nbackend = 'pyreadline'"
        Write-Host "[+] Patch applied to: $readlineFile" -ForegroundColor Green
    } else {
        Write-Host "[+] readline.py already patched." -ForegroundColor Green
    }
} else {
    Write-Host "[!] Could not locate readline.py to apply Python 3.13 patch." -ForegroundColor Yellow
}


