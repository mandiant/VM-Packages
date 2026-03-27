$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

try {
    $toolName = 'CAPEsolo'
    $category = VM-Get-Category($MyInvocation.MyCommand.Definition)
    $version = '==0.4.23'

    # Create output file to log python module installation details
    $outputFile = VM-New-Install-Log ${Env:VM_COMMON_DIR}
    Invoke-Expression "py -3.11 -W ignore -m pip install $toolName$version --disable-pip-version-check 2>&1 >> $outputFile"

    # Fetch the exact Scripts path for the 3.11 installation dynamically
    $pyPath = (Get-Command py).Source
    $toolPath = Join-Path (& $pyPath -3.11 -c "import site; print(site.getsitepackages()[0])") "Scripts\$toolName.exe"
    VM-Assert-Path $toolPath

    VM-Install-Shortcut -toolName $toolName -category $category -executablePath $pyPath -consoleApp $true -arguments "-3.11 `"$toolPath`""
} catch {
    VM-Write-Log-Exception $_
}
