$ErrorActionPreference = 'Stop'
Import-Module vm.common -Force -DisableNameChecking

$toolName = 'unpy2exe'
$category = VM-Get-Category($MyInvocation.MyCommand.Definition)

# Create output file to log python module installation details
$outputFile = VM-New-Install-Log ${Env:VM_COMMON_DIR}
Invoke-Expression "py -3.11 -W ignore -m pip install $toolName  --disable-pip-version-check 2>&1 >> $outputFile"

$pyPath = (Get-Command py).Source
VM-Install-Shortcut -toolName $toolName -category $category -executablePath $pyPath -consoleApp $true -arguments "-3.11 -m unpy2exe"
